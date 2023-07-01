CREATE TABLE messages (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    group_id uuid REFERENCES groups (id) ON DELETE CASCADE,
    user_id uuid REFERENCES users_extended (user_id) ON DELETE CASCADE,
    sender text NOT NULL,
    content text NOT NULL,
    timestamp timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

//TODO Enable Realtime!