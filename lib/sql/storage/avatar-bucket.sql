-- Use Postgres to create a bucket.

insert into storage.buckets
  (id, name)
values
  ('avatars', 'avatars');

create policy "Public Access"
  on storage.objects for select
  using ( bucket_id = 'avatars' );

CREATE POLICY "Allow Object Insert"
  ON storage.objects
  FOR INSERT
  WITH CHECK (bucket_id = 'avatars');

-- Allow only the owner of the object to update it
CREATE POLICY "Allow Object Update"
  ON storage.objects
  FOR UPDATE
  USING (bucket_id = 'avatars' AND owner = auth.uid());

-- Allow only the owner of the object to delete it
CREATE POLICY "Allow Object Delete"
  ON storage.objects
  FOR DELETE
  USING (bucket_id = 'avatars' AND owner = auth.uid());