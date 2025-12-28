# Database Schema

## Overview

PostgreSQL relational database with normalized structure for game data.

## Core Tables

### Users & Authentication

```sql
-- Users (managers/players of the game)
users
  id: uuid (PK)
  email: varchar(255) UNIQUE
  username: varchar(50) UNIQUE
  password_hash: varchar(255)
  created_at: timestamp
  last_login: timestamp
  is_active: boolean
  email_verified: boolean

-- User sessions
sessions
  id: uuid (PK)
  user_id: uuid (FK -> users.id)
  token: varchar(500)
  expires_at: timestamp
  created_at: timestamp
  ip_address: varchar(45)
  user_agent: text
```

### Game Entities

```sql
-- Clubs/Teams
clubs
  id: uuid (PK)
  name: varchar(100)
  short_name: varchar(20)
  founded_year: int
  stadium_name: varchar(100)
  stadium_capacity: int
  reputation: int (0-100)
  balance: bigint (money in cents)
  league_id: uuid (FK -> leagues.id)
  user_id: uuid (FK -> users.id) NULL (NULL = AI-controlled)
  created_at: timestamp

-- Club facilities
club_facilities
  id: uuid (PK)
  club_id: uuid (FK -> clubs.id)
  training_ground_level: int (1-10)
  youth_academy_level: int (1-10)
  medical_facility_level: int (1-10)
  updated_at: timestamp

-- Players
players
  id: uuid (PK)
  first_name: varchar(50)
  last_name: varchar(50)
  date_of_birth: date
  nationality: varchar(3) (ISO country code)
  position: varchar(20) (GK, CB, LB, RB, CDM, CM, CAM, LW, RW, ST)
  preferred_foot: varchar(10) (Left, Right, Both)
  club_id: uuid (FK -> clubs.id) NULL
  contract_expires: date NULL
  wage: int (weekly wage in cents)
  value: bigint (market value in cents)
  created_at: timestamp

-- Player attributes
player_attributes
  id: uuid (PK)
  player_id: uuid (FK -> players.id)
  -- Technical
  finishing: int (0-20)
  shooting: int (0-20)
  passing: int (0-20)
  crossing: int (0-20)
  dribbling: int (0-20)
  first_touch: int (0-20)
  technique: int (0-20)
  -- Mental
  vision: int (0-20)
  decision_making: int (0-20)
  composure: int (0-20)
  work_rate: int (0-20)
  teamwork: int (0-20)
  leadership: int (0-20)
  aggression: int (0-20)
  -- Physical
  pace: int (0-20)
  acceleration: int (0-20)
  stamina: int (0-20)
  strength: int (0-20)
  jumping: int (0-20)
  agility: int (0-20)
  balance: int (0-20)
  -- Goalkeeping
  reflexes: int (0-20)
  handling: int (0-20)
  positioning: int (0-20)
  one_on_ones: int (0-20)
  command_of_area: int (0-20)
  kicking: int (0-20)
  -- Meta
  potential: int (0-20)
  updated_at: timestamp

-- Player status (dynamic data)
player_status
  id: uuid (PK)
  player_id: uuid (FK -> players.id)
  fitness: int (0-100)
  morale: int (0-100)
  form: int (0-100) (recent performance)
  match_sharpness: int (0-100)
  injury_type: varchar(50) NULL
  injury_return_date: date NULL
  updated_at: timestamp
```

### Competitions

```sql
-- Leagues
leagues
  id: uuid (PK)
  name: varchar(100)
  country: varchar(3)
  tier: int (1 = top division)
  reputation: int (0-100)
  season_id: uuid (FK -> seasons.id)

-- Seasons
seasons
  id: uuid (PK)
  start_date: date
  end_date: date
  current_matchday: int
  status: varchar(20) (active, completed, upcoming)

-- League standings
league_standings
  id: uuid (PK)
  league_id: uuid (FK -> leagues.id)
  club_id: uuid (FK -> clubs.id)
  position: int
  played: int
  won: int
  drawn: int
  lost: int
  goals_for: int
  goals_against: int
  goal_difference: int
  points: int
  form: varchar(10) (last 5 results: WWDLW)
  updated_at: timestamp
```

### Matches

