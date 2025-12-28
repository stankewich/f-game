.PHONY: help dev up down logs clean install test

# Default target
help:
	@echo "Football Manager Development Commands:"
	@echo "  make dev     - Start all services in development mode"
	@echo "  make up      - Start infrastructure (DB, Redis, NATS)"
	@echo "  make down    - Stop all services"
	@echo "  make logs    - Show logs from all services"
	@echo "  make clean   - Clean up containers and volumes"
	@echo "  make install - Install dependencies"
	@echo "  make test    - Run tests"

# Start infrastructure
up:
	docker-compose up -d postgres redis nats
	@echo "Infrastructure started. Waiting for services to be ready..."
	@sleep 5

# Stop all services
down:
	docker-compose down

# Start development environment
dev: up
	@echo "Starting development services..."
	@echo "You can now run:"
	@echo "  cd services/api-gateway && npm run dev"
	@echo "  cd services/match-engine && go run main.go"

# Show logs
logs:
	docker-compose logs -f

# Clean up
clean:
	docker-compose down -v
	docker system prune -f

# Install dependencies
install:
	@echo "Installing Node.js dependencies..."
	cd services/api-gateway && npm install
	@echo "Installing Go dependencies..."
	cd services/match-engine && go mod tidy

# Run tests
test:
	@echo "Running API tests..."
	cd services/api-gateway && npm test
	@echo "Running Go tests..."
	cd services/match-engine && go test ./...