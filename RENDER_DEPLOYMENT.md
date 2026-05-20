# Render Deployment Guide

## Prerequisites

1. Render account (https://render.com)
2. MySQL database (Render provides managed MySQL)
3. GitHub repository pushed to main branch
4. Environment variables configured

## Step-by-Step Deployment

### 1. Provision Database (if needed)

In Render Dashboard:

1. Create new **PostgreSQL** or **MySQL** database
2. Note the connection credentials
3. Create your schema with your migrations

### 2. Create Web Service

1. Go to Render Dashboard
2. Click **New +** → **Web Service**
3. Connect to your GitHub repository
4. Configure:
   - **Name**: `plp-gsrs-backend`
   - **Root Directory**: `backend` (optional, keep empty if Dockerfile is at root)
   - **Runtime**: **Docker**
   - **Build Command**: Leave empty (uses Dockerfile default)
   - **Start Command**: Leave empty (uses Dockerfile CMD)

### 3. Environment Variables

Add these in the **Environment** section:

```
MYSQL_HOST=your-mysql-host.render.com
MYSQL_PORT=3306
MYSQL_USER=your_username
MYSQL_PASSWORD=your_password
MYSQL_DATABASE=plp_gsrs

FRONTEND_ORIGINS=https://your-frontend.com,https://www.your-frontend.com

API_BASE_URL=https://plp-gsrs-backend.onrender.com

GOOGLE_OAUTH_CLIENT_ID=your_id_here
GOOGLE_OAUTH_CLIENT_SECRET=your_secret_here

SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
SMTP_FROM_EMAIL=noreply@your-domain.com
```

### 4. Deploy

1. Click **Create Web Service**
2. Render will automatically build and deploy your Docker image
3. Watch the logs for any errors
4. Your service will be available at `https://plp-gsrs-backend.onrender.com`

## Troubleshooting

### Service Won't Start

- Check logs in Render dashboard
- Ensure all environment variables are set
- Verify database connection string is correct
- Check Docker build output

### CORS Errors

- Verify `FRONTEND_ORIGINS` includes your frontend domain
- Check that frontend sets `window.__API_BASE_URL__` correctly

### Database Connection Failed

- Ensure MySQL database is running on Render
- Check `MYSQL_HOST`, `MYSQL_USER`, `MYSQL_PASSWORD` are correct
- Verify database exists
- Check firewall/security group allows connections

### Session/Cookie Issues

- Ensure HTTPS is used in production
- Check session cookie settings in `_bootstrap.php`
- Verify `FRONTEND_ORIGINS` includes your frontend origin

## Auto-Deploy on Push

To enable auto-deployment when you push to main:

1. Render will auto-detect and rebuild on push (if repo is connected)
2. Optional: Set up GitHub Actions for custom deployment (see `.github/workflows/deploy.yml`)

## Rolling Back

In Render Dashboard:

1. Go to Web Service → **Deploys**
2. Click previous deployment
3. Click **Redeploy**

## Monitoring

In Render Dashboard:

- **Metrics**: CPU, memory, disk usage
- **Logs**: Real-time application logs
- **Events**: Deployment history
