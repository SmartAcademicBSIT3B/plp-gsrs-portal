# PLP GSRS Backend Docker Helper (PowerShell)
# Usage: .\docker-helper.ps1 [start|stop|logs|setup|build|clean|help]

param(
    [string]$Command = "help"
)

# Colors and output functions
function Write-Header {
    param([string]$Text)
    Write-Host "`n========================================" -ForegroundColor Blue
    Write-Host $Text -ForegroundColor Blue
    Write-Host "========================================`n" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Text)
    Write-Host "✓ $Text" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Text)
    Write-Host "⚠ $Text" -ForegroundColor Yellow
}

# Check Docker installation
function Test-Docker {
    try {
        docker --version | Out-Null
        Write-Success "Docker is installed"
        return $true
    } catch {
        Write-Warning "Docker is not installed"
        Write-Host "Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
        return $false
    }
}

# Setup environment
function Invoke-Setup {
    Write-Header "Setting up environment"
    
    $envFile = "backend\.env"
    if (-not (Test-Path $envFile)) {
        Copy-Item "backend\.env.example" $envFile
        Write-Success "Created backend\.env from template"
        Write-Warning "Please edit backend\.env with your database credentials"
    } else {
        Write-Success "backend\.env already exists"
    }
}

# Start services
function Invoke-Start {
    Write-Header "Starting Docker services"
    
    if (-not (Test-Docker)) { return }
    
    Invoke-Setup
    
    Write-Host "Starting Docker Compose..." -ForegroundColor Cyan
    docker-compose up -d
    
    Write-Success "Services started"
    Write-Host "Backend available at: http://localhost:8080" -ForegroundColor Green
    Write-Host "MySQL available at: localhost:3306" -ForegroundColor Green
    
    Write-Host "`nWaiting for services to start (30 seconds)..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    
    Write-Header "Testing API health"
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080/api/health.php" -UseBasicParsing
        if ($response.Content -like "*ok*") {
            Write-Success "API health check passed"
        } else {
            Write-Warning "API health check may not be ready yet"
        }
    } catch {
        Write-Warning "Could not reach API. Check http://localhost:8080/api/health.php manually"
    }
}

# Stop services
function Invoke-Stop {
    Write-Header "Stopping Docker services"
    docker-compose down
    Write-Success "Services stopped"
}

# View logs
function Invoke-Logs {
    Write-Header "Backend logs (Ctrl+C to exit)"
    docker-compose logs -f backend
}

# Build Docker image
function Invoke-Build {
    Write-Header "Building Docker image"
    
    if (-not (Test-Docker)) { return }
    
    Write-Host "Building Docker image..." -ForegroundColor Cyan
    docker build -t plp-gsrs-backend:local -f backend/Dockerfile backend
    
    Write-Success "Docker image built successfully"
    Write-Warning "You can now deploy to Render"
}

# Cleanup
function Invoke-Cleanup {
    Write-Header "Cleaning up"
    
    try {
        $status = docker-compose ps -q backend 2>$null
        if ($status) {
            docker-compose down -v
            Write-Success "Removed containers and volumes"
        }
    } catch {
        Write-Warning "Could not stop services"
    }
    
    Write-Warning "Note: Database data has been removed"
}

# Show help
function Show-Help {
    Write-Host @"
PLP GSRS Backend Docker Helper

Usage: .\docker-helper.ps1 [command]

Commands:
  start      Start backend and MySQL services (requires Docker)
  stop       Stop all services
  logs       View backend logs in real-time
  setup      Create .env file from template
  build      Build Docker image locally
  clean      Remove all containers and volumes (⚠️ deletes data)
  help       Show this help message

Examples:
  .\docker-helper.ps1 setup    # Setup environment variables
  .\docker-helper.ps1 start    # Start services
  .\docker-helper.ps1 logs     # Watch logs
  .\docker-helper.ps1 stop     # Stop services

For Render deployment, see:
  DOCKER_DEPLOYMENT_CHECKLIST.md
  RENDER_DEPLOYMENT.md
"@ -ForegroundColor Cyan
}

# Main execution
switch ($Command.ToLower()) {
    "start" { Invoke-Start }
    "stop" { Invoke-Stop }
    "logs" { Invoke-Logs }
    "setup" { Invoke-Setup }
    "build" { Invoke-Build }
    "clean" { Invoke-Cleanup }
    "help" { Show-Help }
    default {
        Write-Host "Unknown command: $Command" -ForegroundColor Red
        Write-Host ""
        Show-Help
        exit 1
    }
}
