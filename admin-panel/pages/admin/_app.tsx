import React from 'react';
import type { AppProps } from 'next/app';
import { AuthProvider } from '../../components/AuthProvider';
import ProtectedRoute from '../../components/ProtectedRoute';

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <AuthProvider>
      <ProtectedRoute>
        <Component {...pageProps} />
      </ProtectedRoute>
    </AuthProvider>
  );
}

export default MyApp;
