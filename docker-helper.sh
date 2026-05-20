#!/bin/bash

# PLP GSRS Backend Docker Helper Script

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${YELLOW}Docker is not installed.${NC}"
        echo "Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    print_success "Docker is installed"
}

# Setup environment
setup_env() {
    print_header "Setting up environment"
    
    if [ ! -f backend/.env ]; then
        cp backend/.env.example backend/.env
        print_success "Created backend/.env from template"
        print_warning "Please edit backend/.env with your database credentials"
    else
        print_success "backend/.env already exists"
    fi
}

# Start services
start_services() {
    print_header "Starting Docker services"
    check_docker
    
    docker-compose up -d
    
    print_success "Services started"
    echo -e "\n${GREEN}Backend available at:${NC} http://localhost:8080"
    echo -e "${GREEN}MySQL available at:${NC} localhost:3306"
    
    # Wait for services to be ready
    echo -e "\n${YELLOW}Waiting for services to start (30 seconds)...${NC}"
    sleep 30
    
    # Test health endpoint
    print_header "Testing API health"
    if curl -s http://localhost:8080/api/health.php | grep -q "ok"; then
        print_success "API health check passed"
    else
        print_warning "API health check may not be ready yet"
        echo "Check http://localhost:8080/api/health.php manually"
    fi
}

# Stop services
stop_services() {
    print_header "Stopping Docker services"
    docker-compose down
    print_success "Services stopped"
}

# View logs
view_logs() {
    print_header "Backend logs (Ctrl+C to exit)"
    docker-compose logs -f backend
}

# Clean up everything
cleanup() {
    print_header "Cleaning up"
    
    if docker-compose ps -q backend &>/dev/null; then
        docker-compose down -v
        print_success "Removed containers and volumes"
    fi
    
    print_warning "Note: Database data has been removed"
}

# Build Docker image
build_image() {
    print_header "Building Docker image"
    check_docker
    
    docker build -t plp-gsrs-backend:local -f backend/Dockerfile backend
    print_success "Docker image built successfully"
    print_warning "You can now deploy to Render"
}

# Show commands
show_help() {
    cat << EOF
${BLUE}PLP GSRS Backend Docker Helper${NC}

Usage: ./docker-helper.sh [command]

Commands:
  start      Start backend and MySQL services (requires Docker)
  stop       Stop all services
  logs       View backend logs in real-time
  setup      Create .env file from template
  build      Build Docker image locally
  clean      Remove all containers and volumes (⚠️ deletes data)
  help       Show this help message

Examples:
  ./docker-helper.sh setup    # Setup environment variables
  ./docker-helper.sh start    # Start services
  ./docker-helper.sh logs     # Watch logs
  ./docker-helper.sh stop     # Stop services

${YELLOW}For Render deployment, see:${NC}
  DOCKER_DEPLOYMENT_CHECKLIST.md
  RENDER_DEPLOYMENT.md
EOF
}

# Main
case "${1:-help}" in
    start)
        setup_env
        start_services
        ;;
    stop)
        stop_services
        ;;
    logs)
        view_logs
        ;;
    setup)
        setup_env
        ;;
    build)
        build_image
        ;;
    clean)
        cleanup
        ;;
    help)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
