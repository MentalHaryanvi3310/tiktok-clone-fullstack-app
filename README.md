# TikTok Clone Full-Stack Application

This repository contains a modular and scalable codebase for a TikTok-like full-stack mobile application.

## Folder Structure

- `backend/` - NestJS backend service
  - PostgreSQL, Redis, Firebase Auth integration placeholders
  - Dockerfile for containerization
  - Scripts to run in dev and production modes

- `frontend/` - Flutter mobile app
  - Basic folder structure for views, services, models
  - Placeholder for video recording support
  - Flutter app entry point in `lib/main.dart`

- `admin-panel/` - Next.js admin panel
  - User and video moderation dashboard placeholder
  - Dockerfile for containerization
  - Basic React components folder

## Running the Services

### Backend

- Install dependencies: `cd backend && npm install`
- Run in dev mode: `npm run start:dev`
- Build and run production: `npm run build && npm run start:prod`
- Docker build and run available via `backend/Dockerfile`

### Frontend

- Flutter SDK required
- Run Flutter app: `flutter run` in `frontend/` directory
- Placeholder for video recording and playback features

### Admin Panel

- Install dependencies: `cd admin-panel && npm install`
- Run in dev mode: `npm run dev`
- Build and start production: `npm run build && npm run start`
- Docker build and run available via `admin-panel/Dockerfile`

## Next Steps

- Implement user authentication with Firebase
- Add video upload and feed features
- Add interaction features (like/comment/follow)
- Build and connect admin panel with backend
- Add push notifications using Firebase
- Final deployment setup with CI/CD
