# Backend Service (Render)

This folder is a Render-ready backend copy of your API/auth PHP handlers.

## Structure

- `auth/`: copied auth handlers
- `php/`: copied backend PHP handlers
- `api/`: stable API wrapper endpoints for frontend usage

## Environment Variables

Set these in Render:

- `FRONTEND_ORIGINS`: comma-separated allowed origins for CORS
  - Example: `https://your-frontend-domain.com,http://localhost:5500`

## Frontend Base URL

Frontend now uses a configurable API base URL and targets:

- `/api/auth/*`
- `/api/php/*`

Default local path is `/backend` (same host), so local calls become `/backend/api/...`.

For deployed frontend, set one of these before any API call:

- `window.__API_BASE_URL__ = "https://your-render-service.onrender.com";`
- `localStorage.setItem("apiBaseUrl", "https://your-render-service.onrender.com");`
