CREATE POLICY "Users can view own profile"
ON users
FOR SELECT
TO authenticated
USING (id = auth.uid());

CREATE POLICY "Users can insert own profile"
ON users
FOR INSERT
TO authenticated
WITH CHECK (id = auth.uid());

CREATE POLICY "Users can update own profile"
ON users
FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

CREATE POLICY "Users can delete own profile"
ON users
FOR DELETE
TO authenticated
USING (id = auth.uid());

CREATE POLICY "Users can view own medications"
ON medications
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "Users can insert own medications"
ON medications
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own medications"
ON medications
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own medications"
ON medications
FOR DELETE
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "Users can view own medication schedules"
ON medication_schedules
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM medications
        WHERE medications.id = medication_schedules.medication_id
        AND medications.user_id = auth.uid()
    )
);

CREATE POLICY "Users can insert own medication schedules"
ON medication_schedules
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM medications
        WHERE medications.id = medication_schedules.medication_id
        AND medications.user_id = auth.uid()
    )
);

CREATE POLICY "Users can update own medication schedules"
ON medication_schedules
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM medications
        WHERE medications.id = medication_schedules.medication_id
        AND medications.user_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM medications
        WHERE medications.id = medication_schedules.medication_id
        AND medications.user_id = auth.uid()
    )
);

CREATE POLICY "Users can delete own medication schedules"
ON medication_schedules
FOR DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM medications
        WHERE medications.id = medication_schedules.medication_id
        AND medications.user_id = auth.uid()
    )
);

CREATE POLICY "Users can view own meal schedules"
ON meal_schedules
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "Users can insert own meal schedules"
ON meal_schedules
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own meal schedules"
ON meal_schedules
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own meal schedules"
ON meal_schedules
FOR DELETE
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "Users can view own activity histories"
ON activity_histories
FOR SELECT
TO authenticated
USING (
    (
        medication_schedule_id IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM medication_schedules ms
            JOIN medications m
                ON m.id = ms.medication_id
            WHERE ms.id = activity_histories.medication_schedule_id
            AND m.user_id = auth.uid()
        )
    )
    OR
    (
        meal_schedule_id IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM meal_schedules ms
            WHERE ms.id = activity_histories.meal_schedule_id
            AND ms.user_id = auth.uid()
        )
    )
);

CREATE POLICY "Users can insert own activity histories"
ON activity_histories
FOR INSERT
TO authenticated
WITH CHECK (
    (
        medication_schedule_id IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM medication_schedules ms
            JOIN medications m
                ON m.id = ms.medication_id
            WHERE ms.id = activity_histories.medication_schedule_id
            AND m.user_id = auth.uid()
        )
    )
    OR
    (
        meal_schedule_id IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM meal_schedules ms
            WHERE ms.id = activity_histories.meal_schedule_id
            AND ms.user_id = auth.uid()
        )
    )
);

CREATE POLICY "Users can update own activity histories"
ON activity_histories
FOR UPDATE
TO authenticated
USING (
    (
        medication_schedule_id IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM medication_schedules ms
            JOIN medications m
                ON m.id = ms.medication_id
            WHERE ms.id = activity_histories.medication_schedule_id
            AND m.user_id = auth.uid()
        )
    )
    OR
    (
        meal_schedule_id IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM meal_schedules ms
            WHERE ms.id = activity_histories.meal_schedule_id
            AND ms.user_id = auth.uid()
        )
    )
)
WITH CHECK (
    (
        medication_schedule_id IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM medication_schedules ms
            JOIN medications m
                ON m.id = ms.medication_id
            WHERE ms.id = activity_histories.medication_schedule_id
            AND m.user_id = auth.uid()
        )
    )
    OR
    (
        meal_schedule_id IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM meal_schedules ms
            WHERE ms.id = activity_histories.meal_schedule_id
            AND ms.user_id = auth.uid()
        )
    )
);

CREATE POLICY "Users can delete own activity histories"
ON activity_histories
FOR DELETE
TO authenticated
USING (
    (
        medication_schedule_id IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM medication_schedules ms
            JOIN medications m
                ON m.id = ms.medication_id
            WHERE ms.id = activity_histories.medication_schedule_id
            AND m.user_id = auth.uid()
        )
    )
    OR
    (
        meal_schedule_id IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM meal_schedules ms
            WHERE ms.id = activity_histories.meal_schedule_id
            AND ms.user_id = auth.uid()
        )
    )
);

CREATE POLICY "Users can view own notification settings"
ON notification_settings
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "Users can insert own notification settings"
ON notification_settings
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own notification settings"
ON notification_settings
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own notification settings"
ON notification_settings
FOR DELETE
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "Authenticated users can view foods"
ON foods
FOR SELECT
TO authenticated
USING (true);