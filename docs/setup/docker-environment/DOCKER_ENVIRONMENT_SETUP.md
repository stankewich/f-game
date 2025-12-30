# Docker Environment Setup Guide

Пошаговое руководство по настройке Docker окружения для разработки Football Manager проекта.

## Обзор инфраструктуры

Наш проект использует микросервисную архитектуру с следующими компонентами:

```
┌─────────────────────────────────────────────────────────────┐
│                    Development Environment                   │
├─────────────────────────────────────────────────────────────┤
│  PostgreSQL    │  Redis Cache   │  NATS Message Queue       │
│  (Database)    │  (Cache/Sess)  │  (Service Communication)  │
│  Port: 5432    │  Port: 6379    │  Ports: 4222, 8222       │
└─────────────────────────────────────────────────────────────┘
```

## Зачем нужен каждый компонент

### PostgreSQL (База данных)
- **Назначение**: Основная реляционная база данных
- **Что хранит**: 
  - Пользователи и аутентификация
  - Клубы, игроки, лиги
  - Матчи и их результаты
  - Тактики и тренировки
  - Трансферы и контракты
- **Почему PostgreSQL**: 
  - Надежность и ACID транзакции
  - Отличная производительность для сложных запросов
  - Поддержка JSON для гибких данных
  - Расширения для полнотекстового поиска

### Redis (Кэш и сессии)
- **Назначение**: In-memory кэш и хранилище сессий
- **Что хранит**:
  - Сессии пользователей (JWT токены)
  - Кэш API ответов
  - Временные данные матчей
  - Pub/Sub для real-time уведомлений
- **Почему Redis**:
  - Очень быстрый доступ к данным (в памяти)
  - Встроенная поддержка Pub/Sub
  - Автоматическое истечение ключей (TTL)
  - Поддержка различных структур данных

### NATS (Message Queue)
- **Назначение**: Асинхронная связь между сервисами
- **Что передает**:
  - События матчей (голы, карточки, замены)
  - Уведомления о трансферах
  - Задачи на обработку (тренировки, развитие игроков)
  - Синхронизация между Go и Node.js сервисами
- **Почему NATS**:
  - Легковесный и быстрый
  - Простая настройка
  - Поддержка различных паттернов (pub/sub, request/reply)
  - Хорошая производительность для игровых приложений

## Файл docker-compose.yml

### Полная конфигурация

```yaml
version: '3.8'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:15                    # Стабильная LTS версия
    container_name: fm_postgres           # Понятное имя контейнера
    environment:
      POSTGRES_DB: football_manager       # Имя базы данных
      POSTGRES_USER: fm_user             # Пользователь БД
      POSTGRES_PASSWORD: fm_password     # Пароль (в продакшене из secrets)
    ports:
      - "5432:5432"                      # Проброс порта на хост
    volumes:
      - postgres_data:/var/lib/postgresql/data    # Постоянное хранение данных
      - ./database/init:/docker-entrypoint-initdb.d  # Скрипты инициализации
    networks:
      - fm_network                       # Изолированная сеть

  # Redis Cache
  redis:
    image: redis:7-alpine               # Alpine версия (меньше размер)
    container_name: fm_redis
    ports:
      - "6379:6379"                     # Стандартный порт Redis
    volumes:
      - redis_data:/data                # Сохранение данных Redis
    networks:
      - fm_network

  # NATS Message Queue
  nats:
    image: nats:2.10-alpine
    container_name: fm_nats
    ports:
      - "4222:4222"                     # Клиентские подключения
      - "8222:8222"                     # HTTP мониторинг
    command: ["-js", "-m", "8222"]      # Включение JetStream и мониторинга
    networks:
      - fm_network

volumes:
  postgres_data:                        # Именованный том для PostgreSQL
  redis_data:                          # Именованный том для Redis

networks:
  fm_network:                          # Изолированная сеть для сервисов
    driver: bridge
```

### Объяснение каждой секции

#### Services (Сервисы)

**PostgreSQL секция:**
- `image: postgres:15` - Используем официальный образ PostgreSQL версии 15
- `container_name` - Задаем понятное имя вместо случайного
- `environment` - Переменные среды для настройки БД
- `ports` - Пробрасываем порт 5432 для подключения с хоста
- `volumes` - Монтируем том для сохранения данных между перезапусками
- `networks` - Подключаем к изолированной сети

**Redis секция:**
- `redis:7-alpine` - Alpine версия меньше по размеру
- Простая конфигурация, так как Redis работает из коробки
- Том для сохранения данных (если включена персистентность)

**NATS секция:**
- `command: ["-js", "-m", "8222"]` - Включаем JetStream и HTTP мониторинг
- Два порта: 4222 для клиентов, 8222 для веб-интерфейса мониторинга

#### Volumes (Тома)
- **Именованные тома** сохраняют данные между перезапусками контейнеров
- Docker управляет их расположением автоматически
- Можно посмотреть: `docker volume ls`

#### Networks (Сети)
- **Изолированная сеть** позволяет сервисам общаться между собой
- Сервисы недоступны извне, кроме пробрасываемых портов
- Повышает безопасность

## Пошаговая настройка

### 1. Создание .env файла

```bash
# Копируем пример конфигурации
copy .env.example .env
```

