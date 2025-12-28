# Football Manager - Online Web & Mobile

A detailed football management simulation game for web and mobile platforms, inspired by classic FIFA Manager with modern online multiplayer capabilities.

## Vision

Create a deep, engaging football management experience where players can:
- Manage every aspect of a football club (tactics, training, transfers, finances)
- Compete in online leagues with other managers
- Experience realistic match simulations with detailed tactical systems
- Communicate with players, staff, and board members
- Develop youth academies and long-term club strategies

## Core Philosophy

- **Depth over simplicity**: Detailed simulation for hardcore management fans
- **Cross-platform**: Seamless experience across web and mobile
- **Online-first**: Multiplayer leagues, live competitions, community features
- **Realistic simulation**: Complex match engine with tactical depth

## Project Status

🚧 **Phase 0: Foundation** → **Phase 1: Core Match Engine**

Setting up development environment and beginning core match simulation development.

## Quick Start

### Prerequisites
- Node.js 20+
- Go 1.21+
- Docker & Docker Compose
- Make (optional, for convenience commands)

### Setup Development Environment

1. **Clone and setup:**
```bash
git clone <repository-url>
cd football-manager
cp .env.example .env
```

2. **Start infrastructure:**
```bash
make up
# or manually: docker-compose up -d postgres redis nats
```

3. **Install dependencies:**
```bash
make install
# or manually:
# cd services/api-gateway && npm install
# cd services/match-engine && go mod tidy
```

4. **Start development servers:**
```bash
# Terminal 1: API Gateway
cd services/api-gateway
npm run dev

# Terminal 2: Match Engine
cd services/match-engine
go run main.go

# Terminal 3: Web App (when ready)
cd apps/web
npm run dev
```

### Available Commands

- `make help` - Show all available commands
- `make dev` - Start infrastructure and show next steps
- `make up` - Start infrastructure services
- `make down` - Stop all services
- `make logs` - Show service logs
- `make clean` - Clean up containers and volumes
- `make install` - Install all dependencies
- `make test` - Run tests

### Service URLs

- **API Gateway**: http://localhost:3000
- **Match Engine**: http://localhost:8080
- **Web App**: http://localhost:3001 (when implemented)
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379
- **NATS**: localhost:4222

## Project Structure

```
football-manager/
├── apps/
│   ├── web/              # Next.js web application
│   └── mobile/           # React Native mobile app (future)
├── services/
│   ├── api-gateway/      # Node.js API gateway
│   ├── match-engine/     # Go match simulation service
│   ├── training-service/ # Go training system (future)
│   └── transfer-service/ # Go transfer market AI (future)
├── docs/                 # Project documentation
├── database/             # Database schemas and migrations
└── docker-compose.yml    # Local development infrastructure
```
