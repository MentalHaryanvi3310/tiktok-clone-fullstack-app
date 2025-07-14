import axios from 'axios';

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:3000/api',
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: true,
});

// Optionally add interceptors here for auth token injection

export const fetchDashboardStats = async () => {
  const response = await api.get('/admin/dashboard-stats');
  return response.data;
};

export const fetchUsers = async (search = '') => {
  const response = await api.get('/admin/users', { params: { search } });
  return response.data;
};

export const banUser = async (userId: string) => {
  const response = await api.post(`/admin/users/${userId}/ban`);
  return response.data;
};

export const unbanUser = async (userId: string) => {
  const response = await api.post(`/admin/users/${userId}/unban`);
  return response.data;
};

export const fetchVideos = async (search = '') => {
  const response = await api.get('/admin/videos', { params: { search } });
  return response.data;
};

export const approveVideo = async (videoId: string) => {
  const response = await api.post(`/admin/videos/${videoId}/approve`);
  return response.data;
};

export const deleteVideo = async (videoId: string) => {
  const response = await api.post(`/admin/videos/${videoId}/delete`);
  return response.data;
};

export default api;
