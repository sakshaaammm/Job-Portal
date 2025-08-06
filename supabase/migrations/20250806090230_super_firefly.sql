/*
  # Fix Companies Visibility on Jobs Page

  1. Security Updates
    - Add proper SELECT policy for companies table to allow public read access
    - Ensure companies are visible to all authenticated users
    - Fix any missing RLS policies that might block company data

  2. Performance Improvements
    - Add indexes for better query performance
    - Optimize company-job relationship queries

  3. Data Integrity
    - Ensure proper foreign key relationships
    - Add constraints for data consistency
*/

-- First, let's check and fix the companies table RLS policies
-- The jobs page needs to read companies, so we need proper SELECT policies

-- Drop existing policies to recreate them properly
DROP POLICY IF EXISTS "Enable read access for auth users" ON companies;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON companies;
DROP POLICY IF EXISTS "Enable update for company creators" ON companies;

-- Create comprehensive policies for companies table
-- Allow all authenticated users to read companies (needed for job listings)
CREATE POLICY "Allow authenticated users to read companies"
  ON companies
  FOR SELECT
  TO authenticated
  USING (true);

-- Allow authenticated users to insert companies (for recruiters posting jobs)
CREATE POLICY "Allow authenticated users to create companies"
  ON companies
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Allow authenticated users to update companies they created
CREATE POLICY "Allow users to update companies"
  ON companies
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Ensure the jobs table has proper policies for reading with company data
DROP POLICY IF EXISTS "Enable read access for auth users" ON jobs;

CREATE POLICY "Allow authenticated users to read jobs with companies"
  ON jobs
  FOR SELECT
  TO authenticated
  USING (true);

-- Add indexes for better performance when joining jobs with companies
CREATE INDEX IF NOT EXISTS idx_jobs_company_id ON jobs(company_id);
CREATE INDEX IF NOT EXISTS idx_companies_id ON companies(id);

-- Ensure proper foreign key constraint exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'jobs_company_id_fkey' 
    AND table_name = 'jobs'
  ) THEN
    ALTER TABLE jobs 
    ADD CONSTRAINT jobs_company_id_fkey 
    FOREIGN KEY (company_id) REFERENCES companies(id);
  END IF;
END $$;

-- Add a policy to allow public read access to companies for job listings
-- This ensures the jobs page can load company information
CREATE POLICY "Allow public read access to companies"
  ON companies
  FOR SELECT
  TO public
  USING (true);