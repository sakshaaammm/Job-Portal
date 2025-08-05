/*
  # Verify and Fix Storage Policies

  Ensure that storage buckets have proper policies for file uploads
  This is crucial for company logo uploads and resume uploads
*/

-- Enable RLS on storage buckets
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Policy for company-logo bucket
CREATE POLICY "Allow authenticated users to upload company logos" ON storage.objects
  FOR INSERT 
  TO authenticated 
  WITH CHECK (bucket_id = 'company-logo');

CREATE POLICY "Allow public read access to company logos" ON storage.objects
  FOR SELECT 
  TO public 
  USING (bucket_id = 'company-logo');

-- Policy for resumes bucket  
CREATE POLICY "Allow authenticated users to upload resumes" ON storage.objects
  FOR INSERT 
  TO authenticated 
  WITH CHECK (bucket_id = 'resumes' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Allow authenticated users to read their own resumes" ON storage.objects
  FOR SELECT 
  TO authenticated 
  USING (bucket_id = 'resumes' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Allow recruiters to read resumes for applications they manage
CREATE POLICY "Allow recruiters to read resumes for their jobs" ON storage.objects
  FOR SELECT 
  TO authenticated 
  USING (
    bucket_id = 'resumes' 
    AND EXISTS (
      SELECT 1 FROM applications a
      JOIN jobs j ON a.job_id = j.id
      WHERE j.recruiter_id = auth.uid()::text
      AND a.resume LIKE '%' || name || '%'
    )
  );