```sql
-- Fixtures
matches
  id: uuid (PK)
  league_id: uuid (FK -> leagues.id)
  season_id: uuid (FK -> seasons.id)
  matchday: int
  home_club_id: uuid (FK -> clubs.id)
  away_club_id: uuid (FK -> clubs.id)
  scheduled_time: timestamp
  status: varchar(20) (scheduled, in_progress, completed, postponed)
  home_score: int NULL
  away_score: int NULL
  attendance: int NULL
  created_at: timestamp

-- Match tactics (pre-match setup)
match_tactics
  id: uuid (PK)
  match_id: uuid (FK -> matches.id)
  club_id: uuid (FK -> clubs.id)
  formation: varchar(10) (4-4-2, 4-3-3, etc.)
  playing_style: varchar(20) (possession, counter, direct, pressing)
  defensive_line: varchar(20) (high, medium, low)
  width: varchar(20) (narrow, balanced, wide)
  tempo: varchar(20) (slow, balanced, fast)
  pressing_intensity: varchar(20) (low, medium, high, gegenpress)
  created_at: timestamp

-- Match lineups
match_lineups
  id: uuid (PK)
  match_id: uuid (FK -> matches.id)
  club_id: uuid (FK -> clubs.id)
  player_id: uuid (FK -> players.id)
  position: varchar(20)
  is_starter: boolean
  shirt_number: int
  player_role: varchar(30) (target_man, playmaker, ball_winner, etc.)

-- Match events
match_events
  id: uuid (PK)
  match_id: uuid (FK -> matches.id)
  minute: int
  event_type: varchar(30) (goal, assist, yellow_card, red_card, substitution, injury)
  player_id: uuid (FK -> players.id)
  secondary_player_id: uuid (FK -> players.id) NULL (for assists, substitutions)
  description: text
  created_at: timestamp

-- Match statistics
match_statistics
  id: uuid (PK)
  match_id: uuid (FK -> matches.id)
  club_id: uuid (FK -> clubs.id)
  possession: int (0-100)
  shots: int
  shots_on_target: int
  passes: int
  pass_accuracy: int (0-100)
  tackles: int
  interceptions: int
  fouls: int
  corners: int
  offsides: int
```

### Transfers

```sql
-- Transfer market listings
transfer_listings
  id: uuid (PK)
  player_id: uuid (FK -> players.id)
  selling_club_id: uuid (FK -> clubs.id)
  asking_price: bigint
  listed_at: timestamp
  status: varchar(20) (active, sold, withdrawn)

-- Transfer offers
transfer_offers
  id: uuid (PK)
  listing_id: uuid (FK -> transfer_listings.id)
  buying_club_id: uuid (FK -> clubs.id)
  offer_amount: bigint
  wage_offer: int
  contract_length: int (years)
  status: varchar(20) (pending, accepted, rejected, withdrawn)
  created_at: timestamp
  responded_at: timestamp NULL

-- Transfer history
transfer_history
  id: uuid (PK)
  player_id: uuid (FK -> players.id)
  from_club_id: uuid (FK -> clubs.id) NULL
  to_club_id: uuid (FK -> clubs.id)
  transfer_fee: bigint
  transfer_type: varchar(20) (permanent, loan, free)
  transfer_date: date
```

### Training

```sql
-- Training schedules
training_schedules
  id: uuid (PK)
  club_id: uuid (FK -> clubs.id)
  week_start_date: date
  focus_area: varchar(30) (attacking, defending, fitness, tactics)
  intensity: varchar(20) (light, moderate, heavy)
  created_at: timestamp

-- Player training sessions
player_training_sessions
  id: uuid (PK)
  player_id: uuid (FK -> players.id)
  schedule_id: uuid (FK -> training_schedules.id)
  date: date
  performance: int (0-100)
  attribute_gains: jsonb ({"passing": 0.1, "fitness": 0.2})
  created_at: timestamp
```

### Communication

```sql
-- Messages (internal game communications)
messages
  id: uuid (PK)
  from_type: varchar(20) (board, player, agent, media)
  from_id: uuid NULL (player_id if from player)
  to_club_id: uuid (FK -> clubs.id)
  subject: varchar(200)
  body: text
  message_type: varchar(30) (contract_request, complaint, praise, news)
  is_read: boolean
  created_at: timestamp

-- Team talks
team_talks
  id: uuid (PK)
  match_id: uuid (FK -> matches.id)
  club_id: uuid (FK -> clubs.id)
  timing: varchar(20) (pre_match, half_time, post_match)
  tone: varchar(20) (motivational, calm, aggressive, disappointed)
  message: text
  morale_effect: int (-10 to +10)
  created_at: timestamp
```

## Indexes

```sql
-- Performance indexes
CREATE INDEX idx_players_club ON players(club_id);
CREATE INDEX idx_matches_clubs ON matches(home_club_id, away_club_id);
CREATE INDEX idx_matches_league_season ON matches(league_id, season_id);
CREATE INDEX idx_match_events_match ON match_events(match_id);
CREATE INDEX idx_league_standings_league ON league_standings(league_id);
CREATE INDEX idx_transfer_listings_status ON transfer_listings(status);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_sessions_token ON sessions(token);
```

## Data Relationships

- One User can manage one Club (1:1)
- One Club has many Players (1:N)
- One Player has one set of Attributes (1:1)
- One Player has one Status record (1:1)
- One League has many Clubs (1:N)
- One Match involves two Clubs (N:2)
- One Match has many Events (1:N)
- One Match has two Tactics records (1:2)
- One Match has many Lineup entries (1:N)

## Data Integrity

- Foreign keys with CASCADE on delete where appropriate
- NOT NULL constraints on required fields
- CHECK constraints for value ranges (e.g., attributes 0-20)
- UNIQUE constraints on usernames, emails
- Default values for timestamps (NOW())

## Partitioning Strategy (Future)

For scalability with large datasets:
- Partition `match_events` by season
- Partition `player_training_sessions` by date range
- Archive old seasons to separate tables
