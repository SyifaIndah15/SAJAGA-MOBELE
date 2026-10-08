
CREATE TABLE public.activity_histories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    medication_schedule_id uuid REFERENCES public.medication_schedules(id),
    meal_schedule_id uuid REFERENCES public.meal_schedules(id),
    status varchar(50) NOT NULL,
    note text,
    activity_time timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
