CREATE TABLE goals (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid REFERENCES auth.users (id) ON DELETE CASCADE,
    tenant_id uuid REFERENCES public.tenants (tenant_id) ON DELETE CASCADE,
    goal text,
    category text,
    auto_select_group boolean,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- *** Add tables to the publication to enable real time subscription ***
alter publication supabase_realtime add table public.goals;