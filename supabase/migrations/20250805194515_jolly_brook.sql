/*
  # Add requesting_user_id() Function

  This migration creates the `requesting_user_id()` function that was referenced 
  in the original RLS policies but may not exist. This ensures backward compatibility
  while we transition to using auth.uid() directly.
*/

-- Create the requesting_user_id function if it doesn't exist
-- This function extracts the user ID from the JWT token
CREATE OR REPLACE FUNCTION requesting_user_id()
RETURNS TEXT
LANGUAGE SQL
STABLE
AS $$
  SELECT auth.uid()::text;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION requesting_user_id() TO authenticated;