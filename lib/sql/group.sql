CREATE TABLE groups (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    category text,
    name text,
    meeting_time time with time zone,
    meeting_day text,
    max_members int,
    current_members int DEFAULT 0,
    meeting_url text
);

CREATE TABLE group_members (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid REFERENCES users_extended (user_id) ON DELETE CASCADE,
    group_id uuid REFERENCES groups (id) ON DELETE CASCADE,
    joined_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
