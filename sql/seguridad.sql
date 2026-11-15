-- =============================================================
--  MIRA — ANTISPAM, DUPLICADOS Y PRIVACIDAD DE LA UBICACIÓN
--  Copia TODO en: SQL Editor → New query → Run   (solo una vez)
-- =============================================================


-- 1) Marca de revisión: el sistema avisa por qué conviene mirar un caso
alter table public.reportes add column revisar text;


-- 2) Las coordenadas que ya están guardadas se redondean a ~1 km
--    (2 decimales). A partir de ahora el sitio ya las manda redondeadas.
update public.reportes
   set lat = round(lat::numeric, 2),
       lng = round(lng::numeric, 2);


-- 3) Registro de envíos, solo para frenar el spam.
--    NO guarda la dirección IP: guarda una huella irreversible de ella.
create table public.envios (
  huella text not null,
  creado timestamptz not null default now()
);
create index envios_creado_idx on public.envios (creado desc);
alter table public.envios enable row level security;
-- Sin políticas: nadie puede leerla ni escribirla desde la app.
-- Solo la función de abajo la toca.


-- 4) Antes de guardar un caso: límite por hora y aviso de duplicados
create function public.revisar_envio()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  ip      text;
  v_huella text;
  recientes int;
begin
  -- La IP llega en las cabeceras de la petición; la convertimos en huella
  ip := split_part(coalesce(
          (current_setting('request.headers', true)::json ->> 'x-forwarded-for'),
          'desconocida'), ',', 1);
  v_huella := md5('mira-salt-2026|' || ip);

  -- Máximo 5 envíos por hora desde el mismo lugar
  select count(*) into recientes
    from public.envios e
   where e.huella = v_huella
     and e.creado > now() - interval '1 hour';

  if recientes >= 5 then
    raise exception 'limite_envios'
      using hint = 'Has enviado demasiados casos en poco tiempo. Intenta más tarde.';
  end if;

  insert into public.envios (huella) values (v_huella);
  delete from public.envios where creado < now() - interval '7 days';

  -- ¿Ya hay un caso del mismo lugar y el mismo día? Se marca para revisar.
  if exists (
    select 1 from public.reportes r
     where r.borrado_el is null
       and lower(r.lugar) = lower(new.lugar)
       and r.fecha::date = new.fecha::date
  ) then
    new.revisar := 'posible duplicado';
  end if;

  -- Descripciones muy cortas también se marcan
  if char_length(trim(new.descripcion)) < 25 then
    new.revisar := coalesce(new.revisar || ' · ', '') || 'descripción muy corta';
  end if;

  return new;
end;
$$;

create trigger revisar_envio_trigger
  before insert on public.reportes
  for each row execute function public.revisar_envio();
