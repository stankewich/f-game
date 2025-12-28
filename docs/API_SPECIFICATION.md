# API Specification

## Overview

RESTful API with WebSocket support for real-time features.

**Base URL**: `https://api.footballmanager.com/v1`

**Authentication**: JWT Bearer tokens

---

## Authentication

### POST /auth/register
Register a new user account.

**Request Body:**
```json
{
  "email": "user@example.com",
  "username": "player123",
  "password": "securePassword123"
}
```

**Response (201):**
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "username": "player123",
    "createdAt": "2025-12-09T10:00:00Z"
  },
  "token": "jwt.token.here"
}
```

### POST /auth/login
Authenticate and receive JWT token.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Response (200):**
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "username": "player123"
  },
  "token": "jwt.token.here",
  "refreshToken": "refresh.token.here"
}
```

### POST /auth/refresh
Refresh expired JWT token.

**Request Body:**
```json
{
  "refreshToken": "refresh.token.here"
}
```

**Response (200):**
```json
{
  "token": "new.jwt.token.here"
}
```

---

## Clubs

### GET /clubs/:id
Get club details.

**Response (200):**
```json
{
  "id": "uuid",
  "name": "Manchester City",
  "shortName": "MCI",
  "foundedYear": 1880,
  "stadiumName": "Etihad Stadium",
  "stadiumCapacity": 55000,
  "reputation": 85,
  "balance": 150000000,
  "league": {
    "id": "uuid",
    "name": "Premier League"
  },
  "facilities": {
    "trainingGroundLevel": 9,
    "youthAcademyLevel": 8,
    "medicalFacilityLevel": 10
  }
}
```

### GET /clubs/:id/squad
Get club's player squad.

**Query Parameters:**
- `position` (optional): Filter by position (GK, CB, CM, ST, etc.)
- `sortBy` (optional): Sort field (rating, age, value)

**Response (200):**
```json
{
  "players": [
    {
      "id": "uuid",
      "firstName": "Kevin",
      "lastName": "De Bruyne",
      "age": 32,
      "position": "CAM",
      "nationality": "BEL",
      "shirtNumber": 17,
      "rating": 89,
      "value": 75000000,
      "wage": 350000,
      "contractExpires": "2025-06-30",
      "status": {
        "fitness": 95,
        "morale": 85,
        "form": 88
      }
    }
  ]
}
```

### PATCH /clubs/:id
Update club settings (manager only).

**Request Body:**
```json
{
  "stadiumName": "New Stadium Name"
}
```

**Response (200):**
```json
{
  "id": "uuid",
  "name": "Manchester City",
  "stadiumName": "New Stadium Name"
}
```

---

## Players

### GET /players/:id
Get detailed player information.

**Response (200):**
```json
{
  "id": "uuid",
  "firstName": "Erling",
  "lastName": "Haaland",
  "dateOfBirth": "2000-07-21",
  "age": 24,
  "nationality": "NOR",
  "position": "ST",
  "preferredFoot": "Left",
  "shirtNumber": 9,
  "club": {
    "id": "uuid",
    "name": "Manchester City"
  },
  "contractExpires": "2027-06-30",
  "wage": 400000,
  "value": 180000000,
  "attributes": {
    "finishing": 19,
    "shooting": 18,
    "pace": 19,
    "strength": 18,
    "positioning": 18,
    "composure": 16
  },
  "status": {
    "fitness": 100,
    "morale": 90,
    "form": 95,
    "matchSharpness": 98,
    "injury": null
  }
}
```

### GET /players/:id/statistics
Get player career statistics.

**Query Parameters:**
- `season` (optional): Filter by season ID

**Response (200):**
```json
{
  "playerId": "uuid",
  "season": "2024-25",
  "appearances": 28,
  "goals": 32,
  "assists": 8,
  "yellowCards": 2,
  "redCards": 0,
  "minutesPlayed": 2340,
  "averageRating": 8.4
}
```

---

## Matches

### GET /matches/:id
Get match details.

