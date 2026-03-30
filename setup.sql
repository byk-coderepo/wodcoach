-- Run this in your Supabase SQL Editor
-- Creates the wod_logs table for WOD Coach

create table if not exists wod_logs (
  id uuid default gen_random_uuid() primary key,
  week_start text not null,
  day_index integer not null check (day_index >= 0 and day_index <= 6),
  wod text not null,
  recommendation text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now(),
  unique (week_start, day_index)
);

-- Enable Row Level Security (keeps your data private)
alter table wod_logs enable row level security;

-- Allow all operations without authentication (single user personal app)
create policy "Allow all" on wod_logs for all using (true) with check (true);
