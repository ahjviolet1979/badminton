create table if not exists public.badminton_events (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.badminton_events enable row level security;

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

do $$
begin
  alter publication supabase_realtime add table public.badminton_events;
exception
  when duplicate_object then null;
end $$;
