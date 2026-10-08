CREATE TABLE public.users (
    id uuid PRIMARY KEY
        REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar(100) NOT NULL,
    email varchar(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);