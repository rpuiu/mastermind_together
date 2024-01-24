CREATE TABLE public.subscription_transactions (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid REFERENCES public.users_extended(user_id),
    subscription_id uuid REFERENCES public.subscription(id),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2),
    stripe_customer_id VARCHAR(255),
    stripe_checkout_session_id VARCHAR(255)
);