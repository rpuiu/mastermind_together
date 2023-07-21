CREATE TABLE public.users_extended
(
    user_id uuid NOT NULL,
    username text,
    timezone text,
    email text,
    tenant_id uuid,
    CONSTRAINT users_extended_pkey PRIMARY KEY (user_id),
    CONSTRAINT users_extended_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES auth.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT users_extended_tenant_id_fkey FOREIGN KEY (tenant_id)
        REFERENCES public.tenants (tenant_id)
);