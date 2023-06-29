CREATE TABLE goals (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid REFERENCES auth.users (id) ON DELETE CASCADE,
    goal_text text,
    area text,
    auto_select_group boolean,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO categories (name) VALUES ('Health'), ('Career'), ('Education'), ('Others');
