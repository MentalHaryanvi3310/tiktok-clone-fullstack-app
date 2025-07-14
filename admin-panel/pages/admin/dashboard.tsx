import React, { useEffect, useState } from 'react';
import { fetchDashboardStats } from '../../services/api';

const Dashboard: React.FC = () => {
  const [stats, setStats] = useState<{ users: number; videos: number; flagged: number } | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const loadStats = async () => {
      try {
        const data = await fetchDashboardStats();
        setStats(data);
      } catch (err) {
        setError('Failed to load dashboard stats');
      } finally {
        setLoading(false);
      }
    };
    loadStats();
  }, []);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>{error}</div>;

  return (
    <div>
      <h1>Admin Dashboard</h1>
      <div style={{ display: 'flex', gap: '20px' }}>
        <div style={{ border: '1px solid #ccc', padding: '10px', flex: 1 }}>
          <h2>Total Users</h2>
          <p>{stats?.users}</p>
        </div>
        <div style={{ border: '1px solid #ccc', padding: '10px', flex: 1 }}>
          <h2>Total Videos</h2>
          <p>{stats?.videos}</p>
        </div>
        <div style={{ border: '1px solid #ccc', padding: '10px', flex: 1 }}>
          <h2>Flagged Content</h2>
          <p>{stats?.flagged}</p>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
