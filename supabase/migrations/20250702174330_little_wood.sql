/*
  # Create jobs table

  1. New Tables
    - `jobs`
      - `id` (bigint, primary key, auto-increment)
      - `title` (text, not null)
      - `description` (text, not null)
      - `location` (text, not null)
      - `company_id` (bigint, foreign key to companies)
      - `recruiter_id` (text, not null - Clerk user ID)
      - `requirements` (text, not null)
      - `isOpen` (boolean, default true)
      - `created_at` (timestamp with timezone, default now())

  2. Security
    - Enable RLS on `jobs` table
    - Add policy for anyone to read jobs
    - Add policy for recruiters to manage their own jobs
*/

CREATE TABLE IF NOT EXISTS jobs (
  id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  title text NOT NULL,
  description text NOT NULL,
  location text NOT NULL,
  company_id bigint REFERENCES companies(id) ON DELETE CASCADE,
  recruiter_id text NOT NULL,
  requirements text NOT NULL,
  "isOpen" boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read jobs"
  ON jobs
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Recruiters can manage their own jobs"
  ON jobs
  FOR ALL
  TO authenticated
  USING (auth.uid()::text = recruiter_id)
  WITH CHECK (auth.uid()::text = recruiter_id);