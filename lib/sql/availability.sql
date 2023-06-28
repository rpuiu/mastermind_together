CREATE TABLE availability (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid REFERENCES auth.users (id) ON DELETE CASCADE,
    day text,
    from_time time with time zone,
    to_time time with time zone
);
