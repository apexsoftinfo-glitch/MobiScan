create table if not exists public.mobiscan_documents (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now()
);

alter table public.mobiscan_documents enable row level security;

drop policy if exists "mobiscan_documents_select_own" on public.mobiscan_documents;
create policy "mobiscan_documents_select_own"
on public.mobiscan_documents
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "mobiscan_documents_insert_own" on public.mobiscan_documents;
create policy "mobiscan_documents_insert_own"
on public.mobiscan_documents
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "mobiscan_documents_update_own" on public.mobiscan_documents;
create policy "mobiscan_documents_update_own"
on public.mobiscan_documents
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "mobiscan_documents_delete_own" on public.mobiscan_documents;
create policy "mobiscan_documents_delete_own"
on public.mobiscan_documents
for delete
to authenticated
using (auth.uid() = user_id);
