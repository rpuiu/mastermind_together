CREATE TABLE ai_messages (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_thread_id text REFERENCES user_threads (ai_thread_id) ON DELETE CASCADE,
    user_id uuid REFERENCES users_extended (user_id) ON DELETE CASCADE,
    sender text NOT NULL,
    content text NOT NULL,
    timestamp timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

-- Add table to the publication for real-time subscription if using Supabase or similar
ALTER PUBLICATION supabase_realtime ADD TABLE public.ai_messages;