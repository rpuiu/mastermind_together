CREATE TABLE user_threads (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid REFERENCES users_extended (user_id) ON DELETE CASCADE,
    ai_thread_id text UNIQUE NOT NULL
);

ALTER PUBLICATION supabase_realtime ADD TABLE public.user_threads;
