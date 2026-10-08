
CREATE TABLE public.notification_settings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL UNIQUE REFERENCES public.users(id),
    medication_reminder boolean DEFAULT true,
    meal_reminder boolean DEFAULT true,
    sound_vibration boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
