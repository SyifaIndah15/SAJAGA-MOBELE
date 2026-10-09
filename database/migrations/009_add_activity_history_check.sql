ALTER TABLE public.activity_histories
ADD CONSTRAINT activity_histories_one_schedule_check
CHECK (
    (medication_schedule_id IS NOT NULL
     AND meal_schedule_id IS NULL)
    OR
    (medication_schedule_id IS NULL
     AND meal_schedule_id IS NOT NULL)
);