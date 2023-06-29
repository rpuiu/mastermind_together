CREATE TABLE public.user_extended
(
    user_id uuid NOT NULL,
    timezone text,
    CONSTRAINT user_extended_pkey PRIMARY KEY (user_id),
    CONSTRAINT user_extended_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES auth.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
