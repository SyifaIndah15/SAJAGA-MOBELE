CREATE TABLE activity_histories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    medication_schedule_id UUID REFERENCES medication_schedules(id),
    meal_schedule_id UUID REFERENCES meal_schedules(id),
    status VARCHAR(50) NOT NULL,
    note VARCHAR(255),
    activity_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);