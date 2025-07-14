import React, { useEffect, useState } from 'react';
import { fetchVideos, approveVideo, deleteVideo } from '../../services/api';

const Videos: React.FC = () => {
  const [videos, setVideos] = useState<any[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [selectedVideo, setSelectedVideo] = useState<any | null>(null);

  const loadVideos = async (searchTerm = '') => {
    setLoading(true);
    setError(null);
    try {
      const data = await fetchVideos(searchTerm);
      setVideos(data);
    } catch (err) {
      setError('Failed to load videos');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadVideos();
  }, []);

  const handleApprove = async (videoId: string) => {
    try {
      await approveVideo(videoId);
      loadVideos(search);
    } catch {
      alert('Failed to approve video');
    }
  };

  const handleDelete = async (videoId: string) => {
    try {
      await deleteVideo(videoId);
      loadVideos(search);
    } catch {
      alert('Failed to delete video');
    }
  };

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearch(e.target.value);
  };

  const handleSearchSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    loadVideos(search);
  };

  return (
    <div>
      <h1>Video Management</h1>
      <form onSubmit={handleSearchSubmit}>
        <input
          type="text"
          placeholder="Search videos..."
          value={search}
          onChange={handleSearchChange}
        />
        <button type="submit">Search</button>
      </form>
      {loading && <p>Loading videos...</p>}
      {error && <p>{error}</p>}
      <table border={1} cellPadding={5} cellSpacing={0}>
        <thead>
          <tr>
            <th>Thumbnail</th>
            <th>Username</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {videos.map((video) => (
            <tr key={video.id}>
              <td>
                <img src={video.thumbnailUrl} alt="thumbnail" width={100} />
              </td>
              <td>{video.username}</td>
              <td>{video.flagged ? 'Flagged' : 'Active'}</td>
              <td>
                <button onClick={() => handleApprove(video.id)}>Approve</button>
                <button onClick={() => handleDelete(video.id)}>Delete</button>
                <button onClick={() => setSelectedVideo(video)}>View</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {selectedVideo && (
        <div className="modal">
          <h2>Video Detail</h2>
          <video width="400" controls src={selectedVideo.videoUrl} />
          <p>Title: {selectedVideo.title}</p>
          <p>Description: {selectedVideo.description}</p>
          <button onClick={() => setSelectedVideo(null)}>Close</button>
        </div>
      )}
    </div>
  );
};

export default Videos;
