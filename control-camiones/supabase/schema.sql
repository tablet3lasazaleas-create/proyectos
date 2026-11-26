-- Ejecutar una vez en el SQL Editor del proyecto Supabase.
create table if not exists public.truck_app_state (
  id text primary key check (id = 'shared'),
  state jsonb not null default '{"trucks":[],"records":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Lista de cuentas autorizadas. Agrega aquí los UUID de los usuarios desde SQL Editor.
create table if not exists public.truck_app_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.truck_app_state enable row level security;
alter table public.truck_app_users enable row level security;
revoke all on public.truck_app_state from anon;
revoke all on public.truck_app_users from anon;
grant select, insert, update on public.truck_app_state to authenticated;
grant select on public.truck_app_users to authenticated;

drop policy if exists "Authorized app users can read shared truck state" on public.truck_app_state;
drop policy if exists "Authorized app users can insert shared truck state" on public.truck_app_state;
drop policy if exists "Authorized app users can update shared truck state" on public.truck_app_state;
drop policy if exists "Users can check their own app access" on public.truck_app_users;

create policy "Authorized app users can read shared truck state"
  on public.truck_app_state for select to authenticated
  using (exists (select 1 from public.truck_app_users u where u.user_id = (select auth.uid())));
create policy "Authorized app users can insert shared truck state"
  on public.truck_app_state for insert to authenticated
  with check (exists (select 1 from public.truck_app_users u where u.user_id = (select auth.uid())));
create policy "Authorized app users can update shared truck state"
  on public.truck_app_state for update to authenticated
  using (exists (select 1 from public.truck_app_users u where u.user_id = (select auth.uid())))
  with check (exists (select 1 from public.truck_app_users u where u.user_id = (select auth.uid())));
create policy "Users can check their own app access"
  on public.truck_app_users for select to authenticated using (user_id = (select auth.uid()));

-- Después de crear cada usuario en Authentication > Users, autorízalo así:
-- insert into public.truck_app_users (user_id) values ('UUID-DEL-USUARIO');
