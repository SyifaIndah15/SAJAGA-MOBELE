
-- ============================================
-- SAJAGA - Database Schema
-- Dokumentasi struktur database Supabase
-- ============================================

-- 1. USERS
-- Profil pengguna terhubung dengan Supabase Auth.
CREATE TABLE public.users (
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name varchar(100) NOT NULL,
    email varchar(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);

-- 2. MEDICATIONS
-- Data obat milik pengguna.
CREATE TABLE public.medications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES public.users(id),
    name varchar(100) NOT NULL,
    dose varchar(100) NOT NULL,
    days integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);

-- 3. MEDICATION SCHEDULES
-- Jadwal konsumsi untuk setiap obat.
CREATE TABLE public.medication_schedules (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    medication_id uuid NOT NULL REFERENCES public.medications(id),
    schedule_time time without time zone NOT NULL,
    meal_instruction varchar(100),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);

-- 4. MEAL SCHEDULES
-- Jadwal makan milik pengguna.
CREATE TABLE public.meal_schedules (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES public.users(id),
    meal_type varchar(50) NOT NULL,
    schedule_time time without time zone NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);

-- 5. ACTIVITY HISTORIES
-- Riwayat aktivitas obat dan jadwal makan.
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

-- 6. FOODS
-- Referensi informasi makanan.
CREATE TABLE public.foods (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar(100) NOT NULL,
    calories integer NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);

-- 7. NOTIFICATION SETTINGS
-- Pengaturan notifikasi per pengguna.
CREATE TABLE public.notification_settings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL UNIQUE REFERENCES public.users(id),
    medication_reminder boolean DEFAULT true,
    meal_reminder boolean DEFAULT true,
    sound_vibration boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
