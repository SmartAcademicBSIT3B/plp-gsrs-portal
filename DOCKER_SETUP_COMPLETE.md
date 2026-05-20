# Docker Backend Setup Complete ✅

Your PHP backend is now **fully Dockerized** and ready to deploy to Render!

## What Was Created

### Core Docker Files

- **`backend/Dockerfile`** - PHP 8.2 Apache image with all dependencies
- **`backend/.dockerignore`** - Optimizes Docker image size
- **`docker-compose.yml`** - Local development stack (backend + MySQL)

### Configuration Files

- **`backend/.env.example`** - Template for backend environment variables
- **`render.yaml`** - Infrastructure as Code for Render (optional)

### Deployment Guides

- **`RENDER_DEPLOYMENT.md`** - Step-by-step Render deployment instructions
- **`DOCKER_DEPLOYMENT_CHECKLIST.md`** - Complete checklist with troubleshooting

### Helper Scripts

- **`docker-helper.ps1`** - PowerShell helper (Windows)
- **`docker-helper.sh`** - Bash helper (Mac/Linux)
- **`.github/workflows/deploy.yml`** - Auto-deploy on GitHub push (optional)

### Updated Files

- **`backend/README.md`** - Updated with Docker instructions
- **`js/api-client.js`** - Already configured for API routing
- Frontend pages already rewired to use backend API

## Quick Start: Local Testing (Windows)

```powershell
# 1. Setup environment
.\docker-helper.ps1 setup

# 2. Edit backend\.env with your database credentials (optional for local testing)

# 3. Start services
.\docker-helper.ps1 start

# 4. Backend is now available at http://localhost:8080

# 5. Test API
curl http://localhost:8080/api/health.php

# 6. View logs (open new terminal)
.\docker-helper.ps1 logs

# 7. Stop when done
.\docker-helper.ps1 stop
```

## Quick Start: Local Testing (Mac/Linux)

```bash
# 1. Setup environment
chmod +x docker-helper.sh
./docker-helper.sh setup

# 2. Start services
./docker-helper.sh start

# 3. Test API
curl http://localhost:8080/api/health.php

# 4. View logs
./docker-helper.sh logs

# 5. Stop services
./docker-helper.sh stop
```

## Render Deployment: 5 Steps

### Step 1: Push to GitHub

```bash
git add -A
git commit -m "Add Docker backend for Render deployment"
git push origin main
```

### Step 2: Create Render Web Service

1. Go to https://render.com/dashboard
2. Click **New** → **Web Service**
3. Select your GitHub repository
4. Settings:
   - **Name:** `plp-gsrs-backend`
   - **Runtime:** Docker
5. Click **Create Web Service**

### Step 3: Add Environment Variables

In Render → **Environment**, add:

```
MYSQL_HOST=your-mysql-host
MYSQL_USER=your_user
MYSQL_PASSWORD=your_password
MYSQL_DATABASE=plp_gsrs

FRONTEND_ORIGINS=https://your-frontend.com

API_BASE_URL=https://your-backend.onrender.com

GOOGLE_OAUTH_CLIENT_ID=xxx
GOOGLE_OAUTH_CLIENT_SECRET=xxx

SMTP_HOST=smtp.gmail.com
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
```

### Step 4: Setup Database

Option A: Use Render MySQL

- Create new MySQL database in Render
- Copy credentials to Step 3 environment variables

Option B: Use existing database

- Ensure your database is accessible from Render
- Update connection details in Step 3

### Step 5: Configure Frontend

Set API base in your frontend (e.g., in `login.php`):

```javascript
window.__API_BASE_URL__ = "https://your-backend.onrender.com";
```

**That's it!** Your backend is now live on Render.

## File Structure

```
plp-gsrs-portal/
├── backend/                     ← Your backend service
│   ├── Dockerfile              ← Docker image definition
│   ├── .dockerignore           ← Files to exclude from image
│   ├── .env.example            ← Environment template
│   ├── README.md               ← Backend documentation
│   ├── index.php               ← Entry point
│   ├── api/                    ← API wrappers
│   │   ├── _bootstrap.php
│   │   ├── health.php
│   │   ├── auth/
│   │   └── php/
│   ├── auth/                   ← Auth implementation
│   ├── php/                    ← Business logic
│   └── PHPMailer/              ← Email library
├── docker-compose.yml          ← Local dev setup
├── docker-helper.ps1           ← Windows helper script
├── docker-helper.sh            ← Mac/Linux helper script
├── render.yaml                 ← Render IaC (optional)
├── RENDER_DEPLOYMENT.md        ← Render guide
├── DOCKER_DEPLOYMENT_CHECKLIST.md
├── .github/workflows/deploy.yml ← Auto-deploy (optional)
└── js/
    └── api-client.js           ← Frontend API helper
```

## Key Features

✅ **Production-Ready**

- PHP 8.2 with Apache
- All required extensions pre-installed
- CORS properly configured
- Health check endpoint

✅ **Secure**

- Environment variables for secrets
- No sensitive data in code
- Session cookie settings for HTTPS

✅ **Tested**

- Dockerfile syntax validated
- All API routes configured
- Frontend already wired

✅ **Documented**

- Step-by-step guides
- Troubleshooting sections
- Helper scripts for automation

## Typical Render Pricing

- **Web Service (Starter):** $7/month
- **MySQL Database:** $15/month (if using Render DB)
- **Free tier available:** For testing

See https://render.com/pricing for details.

## Troubleshooting

### Docker won't start locally

- Ensure Docker Desktop is running
- Check available disk space
- Run: `docker system prune` to free up space

### "Build Failed" on Render

- Check Render **Logs** tab for error details
- Ensure `Dockerfile` is in `backend/` directory
- All files must be committed to GitHub

### API returning 404

- Verify `FRONTEND_ORIGINS` includes your frontend domain
- Check frontend sets `window.__API_BASE_URL__` correctly
- Confirm API routes in backend (check `backend/api/health.php` first)

### Database connection failed

- Test MySQL connection locally first
- Verify credentials in `.env` / Render environment variables
- Ensure database server is running and accessible

### See detailed help

- **Local testing:** Run `.\docker-helper.ps1 help` (or `./docker-helper.sh help`)
- **Render deployment:** Read `RENDER_DEPLOYMENT.md`
- **Full checklist:** See `DOCKER_DEPLOYMENT_CHECKLIST.md`

## Next Steps

1. ✅ Test locally with Docker:

   ```powershell
   .\docker-helper.ps1 start
   ```

2. ⏳ Push to GitHub and deploy to Render (see Step-by-step guide above)

3. ⏳ Configure frontend API base URL

4. ⏳ Test all endpoints in production

5. ⏳ Monitor Render dashboard for issues

---

**Questions?** Check the deployment guides or the troubleshooting section above.
