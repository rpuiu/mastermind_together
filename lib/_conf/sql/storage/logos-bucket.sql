-- Create a new bucket for logos
insert into storage.buckets
  (id, name)
values
  ('logos', 'logos');

-- Allow public access to logos
create policy "Public Access to Logos"
  on storage.objects for select
  using ( bucket_id = 'logos' );

-- Allow object insert into logos bucket
CREATE POLICY "Allow Logo Insert"
  ON storage.objects
  FOR INSERT
  WITH CHECK (bucket_id = 'logos');

-- Allow only the owner of the logo to update it
CREATE POLICY "Allow Logo Update"
  ON storage.objects
  FOR UPDATE
  USING (bucket_id = 'logos' AND owner = auth.uid());

-- Allow only the owner of the logo to delete it
CREATE POLICY "Allow Logo Delete"
  ON storage.objects
  FOR DELETE
  USING (bucket_id = 'logos' AND owner = auth.uid());