**Response (200):**
```json
{
  "id": "uuid",
  "league": {
    "id": "uuid",
    "name": "Premier League"
  },
  "matchday": 15,
  "scheduledTime": "2025-12-15T15:00:00Z",
  "status": "completed",
  "homeClub": {
    "id": "uuid",
    "name": "Manchester City",
    "score": 3
  },
  "awayClub": {
    "id": "uuid",
    "name": "Liverpool",
    "score": 2
  },
  "attendance": 54000,
  "statistics": {
    "home": {
      "possession": 58,
      "shots": 15,
      "shotsOnTarget": 8,
      "passes": 542,
      "passAccuracy": 87
    },
    "away": {
      "possession": 42,
      "shots": 12,
      "shotsOnTarget": 6,
      "passes": 398,
      "passAccuracy": 82
    }
  }
}
```

### GET /matches/:id/events
Get match events timeline.

**Response (200):**
```json
{
  "events": [
    {
      "id": "uuid",
      "minute": 12,
      "eventType": "goal",
      "player": {
        "id": "uuid",
        "name": "Erling Haaland"
      },
      "assistPlayer": {
        "id": "uuid",
        "name": "Kevin De Bruyne"
      },
      "description": "Haaland finishes from close range after De Bruyne's through ball"
    },
    {
      "id": "uuid",
      "minute": 34,
      "eventType": "yellow_card",
      "player": {
        "id": "uuid",
        "name": "Rodri"
      },
      "description": "Rodri booked for tactical foul"
    }
  ]
}
```

### POST /matches/:id/simulate
Trigger match simulation (Go service).

**Request Body:**
```json
{
  "speed": "normal"
}
```

**Response (202):**
```json
{
  "message": "Match simulation started",
  "matchId": "uuid",
  "estimatedDuration": 5
}
```

### GET /matches/:id/lineup
Get match lineups.

**Response (200):**
```json
{
  "home": {
    "formation": "4-3-3",
    "starters": [
      {
        "player": {
          "id": "uuid",
          "name": "Ederson",
          "position": "GK"
        },
        "shirtNumber": 31,
        "role": "sweeper_keeper"
      }
    ],
    "substitutes": []
  },
  "away": {
    "formation": "4-3-3",
    "starters": [],
    "substitutes": []
  }
}
```

---

## Tactics

### GET /clubs/:clubId/tactics
Get club's current tactics.

**Response (200):**
```json
{
  "formation": "4-3-3",
  "playingStyle": "possession",
  "defensiveLine": "high",
  "width": "wide",
  "tempo": "fast",
  "pressingIntensity": "high",
  "playerInstructions": [
    {
      "playerId": "uuid",
      "role": "false_nine",
      "instructions": ["drop_deep", "link_play"]
    }
  ]
}
```

### PUT /clubs/:clubId/tactics
Update club tactics.

**Request Body:**
```json
{
  "formation": "4-2-3-1",
  "playingStyle": "counter",
  "defensiveLine": "medium",
  "width": "balanced",
  "tempo": "balanced",
  "pressingIntensity": "medium"
}
```

**Response (200):**
```json
{
  "message": "Tactics updated successfully",
  "tactics": { }
}
```

---

## Training

### GET /clubs/:clubId/training/schedule
Get current training schedule.

**Response (200):**
```json
{
  "weekStartDate": "2025-12-09",
  "focusArea": "attacking",
  "intensity": "moderate",
  "sessions": [
    {
      "date": "2025-12-09",
      "type": "tactical",
      "duration": 90
    },
    {
      "date": "2025-12-10",
      "type": "fitness",
      "duration": 60
    }
  ]
}
```

### POST /clubs/:clubId/training/schedule
Create new training schedule.

**Request Body:**
```json
{
  "weekStartDate": "2025-12-16",
  "focusArea": "defending",
  "intensity": "heavy"
}
```

**Response (201):**
```json
{
  "message": "Training schedule created",
  "schedule": { }
}
```

---

## Transfers

### GET /transfers/market
Browse transfer market.

**Query Parameters:**
- `position` (optional): Filter by position
- `minRating` (optional): Minimum player rating
- `maxPrice` (optional): Maximum price
- `page` (optional): Page number
- `limit` (optional): Results per page

**Response (200):**
```json
{
  "listings": [
    {
      "id": "uuid",
      "player": {
        "id": "uuid",
        "name": "John Doe",
        "age": 24,
        "position": "CM",
        "rating": 78
      },
      "sellingClub": {
        "id": "uuid",
        "name": "Example FC"
      },
      "askingPrice": 15000000,
      "listedAt": "2025-12-01T10:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150
  }
}
```

