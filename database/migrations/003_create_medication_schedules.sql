
CREATE TABLE public.medication_schedules (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    medication_id uuid NOT NULL REFERENCES public.medications(id),
    schedule_time time without time zone NOT NULL,
    meal_instruction varchar(100),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
