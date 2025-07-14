import React, { useEffect, useState } from 'react';
import { fetchUsers, banUser, unbanUser } from '../../services/api';

const Users: React.FC = () => {
  const [users, setUsers] = useState<any[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const loadUsers = async (searchTerm = '') => {
    setLoading(true);
    setError(null);
    try {
      const data = await fetchUsers(searchTerm);
      setUsers(data);
    } catch (err) {
      setError('Failed to load users');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadUsers();
  }, []);

  const handleBanToggle = async (userId: string, banned: boolean) => {
    try {
      if (banned) {
        await unbanUser(userId);
      } else {
        await banUser(userId);
      }
      loadUsers(search);
    } catch {
      alert('Failed to update user status');
    }
  };

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearch(e.target.value);
  };

  const handleSearchSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    loadUsers(search);
  };

  return (
    <div>
      <h1>User Management</h1>
      <form onSubmit={handleSearchSubmit}>
        <input
          type="text"
          placeholder="Search users..."
          value={search}
          onChange={handleSearchChange}
        />
        <button type="submit">Search</button>
      </form>
      {loading && <p>Loading users...</p>}
      {error && <p>{error}</p>}
      <table border={1} cellPadding={5} cellSpacing={0}>
        <thead>
          <tr>
            <th>Username</th>
            <th>Email</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {users.map((user) => (
            <tr key={user.id}>
              <td>{user.username}</td>
              <td>{user.email}</td>
              <td>{user.banned ? 'Banned' : 'Active'}</td>
              <td>
                <button onClick={() => handleBanToggle(user.id, user.banned)}>
                  {user.banned ? 'Unban' : 'Ban'}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Users;