**Зачем нужен .env файл:**
- Хранит переменные среды для разработки
- Позволяет легко менять настройки без изменения кода
- Исключен из Git для безопасности (пароли, ключи)

**Основные переменные:**
```env
# Database - настройки подключения к PostgreSQL
DATABASE_URL=postgresql://fm_user:fm_password@localhost:5432/football_manager

# Redis - настройки кэша
REDIS_URL=redis://localhost:6379

# NATS - настройки очереди сообщений
NATS_URL=nats://localhost:4222

# JWT - секретный ключ для токенов
JWT_SECRET=your-super-secret-jwt-key-change-in-production
```

### 2. Запуск инфраструктуры

```bash
# Запуск всех сервисов в фоновом режиме
docker-compose up -d postgres redis nats
```

**Что происходит:**
1. Docker скачивает образы (если их нет локально)
2. Создает именованные тома для данных
3. Создает изолированную сеть
4. Запускает контейнеры в правильном порядке
5. Пробрасывает порты на хост

### 3. Проверка запуска

**Статус контейнеров:**
```bash
docker ps
```

**Логи сервисов:**
```bash
# Все логи
docker-compose logs

# Логи конкретного сервиса
docker-compose logs postgres
docker-compose logs redis
docker-compose logs nats
```

### 4. Тестирование подключений

**PostgreSQL:**
```bash
# Проверка готовности
docker exec fm_postgres pg_isready -U fm_user -d football_manager

# Подключение к БД
docker exec -it fm_postgres psql -U fm_user -d football_manager
```

**Redis:**
```bash
# Проверка работы
docker exec fm_redis redis-cli ping

# Подключение к Redis CLI
docker exec -it fm_redis redis-cli
```

**NATS:**
```bash
# Проверка HTTP мониторинга
curl http://localhost:8222/varz
# или в PowerShell:
Invoke-WebRequest -Uri http://localhost:8222/varz
```

## Полезные команды для разработки

### Управление сервисами

```bash
# Запуск всех сервисов
docker-compose up -d

# Запуск конкретных сервисов
docker-compose up -d postgres redis

# Остановка всех сервисов
docker-compose down

# Остановка с удалением томов (ОСТОРОЖНО - удалит данные!)
docker-compose down -v

# Перезапуск сервиса
docker-compose restart postgres

# Просмотр логов в реальном времени
docker-compose logs -f
```

### Мониторинг и отладка

```bash
# Статус контейнеров
docker ps

# Использование ресурсов
docker stats

# Информация о томах
docker volume ls
docker volume inspect football-manager_postgres_data

# Информация о сетях
docker network ls
docker network inspect football-manager_fm_network

# Подключение к контейнеру
docker exec -it fm_postgres bash
docker exec -it fm_redis sh
docker exec -it fm_nats sh
```

### Работа с базой данных

```bash
# Подключение к PostgreSQL
docker exec -it fm_postgres psql -U fm_user -d football_manager

# Создание бэкапа
docker exec fm_postgres pg_dump -U fm_user football_manager > backup.sql

# Восстановление из бэкапа
docker exec -i fm_postgres psql -U fm_user -d football_manager < backup.sql

# Просмотр таблиц
docker exec fm_postgres psql -U fm_user -d football_manager -c "\dt"
```

### Работа с Redis

```bash
# Подключение к Redis
docker exec -it fm_redis redis-cli

# Основные команды Redis:
# SET key value - установить значение
# GET key - получить значение
# KEYS * - показать все ключи
# FLUSHALL - очистить все данные
```

## Решение проблем

### Контейнер не запускается

1. **Проверьте логи:**
   ```bash
   docker-compose logs service_name
   ```

2. **Проверьте порты:**
   ```bash
   netstat -an | findstr :5432
   # Если порт занят, измените в docker-compose.yml
   ```

3. **Очистите старые контейнеры:**
   ```bash
   docker-compose down
   docker system prune -f
   ```

### Проблемы с данными

1. **Сброс данных PostgreSQL:**
   ```bash
   docker-compose down
   docker volume rm football-manager_postgres_data
   docker-compose up -d postgres
   ```

2. **Очистка Redis:**
   ```bash
   docker exec fm_redis redis-cli FLUSHALL
   ```

### Проблемы с производительностью

1. **Увеличьте ресурсы Docker Desktop:**
   - Settings → Resources → Advanced
   - Memory: 4-8 GB
   - CPU: 2-4 cores

2. **Проверьте использование ресурсов:**
   ```bash
   docker stats
   ```

## Интеграция с приложением

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
rdb := redis.NewClient(&redis.Options{
    Addr: "localhost:6379",
})

// NATS
import "github.com/nats-io/nats.go"
nc, err := nats.Connect(os.Getenv("NATS_URL"))
```

## Продакшн соображения

### Безопасность
- Используйте сильные пароли
- Настройте SSL/TLS для внешних подключений
- Ограничьте доступ к портам
- Используйте Docker secrets для паролей

### Производительность
- Настройте PostgreSQL для вашей нагрузки
- Используйте Redis clustering для высокой нагрузки
- Мониторьте использование ресурсов

### Резервное копирование
- Регулярные бэкапы PostgreSQL
- Репликация для критичных данных
- Мониторинг состояния сервисов

Эта инфраструктура обеспечивает надежную основу для разработки и может быть легко масштабирована для продакшена.