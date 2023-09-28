CREATE TABLE settings (
    tenant_id UUID REFERENCES tenants(tenant_id),
    terms_of_service TEXT,
    privacy_policy TEXT,
    PRIMARY KEY (tenant_id)
);

-- Add columns for the light and dark versions of the logo URL
ALTER TABLE settings ADD COLUMN light_logo_url TEXT;
ALTER TABLE settings ADD COLUMN dark_logo_url TEXT;
ALTER TABLE settings ADD COLUMN favicon_url TEXT;

CREATE POLICY "Settings are insertable by tenants who created them."
ON settings
FOR INSERT
WITH CHECK (auth.uid() = tenant_id);

create policy "Settings are modifiable by the tenant who created them."
  on settings for update
  using ( auth.uid() = tenant_id )
  with check ( auth.uid() = tenant_id );

CREATE POLICY "Settings are selectable by anyone."
ON settings
FOR SELECT
USING (true);

alter table settings enable row level security;
