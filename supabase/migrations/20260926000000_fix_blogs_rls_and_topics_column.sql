-- Fix RLS policies on blogs: they compared auth.uid() against the blog's own
-- primary key (id) instead of the author's id (poster_id), so every insert from
-- the app failed with "new row violates row level security policy".
drop policy if exists "Users can insert their own blogs." on public.blogs;
create policy "Users can insert their own blogs." on public.blogs
  for insert to authenticated
  with check ((select auth.uid()) = poster_id);

drop policy if exists "Users can update own blogs." on public.blogs;
create policy "Users can update own blogs." on public.blogs
  for update to authenticated
  using ((select auth.uid()) = poster_id)
  with check ((select auth.uid()) = poster_id);

-- Align the column name with the Dart model (BlogModel.toJson sends "topics").
alter table public.blogs rename column topic to topics;

-- The blog_images bucket had no storage policies at all, so the image upload in
-- BlogRemoteDataSourceImpl.uploadBlogImage failed with the same
-- "new row violates row-level security policy" text before the blogs insert
-- was ever reached.
drop policy if exists "Blog images are publicly readable." on storage.objects;
create policy "Blog images are publicly readable." on storage.objects
  for select to public using (bucket_id = 'blog_images');

drop policy if exists "Authenticated users can upload blog images." on storage.objects;
create policy "Authenticated users can upload blog images." on storage.objects
  for insert to authenticated with check (bucket_id = 'blog_images');

drop policy if exists "Users can update their own blog images." on storage.objects;
create policy "Users can update their own blog images." on storage.objects
  for update to authenticated
  using (bucket_id = 'blog_images' and (select auth.uid()) = owner)
  with check (bucket_id = 'blog_images');

drop policy if exists "Users can delete their own blog images." on storage.objects;
create policy "Users can delete their own blog images." on storage.objects
  for delete to authenticated
  using (bucket_id = 'blog_images' and (select auth.uid()) = owner);
