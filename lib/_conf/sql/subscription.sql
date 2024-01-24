CREATE TABLE public.subscription (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2)
);

CREATE TABLE public.subscription_features (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    subscription_id uuid REFERENCES public.subscription(id),
    max_groups_create INTEGER DEFAULT 1,
    max_groups_join INTEGER DEFAULT 2
);


ALTER TABLE users_extended ADD COLUMN subscription_id uuid;
ALTER TABLE users_extended ADD CONSTRAINT users_extended_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.subscription(id);

INSERT INTO public.subscription (name, price) VALUES ('Free Tier', 0.00);

INSERT INTO public.subscription_features (subscription_id, max_groups_create, max_groups_join)
VALUES ('YOUR_SUBSCRIPTION_ID', 1, 2);

UPDATE users_extended SET subscription_id = 'YOUR_SUBSCRIPTION_ID' WHERE subscription_id IS NULL;

ALTER TABLE public.subscription ADD COLUMN stripe_price_id VARCHAR(255);

INSERT INTO public.subscription (name, price, stripe_price_id) VALUES ('Pro Plan', 9.99, 'price_XXXXXXXXXXXX');
