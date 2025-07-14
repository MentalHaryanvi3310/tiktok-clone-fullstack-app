import React, { useEffect } from 'react';
import { useRouter } from 'next/router';
import { useAuth } from './AuthProvider';

const adminWhitelist = [
  'admin1@example.com',
  'admin2@example.com',
  // Add allowed admin emails here or load from env
];

const ProtectedRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { user, loading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!loading) {
      if (!user || !adminWhitelist.includes(user.email || '')) {
        router.push('/admin/login');
      }
    }
  }, [user, loading, router]);

  if (loading || !user || !adminWhitelist.includes(user.email || '')) {
    return <div>Loading...</div>;
  }

  return <>{children}</>;
};

export default ProtectedRoute;
