# Docker Environment Documentation

Полная документация по настройке и использованию Docker окружения для Football Manager проекта.

## Содержание

### 📋 [Основная настройка](DOCKER_ENVIRONMENT_SETUP.md)
Пошаговое руководство по настройке Docker окружения:
- Обзор инфраструктуры и компонентов
- Объяснение зачем нужен каждый сервис
- Детальный разбор docker-compose.yml
- Настройка переменных среды
- Запуск и тестирование сервисов

### 🔧 [Решение проблем](TROUBLESHOOTING.md)
Руководство по диагностике и решению проблем:
- Docker Desktop не запускается
- Контейнеры не запускаются
- Проблемы с PostgreSQL, Redis, NATS
- Проблемы с производительностью и сетью
- Диагностические команды

### 📖 [Справочник команд](COMMANDS_REFERENCE.md)
Полный справочник команд Docker и Docker Compose:
- Управление сервисами и контейнерами
- Работа с базами данных
- Мониторинг и отладка
- Управление томами и сетями
- Полезные алиасы

## Быстрый старт

### 1. Проверка требований
```bash
# Убедитесь, что Docker установлен и запущен
docker --version
docker-compose --version
docker info
```

### 2. Настройка окружения
```bash
# Скопируйте переменные среды
copy .env.example .env

# Запустите инфраструктуру
docker-compose up -d postgres redis nats
```

### 3. Проверка работы
```bash
# Проверьте статус сервисов
docker-compose ps

# Проверьте подключения
docker exec fm_postgres pg_isready -U fm_user -d football_manager
docker exec fm_redis redis-cli ping
curl http://localhost:8222/varz
```

## Архитектура инфраструктуры

```
┌─────────────────────────────────────────────────────────────┐
│                Football Manager Infrastructure               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ PostgreSQL  │  │    Redis    │  │        NATS         │  │
│  │             │  │             │  │                     │  │
│  │ Port: 5432  │  │ Port: 6379  │  │ Ports: 4222, 8222  │  │
│  │             │  │             │  │                     │  │
│  │ • Users     │  │ • Cache     │  │ • Events            │  │
│  │ • Players   │  │ • Sessions  │  │ • Notifications     │  │
│  │ • Matches   │  │ • Pub/Sub   │  │ • Service Comm      │  │
│  │ • Tactics   │  │ • Temp Data │  │ • Real-time Updates │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Компоненты инфраструктуры

### 🐘 PostgreSQL
- **Назначение**: Основная реляционная база данных
- **Версия**: 15 (LTS)
- **Порт**: 5432
- **Данные**: Пользователи, игроки, матчи, тактики, трансферы

### 🔴 Redis
- **Назначение**: In-memory кэш и хранилище сессий
- **Версия**: 7 Alpine
- **Порт**: 6379
- **Данные**: Кэш, сессии, временные данные, pub/sub

### 📨 NATS
- **Назначение**: Система обмена сообщениями
- **Версия**: 2.10 Alpine
- **Порты**: 4222 (клиенты), 8222 (мониторинг)
- **Данные**: События матчей, уведомления, межсервисная связь

## Основные команды

### Управление сервисами
```bash
# Запуск
docker-compose up -d

# Остановка
docker-compose down

# Перезапуск
docker-compose restart

# Логи
docker-compose logs -f
```

### Подключение к сервисам
```bash
# PostgreSQL
docker exec -it fm_postgres psql -U fm_user -d football_manager

# Redis
docker exec -it fm_redis redis-cli

# NATS мониторинг
curl http://localhost:8222/varz
```

### Мониторинг
```bash
# Статус контейнеров
docker-compose ps

# Использование ресурсов
docker stats

# Логи в реальном времени
docker-compose logs -f
```

## Интеграция с приложением

### Переменные среды (.env)
```env
# Database
DATABASE_URL=postgresql://fm_user:fm_password@localhost:5432/football_manager

# Redis
REDIS_URL=redis://localhost:6379

# NATS
NATS_URL=nats://localhost:4222

# JWT
JWT_SECRET=your-super-secret-jwt-key
```

### Подключение из Node.js
```javascript
// PostgreSQL
import { Pool } from 'pg';
const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

// Redis
import Redis from 'ioredis';
const redis = new Redis(process.env.REDIS_URL);

// NATS
import { connect } from 'nats';
const nc = await connect({ servers: process.env.NATS_URL });
```

### Подключение из Go
```go
// PostgreSQL
import "github.com/jackc/pgx/v5/pgxpool"
pool, err := pgxpool.New(context.Background(), os.Getenv("DATABASE_URL"))

// Redis
import "github.com/redis/go-redis/v9"
rdb := redis.NewClient(&redis.Options{Addr: "localhost:6379"})

// NATS
import "github.com/nats-io/nats.go"
nc, err := nats.Connect(os.Getenv("NATS_URL"))
```

## Полезные ссылки

- **PostgreSQL**: http://localhost:5432 (подключение через клиент)
- **Redis**: http://localhost:6379 (подключение через клиент)
- **NATS Monitoring**: http://localhost:8222 (веб-интерфейс)

## Следующие шаги

После настройки Docker окружения:

1. **Установите Node.js и Go** (см. [setup документацию](../))
2. **Создайте схему базы данных** (см. [DATABASE_SCHEMA.md](../../DATABASE_SCHEMA.md))
3. **Запустите сервисы приложения** (API Gateway, Match Engine)
4. **Начните разработку** согласно [DEVELOPMENT_ROADMAP.md](../../DEVELOPMENT_ROADMAP.md)

## Поддержка

Если возникают проблемы:
1. Проверьте [Troubleshooting Guide](TROUBLESHOOTING.md)
2. Используйте [Commands Reference](COMMANDS_REFERENCE.md)
3. Проверьте логи: `docker-compose logs`
4. Убедитесь, что Docker Desktop запущен

Эта инфраструктура обеспечивает надежную основу для разработки Football Manager и может быть легко масштабирована для продакшена.