# Docker Backend Deployment Checklist

## What Changed

Your backend is now **Dockerized** for Render deployment:

✅ **Dockerfile** (`backend/Dockerfile`)

- PHP 8.2 with Apache
- All required extensions (mysqli, curl)
- CORS headers enabled
- Health check endpoint configured
- Production-ready error handling

✅ **Docker Compose** (`docker-compose.yml`)

- Local development with MySQL
- Pre-configured services
- Easy local testing

✅ **Environment Configuration**

- `.env.example` with all required vars
- `backend/.env.example` for backend-specific config
- CORS configuration via env variable

✅ **Deployment Documentation**

- `RENDER_DEPLOYMENT.md` - Step-by-step Render guide
- `render.yaml` - Infrastructure as Code (optional)
- `.github/workflows/deploy.yml` - Auto-deployment on push

## Quick Start: Local Testing with Docker

```bash
# 1. Copy environment template
cp backend/.env.example backend/.env

# 2. Edit backend/.env with your database credentials
# (Adjust MYSQL_* variables as needed)

# 3. Start Docker Compose (brings up backend + MySQL)
docker-compose up -d

# 4. Test the API
curl http://localhost:8080/api/health.php

# Should return: {"status":"ok","timestamp":"2026-05-20T..."}

# 5. Stop services
docker-compose down
```

## Deployment to Render: Step-by-Step

### Step 1: Push Code to GitHub

```bash
git add -A
git commit -m "Add Docker backend for Render deployment"
git push origin main
```

### Step 2: Create Render Web Service

1. Go to https://render.com/dashboard
2. Click **New** → **Web Service**
3. Select your GitHub repository
4. **Settings:**
   - **Name:** `plp-gsrs-backend`
   - **Runtime:** Docker
   - **Region:** oregon (or your preference)
5. Click **Create Web Service**

### Step 3: Set Environment Variables

In Render dashboard, go to **Environment**:

```
MYSQL_HOST=your-render-mysql.render.com
MYSQL_PORT=3306
MYSQL_USER=plp_user
MYSQL_PASSWORD=your_secure_password
MYSQL_DATABASE=plp_gsrs

FRONTEND_ORIGINS=https://your-frontend.com
API_BASE_URL=https://plp-gsrs-backend.onrender.com

GOOGLE_OAUTH_CLIENT_ID=your_google_oauth_id
GOOGLE_OAUTH_CLIENT_SECRET=your_google_oauth_secret

SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_gmail@gmail.com
SMTP_PASSWORD=your_gmail_app_password
SMTP_FROM_EMAIL=noreply@your-domain.com
```

### Step 4: Provision MySQL Database

Option A: Use Render MySQL (recommended)

1. In Render, click **New** → **MySQL**
2. Copy connection details to environment variables above

Option B: Use external MySQL

1. Ensure your database is accessible from Render
2. Update MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD accordingly

### Step 5: Update Frontend

In your frontend code (e.g., `login.php` or `mainmenu.php`):

```javascript
// Set this BEFORE any API calls:
window.__API_BASE_URL__ = "https://plp-gsrs-backend.onrender.com";
```

Or configure via environment:

```javascript
// In your frontend build/deployment
if (window.location.hostname === "your-frontend-domain.com") {
  window.__API_BASE_URL__ = "https://plp-gsrs-backend.onrender.com";
}
```

### Step 6: Monitor Deployment

1. In Render, watch the **Logs** tab during deployment
2. Verify the service shows **Live** status
3. Test health endpoint:
   ```
   https://plp-gsrs-backend.onrender.com/api/health.php
   ```

## Troubleshooting

### Service Shows "Build Failed"

- Check **Logs** tab for specific error
- Ensure `Dockerfile` path is correct
- Verify all files are committed to git

### "Health check failed"

- Backend service needs 30+ seconds to start
- Check logs: `docker logs backend` (locally) or Render Logs
- Verify MySQL is accessible

### CORS Errors in Frontend

- Check `FRONTEND_ORIGINS` env variable matches your frontend domain
- Ensure frontend sets `window.__API_BASE_URL__` correctly
- Clear browser cache and cookies

### Database Connection Errors

- Verify `MYSQL_HOST`, `MYSQL_USER`, `MYSQL_PASSWORD` are correct
- Check database exists (`MYSQL_DATABASE`)
- Ensure Render MySQL service is running

### "File not found" errors

- Check that files exist in `backend/` directory
- Verify API paths in frontend (`/api/auth/login.php`, etc.)
- Check Dockerfile working directory (`/var/www/html`)

## File Structure for Render

```
plp-gsrs-portal/
├── backend/
│   ├── Dockerfile              ← Render uses this
│   ├── .dockerignore          ← Excludes files from Docker image
│   ├── .env.example           ← Template for env vars
│   ├── README.md              ← Backend documentation
│   ├── index.php              ← Entry point
│   ├── api/                   ← API wrappers
│   │   ├── _bootstrap.php     ← CORS/session bootstrap
│   │   ├── health.php         ← Health check
│   │   ├── auth/              ← Auth endpoints
│   │   └── php/               ← Business logic endpoints
│   ├── auth/                  ← Auth implementation (copied)
│   ├── php/                   ← Business logic (copied)
│   └── PHPMailer/             ← Email library
├── docker-compose.yml          ← Local dev setup
├── render.yaml                 ← Infrastructure as Code (optional)
├── RENDER_DEPLOYMENT.md        ← Deployment guide (this file)
└── js/
    └── api-client.js          ← Frontend API helper
```

## Security Notes

1. **Never commit `.env` files** - Only commit `.env.example`
2. **Sensitive data in Render env vars** - Not in code
3. **CORS origins** - Restrict to your frontend domain
4. **Database passwords** - Use strong, unique passwords
5. **OAuth secrets** - Store securely in Render env vars

## Cost Considerations

- **Render Starter Plan**: ~$7/month per service
- **MySQL Database**: ~$15/month (if using Render DB)
- **Free tier available**: For low-traffic testing
- Monitor usage in Render dashboard

## Next Steps

1. ✅ Backend Dockerized
2. ⏳ Deploy to Render (follow steps above)
3. ⏳ Configure frontend API base URL
4. ⏳ Test all API endpoints
5. ⏳ Monitor logs for any issues
6. ⏳ Scale as needed (upgrade Render plan if needed)