### POST /transfers/offers
Make transfer offer.

**Request Body:**
```json
{
  "listingId": "uuid",
  "offerAmount": 18000000,
  "wageOffer": 50000,
  "contractLength": 4
}
```

**Response (201):**
```json
{
  "offer": {
    "id": "uuid",
    "status": "pending",
    "offerAmount": 18000000,
    "createdAt": "2025-12-09T10:00:00Z"
  }
}
```

### GET /transfers/offers/:id
Get offer status.

**Response (200):**
```json
{
  "id": "uuid",
  "status": "accepted",
  "offerAmount": 18000000,
  "respondedAt": "2025-12-09T12:00:00Z"
}
```

---

## Leagues

### GET /leagues/:id
Get league information.

**Response (200):**
```json
{
  "id": "uuid",
  "name": "Premier League",
  "country": "ENG",
  "tier": 1,
  "reputation": 95,
  "season": {
    "id": "uuid",
    "startDate": "2025-08-15",
    "endDate": "2026-05-20",
    "currentMatchday": 15
  }
}
```

### GET /leagues/:id/standings
Get league table.

**Response (200):**
```json
{
  "standings": [
    {
      "position": 1,
      "club": {
        "id": "uuid",
        "name": "Manchester City"
      },
      "played": 15,
      "won": 12,
      "drawn": 2,
      "lost": 1,
      "goalsFor": 38,
      "goalsAgainst": 12,
      "goalDifference": 26,
      "points": 38,
      "form": "WWDWW"
    }
  ]
}
```

### GET /leagues/:id/fixtures
Get league fixtures.

**Query Parameters:**
- `matchday` (optional): Specific matchday
- `clubId` (optional): Filter by club

**Response (200):**
```json
{
  "fixtures": [
    {
      "id": "uuid",
      "matchday": 16,
      "scheduledTime": "2025-12-15T15:00:00Z",
      "homeClub": {
        "id": "uuid",
        "name": "Arsenal"
      },
      "awayClub": {
        "id": "uuid",
        "name": "Chelsea"
      },
      "status": "scheduled"
    }
  ]
}
```

---

## WebSocket Events

### Connection
```
ws://api.footballmanager.com/ws?token=jwt.token.here
```

### Events from Server

#### match.update
Real-time match updates.
```json
{
  "event": "match.update",
  "data": {
    "matchId": "uuid",
    "minute": 23,
    "homeScore": 1,
    "awayScore": 0,
    "lastEvent": {
      "type": "goal",
      "player": "Erling Haaland"
    }
  }
}
```

#### notification
General notifications.
```json
{
  "event": "notification",
  "data": {
    "type": "transfer_offer",
    "title": "New Transfer Offer",
    "message": "Liverpool has made an offer for John Doe",
    "timestamp": "2025-12-09T10:00:00Z"
  }
}
```

#### chat.message
Chat messages in multiplayer leagues.
```json
{
  "event": "chat.message",
  "data": {
    "leagueId": "uuid",
    "sender": {
      "id": "uuid",
      "username": "player123"
    },
    "message": "Good luck everyone!",
    "timestamp": "2025-12-09T10:00:00Z"
  }
}
```

### Events to Server

#### subscribe.match
Subscribe to match updates.
```json
{
  "event": "subscribe.match",
  "data": {
    "matchId": "uuid"
  }
}
```

#### chat.send
Send chat message.
```json
{
  "event": "chat.send",
  "data": {
    "leagueId": "uuid",
    "message": "Great match!"
  }
}
```

---

## Error Responses

### Standard Error Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

### Common Error Codes
- `UNAUTHORIZED` (401): Invalid or missing authentication
- `FORBIDDEN` (403): Insufficient permissions
- `NOT_FOUND` (404): Resource not found
- `VALIDATION_ERROR` (400): Invalid input data
- `CONFLICT` (409): Resource conflict (e.g., duplicate username)
- `RATE_LIMIT_EXCEEDED` (429): Too many requests
- `INTERNAL_ERROR` (500): Server error

---

## Rate Limiting

- **Standard endpoints**: 100 requests per minute per user
- **Match simulation**: 10 requests per minute per user
- **WebSocket**: 1000 messages per minute per connection

Rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1702123456
```
