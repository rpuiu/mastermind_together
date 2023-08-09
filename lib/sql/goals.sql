CREATE TABLE goals (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid REFERENCES auth.users (id) ON DELETE CASCADE,
    tenant_id uuid REFERENCES public.tenants (tenant_id) ON DELETE CASCADE,
    goal text,
    category text,
    status text DEFAULT 'pending',
    due_date date,
    auto_select_group boolean,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

alter publication supabase_realtime add table public.goals;

CREATE TABLE actions (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    goal_id uuid REFERENCES public.goals (id) ON DELETE CASCADE,
    description text,
    status text DEFAULT 'pending',
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

alter publication supabase_realtime add table public.actions;
