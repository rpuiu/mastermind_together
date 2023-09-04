CREATE TABLE notifications (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid REFERENCES auth.users (id) ON DELETE CASCADE,
    tenant_id uuid REFERENCES public.tenants (tenant_id) ON DELETE CASCADE,
    message text,
    type text,
    read_status boolean DEFAULT false,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Adding the table to the Supabase realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
