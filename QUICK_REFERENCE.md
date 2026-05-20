# Docker Backend: Quick Reference Card

## 📋 What You Now Have

✅ **Dockerized PHP Backend** ready for Render  
✅ **Frontend API Routes** already wired to backend  
✅ **Local Testing** with Docker Compose  
✅ **Environment Configuration** templates  
✅ **Deployment Documentation** and helpers

## 🏃 Quickest Path to Render

### 1. Push Code (2 minutes)

```bash
git add -A
git commit -m "Docker backend ready for Render"
git push origin main
```

### 2. Create Render Service (2 minutes)

- Go to https://render.com
- Click **New** → **Web Service**
- Select your GitHub repo
- Set **Runtime: Docker**
- Click **Create**

### 3. Set 8 Environment Variables (3 minutes)

In Render → **Environment**, paste these (get values from your setup):

```
MYSQL_HOST=your-host
MYSQL_USER=plp_user
MYSQL_PASSWORD=xxxxx
MYSQL_DATABASE=plp_gsrs
FRONTEND_ORIGINS=https://your-frontend.com
API_BASE_URL=https://plp-gsrs-backend.onrender.com
GOOGLE_OAUTH_CLIENT_ID=xxxxx
GOOGLE_OAUTH_CLIENT_SECRET=xxxxx
```

### 4. Add API Base in Frontend (1 minute)

In `login.php`, add to first `<script>` tag:

```javascript
window.__API_BASE_URL__ = "https://plp-gsrs-backend.onrender.com";
```

**Total time: ~8 minutes** ⏱️

## 🧪 Test Locally First (Recommended)

### Windows:

```powershell
.\docker-helper.ps1 start
# Open http://localhost:8080/api/health.php
.\docker-helper.ps1 stop
```

### Mac/Linux:

```bash
chmod +x docker-helper.sh
./docker-helper.sh start
# Open http://localhost:8080/api/health.php
./docker-helper.sh stop
```

## 📁 New Files Created

| File                             | Purpose                 |
| -------------------------------- | ----------------------- |
| `backend/Dockerfile`             | Docker image definition |
| `backend/.env.example`           | Environment template    |
| `docker-compose.yml`             | Local dev stack         |
| `docker-helper.ps1`              | Windows helper          |
| `docker-helper.sh`               | Mac/Linux helper        |
| `RENDER_DEPLOYMENT.md`           | Detailed Render guide   |
| `DOCKER_DEPLOYMENT_CHECKLIST.md` | Troubleshooting & tips  |
| `DOCKER_SETUP_COMPLETE.md`       | Full setup guide        |

## 🔗 Key URLs

| Service          | URL                                                 |
| ---------------- | --------------------------------------------------- |
| Local Backend    | http://localhost:8080                               |
| Local API Health | http://localhost:8080/api/health.php                |
| Render Dashboard | https://render.com/dashboard                        |
| GitHub Actions   | https://github.com/YOUR_ORG/plp-gsrs-portal/actions |

## ⚠️ Common Issues

| Issue                     | Solution                                     |
| ------------------------- | -------------------------------------------- |
| Docker won't start        | Ensure Docker Desktop is running             |
| API returns 404           | Check `FRONTEND_ORIGINS` matches your domain |
| Database connection fails | Verify MySQL credentials in `.env`           |
| Render build fails        | Check **Logs** in Render dashboard           |
| CORS errors in frontend   | Set `window.__API_BASE_URL__` correctly      |

## 📞 Documentation Files

- **`DOCKER_SETUP_COMPLETE.md`** ← Start here
- **`RENDER_DEPLOYMENT.md`** ← Render-specific steps
- **`DOCKER_DEPLOYMENT_CHECKLIST.md`** ← Troubleshooting

## 💰 Render Pricing

- **Web Service (Starter):** $7/month
- **MySQL Database:** $15/month (or use external)
- **Free tier:** Available for testing

See https://render.com/pricing

## ✅ Success Checklist

After deployment:

- [ ] Backend service shows "Live" in Render
- [ ] Health endpoint returns: `{"status":"ok","timestamp":"..."}`
- [ ] Frontend API calls work (check browser console)
- [ ] Database queries successful (check Render logs)
- [ ] CORS errors resolved
- [ ] All endpoints functional

## 🚀 Next Steps

1. Test locally: `.\docker-helper.ps1 start`
2. Push to GitHub: `git push origin main`
3. Create Render service: https://render.com
4. Set environment variables
5. Update frontend API base URL
6. Monitor Render dashboard

---

**Questions?** See full documentation:

- `DOCKER_SETUP_COMPLETE.md` - Complete setup guide
- `RENDER_DEPLOYMENT.md` - Render step-by-step
- `backend/README.md` - Backend documentation
