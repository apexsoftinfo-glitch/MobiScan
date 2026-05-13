-- Granty dla Data API (PostgREST / GraphQL)
-- Zmiana wymagana przez Supabase od 30.10.2026 (lub dla nowych projektów od 30.05.2026)

-- 1. shared_users
grant select, insert, update, delete on table public.shared_users to authenticated;
grant select on table public.shared_users to anon;
grant all on table public.shared_users to service_role;

-- 2. mobiscan_documents
grant select, insert, update, delete on table public.mobiscan_documents to authenticated;
grant select on table public.mobiscan_documents to anon;
grant all on table public.mobiscan_documents to service_role;

-- 3. mobiscan_pages
grant select, insert, update, delete on table public.mobiscan_pages to authenticated;
grant select on table public.mobiscan_pages to anon;
grant all on table public.mobiscan_pages to service_role;
