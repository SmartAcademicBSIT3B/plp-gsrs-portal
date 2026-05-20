# Backend Service (Render with Docker)

This folder contains a Dockerized PHP backend service with all API/auth handlers ready to deploy to Render.

## Structure

- `auth/`: Auth handlers (login, OAuth, password reset, etc.)
- `php/`: Business logic handlers (OJT, uploads, etc.)
- `api/`: API wrapper endpoints for frontend calls
- `Dockerfile`: Docker image configuration for Render
- `.dockerignore`: Files to exclude from Docker image

## Local Development

### With Docker Compose

```bash
# Copy environment file
cp backend/.env.example backend/.env

# Edit backend/.env with your credentials

# Start services (backend + MySQL)
docker-compose up -d

# Backend will be available at http://localhost:8080
# MySQL at localhost:3306
```

Test the health endpoint:

```bash
curl http://localhost:8080/api/health.php
```

### Without Docker (Direct PHP)

```bash
# Ensure PHP >= 8.2 with mysqli, curl extensions
php -S localhost:8000 -t backend

# Backend at http://localhost:8000
```

## Deploy to Render

### 1. Create a new Web Service on Render

- Runtime: **Docker**
- Repository: Your GitHub repo
- Dockerfile path: `backend/Dockerfile`
- Build command: Leave default
- Start command: Leave default (uses `CMD` from Dockerfile)

### 2. Set Environment Variables

Go to **Environment** tab and add:

```
MYSQL_HOST=your-render-mysql-host
MYSQL_USER=your_db_user
MYSQL_PASSWORD=your_db_password
MYSQL_DATABASE=plp_gsrs
MYSQL_PORT=3306

FRONTEND_ORIGINS=https://your-frontend-domain.com,https://www.your-domain.com

API_BASE_URL=https://your-backend-service.onrender.com

GOOGLE_OAUTH_CLIENT_ID=your_oauth_client_id
GOOGLE_OAUTH_CLIENT_SECRET=your_oauth_client_secret

SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
SMTP_FROM_EMAIL=noreply@your-domain.com
```

**Note:** Use your Render PostgreSQL/MySQL database credentials, or provision a new Render Database service.

### 3. Configure Frontend

In your frontend code, set the API base before any API calls:

```javascript
// In login.php or main menu script
window.__API_BASE_URL__ = "https://your-backend-service.onrender.com";
```

Or via localStorage:

```javascript
localStorage.setItem("apiBaseUrl", "https://your-backend-service.onrender.com");
```

## Frontend API Routes

Frontend calls now route to:

- `/api/auth/login.php`
- `/api/auth/forgot_password.php`
- `/api/auth/verify_otp.php`
- `/api/auth/reset_password.php`
- `/api/auth/reactivate_send_otp.php`
- `/api/auth/reactivate_verify_otp.php`
- `/api/auth/google_login.php`
- `/api/auth/logout.php`
- `/api/php/ojt_upload.php`
- `/api/php/ojt_schedule.php`
- `/api/php/ojt_tab_loader.php`
- `/api/php/ojt_weekly_upload.php`
- `/api/php/ojt_attendance_manage.php`
- `/api/php/ojt_requirements_submit.php`
- `/api/php/upload_profile_image.php`
- `/api/php/update_contact.php`
- `/api/php/change_password.php`

Use the `apiFetch()` helper in your frontend (see `js/api-client.js`).

## Docker Features

- **PHP 8.2** with Apache
- **mysqli** and **curl** extensions pre-installed
- **CORS headers** enabled
- **Health check** endpoint at `/api/health.php`
- **Automatic log output** to stdout (visible in Render logs)
- **Configurable port** via `PORT` environment variable
- **Production-ready** error handling`
