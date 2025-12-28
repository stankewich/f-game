# System Architecture

## Overview

Hybrid microservices architecture leveraging Go for performance-critical simulation services and Node.js/TypeScript for API gateway and real-time communication.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         Clients                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Web App    │  │ Mobile (iOS) │  │Mobile(Android)│      │
│  │ (React/Next) │  │              │  │               │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬────────┘      │
└─────────┼──────────────────┼──────────────────┼──────────────┘
          │                  │                  │
          └──────────────────┼──────────────────┘
                             │
                    ┌────────▼────────┐
                    │   API Gateway   │
                    │  (Node.js/TS)   │
                    │                 │
                    │ - Auth          │
                    │ - Rate Limiting │
                    │ - Routing       │
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┐
          │                  │                  │
┌─────────▼─────────┐ ┌─────▼──────┐ ┌────────▼────────┐
│  WebSocket Server │ │  User API  │ │  Admin Service  │
│   (Node.js/TS)    │ │(Node.js/TS)│ │  (Node.js/TS)   │
│                   │ │            │ │                 │
│ - Live updates    │ │ - Profile  │ │ - Management    │
│ - Notifications   │ │ - Teams    │ │ - Analytics     │
│ - Chat            │ │ - Leagues  │ │                 │
└───────────────────┘ └────────────┘ └─────────────────┘
          │                  │                  │
          └──────────────────┼──────────────────┘
                             │
                    ┌────────▼────────┐
                    │  Message Queue  │
                    │  (RabbitMQ/NATS)│
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┬──────────────┐
          │                  │                  │              │
┌─────────▼─────────┐ ┌─────▼──────┐ ┌────────▼────────┐ ┌───▼────┐
│  Match Engine     │ │  Training  │ │ Transfer Market │ │ Season │
│     (Go)          │ │ System(Go) │ │   AI (Go)       │ │Sim(Go) │
│                   │ │            │ │                 │ │        │
│ - Simulation      │ │ - Player   │ │ - AI offers     │ │ - Prog │
│ - Tactics         │ │   dev      │ │ - Negotiation   │ │ - Table│
│ - Events          │ │ - Fitness  │ │ - Market value  │ │ - Stats│
└───────────────────┘ └────────────┘ └─────────────────┘ └────────┘
          │                  │                  │              │
          └──────────────────┼──────────────────┴──────────────┘
                             │
                    ┌────────▼────────┐
                    │   PostgreSQL    │
                    │                 │
                    │ - Users/Teams   │
                    │ - Players       │
                    │ - Matches       │
                    │ - Tactics       │
                    └─────────────────┘
                             │
                    ┌────────▼────────┐
                    │      Redis      │
                    │                 │
                    │ - Cache         │
                    │ - Sessions      │
                    │ - Pub/Sub       │
                    └─────────────────┘
```

## Technology Stack

### Frontend
- **Web**: React with Next.js (SSR, routing, API routes)
- **Mobile**: React Native (iOS & Android)
- **State Management**: Zustand or Redux Toolkit
- **UI Components**: Tailwind CSS + shadcn/ui
- **Real-time**: Socket.io client

### Backend - Node.js Services
- **Runtime**: Node.js 20+ with TypeScript
- **Framework**: Express or Fastify
- **WebSocket**: Socket.io
- **Authentication**: JWT + Passport.js
- **Validation**: Zod
- **ORM**: Prisma

### Backend - Go Services
- **Version**: Go 1.21+
- **HTTP**: net/http or Gin framework
- **Database**: pgx (PostgreSQL driver)
- **Messaging**: NATS or RabbitMQ client
- **Testing**: testify

### Infrastructure
- **Database**: PostgreSQL 15+
- **Cache**: Redis 7+
- **Message Queue**: NATS or RabbitMQ
- **Container**: Docker + Docker Compose
- **Orchestration**: Kubernetes (production)

## Service Responsibilities

### API Gateway (Node.js)
- Single entry point for all client requests
- Authentication and authorization
- Rate limiting and request validation
- Route requests to appropriate services
- API documentation (Swagger/OpenAPI)

### WebSocket Server (Node.js)
- Real-time match updates
- Live notifications (transfers, messages, events)
- Chat functionality
- Presence tracking

### User API (Node.js)
- User profile management
- Team/club management
- League operations
- Historical data queries

### Match Engine (Go)
- Core match simulation logic
- Tactical system implementation
- Player AI and decision making
- Match event generation
- Performance-optimized calculations

### Training System (Go)
- Player development calculations
- Fitness and morale tracking
- Training schedule effects
- Injury simulation

### Transfer Market AI (Go)
- AI club behavior (offers, bids)
- Player valuation algorithms
- Contract negotiation logic
- Market dynamics

### Season Simulation (Go)
- League table calculations
- Fixture generation
- Season progression
- Statistics aggregation

## Data Flow Examples

### Match Simulation Flow
1. User submits tactics via Web/Mobile client
2. API Gateway validates and forwards to User API
3. User API stores tactics in PostgreSQL
4. Match Engine (Go) retrieves match data
5. Engine simulates match, generates events
6. Events published to message queue
7. WebSocket server receives events, pushes to clients
8. Results stored in PostgreSQL

### Player Training Flow
1. User sets training schedule via client
2. API Gateway → User API stores schedule
3. Training System (Go) runs daily calculations
4. Player attributes updated in PostgreSQL
5. Notifications sent via message queue
6. WebSocket pushes updates to online clients

## Communication Patterns

### Synchronous (REST/gRPC)
- Client → API Gateway → Node.js services
- Node.js services → Go services (for immediate results)

### Asynchronous (Message Queue)
- Go services → Message Queue → Node.js services
- Background jobs and event-driven updates

### Real-time (WebSocket)
- Server → Clients for live updates
- Bidirectional for chat and interactive features

## Scalability Considerations

- **Horizontal scaling**: All services are stateless (except WebSocket with sticky sessions)
- **Database**: Read replicas for queries, write master for updates
- **Caching**: Redis for frequently accessed data (player stats, league tables)
- **CDN**: Static assets and media
- **Load balancing**: Nginx or cloud load balancer

## Security

- JWT tokens with refresh mechanism
- Rate limiting per user/IP
- Input validation at gateway level
- SQL injection prevention (parameterized queries)
- HTTPS/TLS for all communications
- Environment-based secrets management

## Development Workflow

1. Local development with Docker Compose
2. Feature branches with PR reviews
3. Automated testing (unit, integration, e2e)
4. CI/CD pipeline (GitHub Actions / GitLab CI)
5. Staging environment for testing
6. Blue-green deployment for production
