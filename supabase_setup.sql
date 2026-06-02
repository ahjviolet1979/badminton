create table if not exists public.badminton_events (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.badminton_user_contracts (
  id text primary key,
  user_id text not null,
  user_password text,
  user_role text not null default 'viewer',
  user_name text,
  event_id text not null,
  event_name text,
  date_from date,
  date_to date,
  viewer_url text,
  mobile_url text,
  viewer_password text,
  status text not null default 'active',
  memo text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.badminton_user_contracts
add column if not exists user_password text;

alter table public.badminton_user_contracts
add column if not exists user_role text not null default 'viewer';

-- 최초 슈퍼어드민 계정이 필요하면 Supabase SQL Editor에서 아래 값을 수정해 직접 실행하세요.
-- 비밀번호를 실제 운영 비밀번호로 바꾼 뒤 실행해야 합니다.
--
-- insert into public.badminton_user_contracts (
--   id, user_id, user_password, user_role, user_name, event_id, event_name, status, updated_at
-- ) values (
--   'admin__super_admin', 'admin', '여기에_비밀번호_입력', 'super_admin', '슈퍼어드민', '*', '전체 대회 관리', 'active', now()
-- )
-- on conflict (id) do update set
--   user_password = excluded.user_password,
--   user_role = 'super_admin',
--   status = 'active',
--   updated_at = now();

alter table public.badminton_events enable row level security;
alter table public.badminton_user_contracts enable row level security;

drop policy if exists "badminton_events_public_read" on public.badminton_events;
create policy "badminton_events_public_read"
on public.badminton_events
for select
to anon
using (true);

drop policy if exists "badminton_events_public_insert" on public.badminton_events;
create policy "badminton_events_public_insert"
on public.badminton_events
for insert
to anon
with check (true);

drop policy if exists "badminton_events_public_update" on public.badminton_events;
create policy "badminton_events_public_update"
on public.badminton_events
for update
to anon
using (true)
with check (true);

drop policy if exists "badminton_events_public_delete" on public.badminton_events;
create policy "badminton_events_public_delete"
on public.badminton_events
for delete
to anon
using (true);

drop policy if exists "badminton_user_contracts_public_read" on public.badminton_user_contracts;
create policy "badminton_user_contracts_public_read"
on public.badminton_user_contracts
for select
to anon
using (true);

drop policy if exists "badminton_user_contracts_public_insert" on public.badminton_user_contracts;
create policy "badminton_user_contracts_public_insert"
on public.badminton_user_contracts
for insert
to anon
with check (true);

drop policy if exists "badminton_user_contracts_public_update" on public.badminton_user_contracts;
create policy "badminton_user_contracts_public_update"
on public.badminton_user_contracts
for update
to anon
using (true)
with check (true);

drop policy if exists "badminton_user_contracts_public_delete" on public.badminton_user_contracts;
create policy "badminton_user_contracts_public_delete"
on public.badminton_user_contracts
for delete
to anon
using (true);

do $$
begin
  alter publication supabase_realtime add table public.badminton_events;
exception
  when duplicate_object then null;
end $$;
