CREATE POLICY "Users can view own profile"
ON public.users
FOR SELECT
TO authenticated
USING (id = auth.uid());

CREATE POLICY "Users can insert own profile"
ON public.users
FOR INSERT
TO authenticated
WITH CHECK (id = auth.uid());

CREATE POLICY "Users can update own profile"
ON public.users
FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());


CREATE POLICY "Users can view own medications"
ON public.medications
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "Users can insert own medications"
ON public.medications
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own medications"
ON public.medications
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own medications"
ON public.medications
FOR DELETE
TO authenticated
USING (user_id = auth.uid());


CREATE POLICY "Users can manage own medication schedules"
ON public.medication_schedules
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.medications m
        WHERE m.id = medication_id
        AND m.user_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.medications m
        WHERE m.id = medication_id
        AND m.user_id = auth.uid()
    )
);


CREATE POLICY "Users can manage own meal schedules"
ON public.meal_schedules
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());


CREATE POLICY "Users can view own activity histories"
ON public.activity_histories
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.medication_schedules ms
        JOIN public.medications m
            ON m.id = ms.medication_id
        WHERE ms.id = medication_schedule_id
        AND m.user_id = auth.uid()
    )
    OR EXISTS (
        SELECT 1
        FROM public.meal_schedules ms
        WHERE ms.id = meal_schedule_id
        AND ms.user_id = auth.uid()
    )
);

CREATE POLICY "Users can insert own activity histories"
ON public.activity_histories
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.medication_schedules ms
        JOIN public.medications m
            ON m.id = ms.medication_id
        WHERE ms.id = medication_schedule_id
        AND m.user_id = auth.uid()
    )
    OR EXISTS (
        SELECT 1
        FROM public.meal_schedules ms
        WHERE ms.id = meal_schedule_id
        AND ms.user_id = auth.uid()
    )
);


CREATE POLICY "Authenticated users can view foods"
ON public.foods
FOR SELECT
TO authenticated
USING (true);


CREATE POLICY "Users can view own notification settings"
ON public.notification_settings
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "Users can insert own notification settings"
ON public.notification_settings
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own notification settings"
ON public.notification_settings
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());