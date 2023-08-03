CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    tenant_id uuid REFERENCES public.tenants (tenant_id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    UNIQUE (tenant_id, name)
);

CREATE POLICY "Categories are insertable by tenants who created them."
ON categories
FOR INSERT
WITH CHECK (auth.uid() = tenant_id);

CREATE POLICY "Categories are modifiable by the tenant who created them."
ON categories
FOR UPDATE
USING (auth.uid() = tenant_id)
WITH CHECK (auth.uid() = tenant_id);

CREATE POLICY "Categories are selectable by anyone."
ON categories
FOR SELECT
USING (true);

CREATE POLICY "Categories are deletable by the tenant who created them."
ON categories
FOR DELETE
USING (auth.uid() = tenant_id);

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
