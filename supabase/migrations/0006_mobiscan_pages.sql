create table if not exists public.mobiscan_pages (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.mobiscan_documents(id) on delete cascade,
  storage_path text not null,
  page_index int not null,
  created_at timestamptz not null default now()
);

alter table public.mobiscan_pages enable row level security;

-- RLS: Użytkownik ma dostęp do stron dokumentu, którego jest właścicielem
drop policy if exists "mobiscan_pages_select_own" on public.mobiscan_pages;
create policy "mobiscan_pages_select_own"
on public.mobiscan_pages
for select
to authenticated
using (
  exists (
    select 1 from public.mobiscan_documents
    where id = mobiscan_pages.document_id
      and user_id = auth.uid()
  )
);

drop policy if exists "mobiscan_pages_insert_own" on public.mobiscan_pages;
create policy "mobiscan_pages_insert_own"
on public.mobiscan_pages
for insert
to authenticated
with check (
  exists (
    select 1 from public.mobiscan_documents
    where id = mobiscan_pages.document_id
      and user_id = auth.uid()
  )
);

drop policy if exists "mobiscan_pages_update_own" on public.mobiscan_pages;
create policy "mobiscan_pages_update_own"
on public.mobiscan_pages
for update
to authenticated
using (
  exists (
    select 1 from public.mobiscan_documents
    where id = mobiscan_pages.document_id
      and user_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.mobiscan_documents
    where id = mobiscan_pages.document_id
      and user_id = auth.uid()
  )
);

drop policy if exists "mobiscan_pages_delete_own" on public.mobiscan_pages;
create policy "mobiscan_pages_delete_own"
on public.mobiscan_pages
for delete
to authenticated
using (
  exists (
    select 1 from public.mobiscan_documents
    where id = mobiscan_pages.document_id
      and user_id = auth.uid()
  )
);

-- Realtime
do $$
begin
  if exists (
    select 1
    from pg_publication
    where pubname = 'supabase_realtime'
  ) then
    if not exists (
      select 1
      from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = 'mobiscan_documents'
    ) then
      alter publication supabase_realtime add table public.mobiscan_documents;
    end if;

    if not exists (
      select 1
      from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = 'mobiscan_pages'
    ) then
      alter publication supabase_realtime add table public.mobiscan_pages;
    end if;
  end if;
end;
$$;
