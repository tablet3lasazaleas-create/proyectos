-- Ejecutar en el SQL Editor del proyecto Supabase edakzkemdlgsbirikems.
-- Solo permite leer y modificar la nómina a usuarios que ya están autorizados
-- en public.truck_app_users.
create table if not exists public.attendance_app_state (
  id text primary key check (id = 'shared'),
  state jsonb not null default '{"employees":[],"days":[],"settings":{"regularHours":8,"unpaidBreakMinutes":0,"paidDaysPerWeek":6,"payday":6}}'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.attendance_app_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.attendance_app_state enable row level security;
alter table public.attendance_app_users enable row level security;
revoke all on public.attendance_app_state from anon;
revoke all on public.attendance_app_users from anon;
grant select, insert, update on public.attendance_app_state to authenticated;
grant select on public.attendance_app_users to authenticated;

drop policy if exists "Authorized users can read attendance state" on public.attendance_app_state;
drop policy if exists "Authorized users can insert attendance state" on public.attendance_app_state;
drop policy if exists "Authorized users can update attendance state" on public.attendance_app_state;
drop policy if exists "Users can check their own attendance access" on public.attendance_app_users;

create policy "Users can check their own attendance access"
  on public.attendance_app_users for select to authenticated
  using (user_id = (select auth.uid()));

create policy "Authorized users can read attendance state"
  on public.attendance_app_state for select to authenticated
  using (exists (select 1 from public.attendance_app_users u where u.user_id = (select auth.uid())));
create policy "Authorized users can insert attendance state"
  on public.attendance_app_state for insert to authenticated
  with check (exists (select 1 from public.attendance_app_users u where u.user_id = (select auth.uid())));
create policy "Authorized users can update attendance state"
  on public.attendance_app_state for update to authenticated
  using (exists (select 1 from public.attendance_app_users u where u.user_id = (select auth.uid())))
  with check (exists (select 1 from public.attendance_app_users u where u.user_id = (select auth.uid())));

-- Para dar acceso a una cuenta existente, el administrador puede ejecutar:
-- insert into public.attendance_app_users (user_id)
-- values ('UUID-DE-LA-CUENTA-AUTORIZADA') on conflict do nothing;
