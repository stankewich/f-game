# Game Design Document

## Core Gameplay Loop

1. **Prepare**: Set tactics, training, handle transfers
2. **Simulate**: Watch/simulate matches
3. **React**: Respond to results, adjust strategy
4. **Progress**: Develop players, improve club
5. **Repeat**: Next match, next season

## Game Modes

### Career Mode (Single Player)
- Manage a club through multiple seasons
- Objectives set by board (league position, finances, youth development)
- Job security based on performance
- Can move to different clubs

### Online League (Multiplayer)
- 10-20 human managers in same league
- Scheduled match days (e.g., matches simulate at 8 PM daily)
- Transfer market with human competition
- League chat and diplomacy
- Seasonal rewards and rankings

### Quick Match (Casual)
- Single match with simplified management
- Test tactics and formations
- No long-term consequences

## Core Systems

### 1. Match Simulation

#### Tactical System
- **Formations**: 4-4-2, 4-3-3, 3-5-2, 5-3-2, custom formations
- **Playing Style**: Possession, Counter-attack, Direct, Pressing
- **Defensive Line**: High, Medium, Low
- **Width**: Narrow, Balanced, Wide
- **Tempo**: Slow build-up, Balanced, Fast tempo
- **Pressing Intensity**: Low, Medium, High, Gegenpressing

#### Player Instructions
- Individual roles (Target Man, Playmaker, Ball Winner, etc.)
- Specific instructions (Stay back, Get forward, Cut inside, etc.)
- Set piece takers

#### Match Events
- Goals, assists, shots (on/off target)
- Tackles, interceptions, passes (completed/failed)
- Fouls, cards (yellow/red)
- Injuries
- Substitutions
- Momentum shifts

#### Match Visualization
- 2D tactical view with player positions
- Live text commentary
- Key highlights
- Statistics dashboard

### 2. Player System

#### Attributes (0-20 scale)
**Technical:**
- Finishing, Shooting, Passing, Crossing, Dribbling, First Touch, Technique

**Mental:**
- Vision, Decision Making, Composure, Work Rate, Teamwork, Leadership, Aggression

**Physical:**
- Pace, Acceleration, Stamina, Strength, Jumping, Agility, Balance

**Goalkeeping:**
- Reflexes, Handling, Positioning, One-on-Ones, Command of Area, Kicking

#### Hidden Attributes
- Consistency, Important Matches, Injury Proneness
- Adaptability, Ambition, Professionalism

#### Player Development
- Age curve (peak 26-30, decline after 31)
- Training effects on attributes
- Match experience
- Mentoring from senior players
- Potential rating (determines growth ceiling)

#### Player Morale
- Affected by: Playing time, results, contract situation, team harmony
- Effects: Performance, training effectiveness, transfer requests
- Manager interactions to boost morale

#### Fitness & Injuries
- Match fitness (0-100%)
- Training load management
- Injury types: Minor (1-2 weeks), Moderate (3-6 weeks), Severe (2-6 months)
- Recovery and rehabilitation

### 3. Training System

#### Training Focus Areas
- Attacking: Finishing, Chance Creation, Set Pieces
- Defending: Defensive Shape, Pressing, Set Piece Defense
- Fitness: Stamina, Strength, Recovery
- Tactics: Team Cohesion, Positional Play
- Individual: One-on-one sessions for specific players

#### Training Intensity
- Light: Low injury risk, minimal development, good for recovery
- Moderate: Balanced approach
- Heavy: High development, increased injury risk, fitness drain

#### Training Schedule
- Weekly schedule (7 days between matches)
- Rest days before/after matches
- Automated or manual control

### 4. Transfer System

#### Transfer Market
- AI-generated players with realistic attributes
- Real-time market with supply/demand
- Player values based on: Age, ability, potential, contract, form

#### Transfer Activities
- **Buying**: Scout players, make offers, negotiate fees
- **Selling**: List players, receive offers, negotiate
- **Loans**: Temporary transfers for development
- **Free Agents**: Sign players without clubs
- **Youth Intake**: Annual influx of young players

#### Contract Negotiations
- Wage demands
- Contract length
- Bonuses (appearance, goals, clean sheets, trophies)
- Release clauses
- Agent fees

#### Scouting
- Scout regions/leagues
- Player reports with attribute estimates
- Hidden gems vs known stars

### 5. Tactical Communication

#### Team Talks
- Pre-match: Motivate, set expectations
- Half-time: React to performance, adjust tactics
- Post-match: Praise or criticize
- Effects on morale and performance

#### Individual Conversations
- Discuss playing time
- Contract discussions
- Resolve conflicts
- Mentorship

#### Press Conferences
- Pre/post-match interviews
- Transfer speculation responses
- Affects media reputation and player morale

### 6. Club Management

#### Finances
- Revenue: Match day, TV rights, sponsorships, merchandise
- Expenses: Wages, transfers, facilities, staff
- Budget management
- Financial fair play compliance

#### Facilities
- Training ground quality (affects development)
- Stadium capacity (affects revenue)
- Youth academy rating (affects youth intake quality)
- Medical facilities (affects injury recovery)

#### Staff
- Assistant Manager: Tactical advice, handles training
- Coaches: Improve training effectiveness
- Scouts: Find players
- Physios: Injury prevention and recovery
- Sports Scientists: Fitness optimization

#### Board Objectives
- League position targets
- Cup performance
- Financial targets
- Youth development goals
- Playing style requirements

### 7. Competition Structure

#### League System
- 20 teams per league
- 38 matches (home and away)
- Points system (3 for win, 1 for draw)
- Promotion/relegation
- Multiple divisions

#### Cup Competitions
- Domestic cup (knockout format)
- League cup
- Continental competitions (Champions League style)

#### Season Calendar
- Pre-season (friendlies, training)
- Regular season (August - May)
- Transfer windows (Summer, Winter)
- International breaks

## Progression Systems

### Manager Reputation
- Grows with success
- Unlocks better job opportunities
- Affects transfer negotiations

### Club Reputation
- Based on: League position, trophies, European performance
- Affects: Player attraction, sponsorship deals, media coverage

### Achievements
- Career milestones
- Special challenges
- Cosmetic rewards

## User Interface

### Main Screens
- **Dashboard**: Overview, upcoming matches, notifications
- **Squad**: Player list, attributes, contracts, morale
- **Tactics**: Formation, instructions, set pieces
- **Training**: Schedule, player development, fitness
- **Transfers**: Market, negotiations, scouting
- **Match**: Live simulation, tactics adjustment
- **Finances**: Budget, revenue, expenses
- **Club**: Facilities, staff, board objectives
- **League**: Table, fixtures, statistics

### Mobile Considerations
- Simplified UI for smaller screens
- Quick actions (team selection, basic tactics)
- Notifications for important events
- Offline capability for single-player

## Monetization (Future Consideration)

### Free-to-Play Options
- Base game free
- Premium features: Advanced analytics, custom leagues, cosmetics
- No pay-to-win mechanics

### Premium Subscription
- Ad-free experience
- Additional save slots
- Priority support
- Exclusive cosmetics

### One-Time Purchase
- Full game unlock
- All features included
- No ads

## Technical Requirements

### Performance Targets
- Match simulation: < 5 seconds for full match
- UI responsiveness: < 100ms for interactions
- Real-time updates: < 500ms latency
- Support 10,000+ concurrent users

### Data Requirements
- Player database: 50,000+ players
- Historical data: 10+ seasons
- Match events: Detailed logging for analysis

### Platform Support
- Web: Modern browsers (Chrome, Firefox, Safari, Edge)
- Mobile: iOS 14+, Android 10+
- Responsive design for tablets
