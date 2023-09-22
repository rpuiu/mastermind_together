CREATE TABLE public.tenants
(
    tenant_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL UNIQUE,
    PRIMARY KEY (tenant_id)
);