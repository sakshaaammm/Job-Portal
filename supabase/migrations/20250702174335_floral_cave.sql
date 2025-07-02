/*
  # Create saved_jobs table

  1. New Tables
    - `saved_jobs`
      - `id` (bigint, primary key, auto-increment)
      - `user_id` (text, not null - Clerk user ID)
      - `job_id` (bigint, foreign key to jobs)
      - `created_at` (timestamp with timezone, default now())

  2. Security
    - Enable RLS on `saved_jobs` table
    - Add policy for users to manage their own saved jobs
    - Add unique constraint on user_id and job_id
*/

CREATE TABLE IF NOT EXISTS saved_jobs (
  id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id text NOT NULL,
  job_id bigint REFERENCES jobs(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, job_id)
);

ALTER TABLE saved_jobs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own saved jobs"
  ON saved_jobs
  FOR ALL
  TO authenticated
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);