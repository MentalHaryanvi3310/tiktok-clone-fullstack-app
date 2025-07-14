# Admin Panel Local Setup and Testing Instructions

## Prerequisites
- Node.js and npm installed
- Firebase project created with Authentication enabled (Google Sign-In and Email/Password)
- Backend API running locally and accessible

## Environment Configuration
1. Create a `.env.local` file in the `admin-panel` directory with the following variables:

```
NEXT_PUBLIC_API_BASE_URL=http://localhost:3000/api
NEXT_PUBLIC_FIREBASE_API_KEY=your_firebase_api_key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_firebase_auth_domain
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_firebase_project_id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_firebase_storage_bucket
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your_firebase_messaging_sender_id
NEXT_PUBLIC_FIREBASE_APP_ID=your_firebase_app_id
```

Replace the values with your Firebase project credentials.

## Running the Admin Panel Locally
1. Navigate to the `admin-panel` directory:
   ```
   cd admin-panel
   ```
2. Install dependencies:
   ```
   npm install
   ```
3. Start the development server:
   ```
   npm run dev
   ```
4. Open your browser and go to `http://localhost:3000/admin/dashboard`

## Seeding Mock Data
- Use backend scripts or API endpoints to create mock users and videos.
- Ensure some users are marked as banned and some videos as flagged for testing moderation.
- Example: Use Postman or curl to POST sample data to backend endpoints.

## Testing Moderation Actions
- Login to the admin panel with a whitelisted admin account.
- Navigate to Users and Videos management pages.
- Use Ban/Unban, Approve/Delete buttons to moderate content.
- Verify changes reflect in backend database and frontend app.

## Notes
- Admin routes are protected; only whitelisted emails can access.
- Firebase Authentication handles login.
- For any issues, check browser console and backend logs.

---

# Docker Compose Setup

See `docker-compose.yml` for running backend, admin panel, PostgreSQL, Redis, and optionally frontend.
