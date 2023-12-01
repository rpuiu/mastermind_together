CREATE TABLE goal_messages (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    goal_id uuid REFERENCES goals (id) ON DELETE CASCADE,
    user_id uuid REFERENCES users_extended (user_id) ON DELETE CASCADE,
    sender text NOT NULL,
    content text NOT NULL,
    timestamp timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

-- Add table to the publication for real-time subscription
ALTER PUBLICATION supabase_realtime ADD TABLE public.goal_messages;
