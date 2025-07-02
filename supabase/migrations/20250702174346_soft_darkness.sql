/*
  # Create storage buckets

  1. Storage Buckets
    - `company-logo` - for company logos
    - `resumes` - for candidate resumes

  2. Security
    - Enable public access for company logos
    - Enable authenticated access for resumes
*/

-- Create company-logo bucket
INSERT INTO storage.buckets (id, name, public) 
VALUES ('company-logo', 'company-logo', true)
ON CONFLICT (id) DO NOTHING;

-- Create resumes bucket
INSERT INTO storage.buckets (id, name, public) 
VALUES ('resumes', 'resumes', false)
ON CONFLICT (id) DO NOTHING;

-- Policy for company logos - anyone can read
CREATE POLICY "Public Access for Company Logos"
  ON storage.objects
  FOR SELECT
  USING (bucket_id = 'company-logo');

-- Policy for company logos - authenticated users can upload
CREATE POLICY "Authenticated users can upload company logos"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'company-logo');

-- Policy for resumes - authenticated users can upload their own
CREATE POLICY "Users can upload resumes"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'resumes');

-- Policy for resumes - users can read resumes
CREATE POLICY "Users can read resumes"
  ON storage.objects
  FOR SELECT
  TO authenticated
  USING (bucket_id = 'resumes');