# Setup Instructions

Инструкции по установке и настройке всех необходимых инструментов для разработки Football Manager проекта.

## Порядок установки

Рекомендуется устанавливать инструменты в следующем порядке:

### 1. [Git Setup](GIT_SETUP.md)
- Установка Git
- Настройка пользователя
- Инициализация репозитория
- Подключение к GitHub

### 2. [Docker Setup](DOCKER_SETUP.md)
- Установка Docker Desktop
- Настройка WSL 2 (Windows)
- Основные команды Docker
- Решение проблем

### 3. [Node.js Setup](NODEJS_SETUP.md)
- Установка Node.js через NVM
- Настройка npm
- Установка глобальных пакетов
- Настройка для проекта

### 4. [Go Setup](GO_SETUP.md)
- Установка Go
- Настройка окружения
- Go Modules
- Полезные инструменты

## Быстрая проверка

После установки всех инструментов выполните команды для проверки:

```bash
# Проверка версий
git --version          # Git 2.x.x
node --version         # v20.x.x или новее
npm --version          # 10.x.x или новее
go version            # go1.21.x или новее
docker --version      # Docker version 24.x.x или новее
docker-compose --version  # Docker Compose version 2.x.x или новее

# Тест Docker
docker run hello-world
```

## Структура проекта после настройки

```
football-manager/
├── .git/                    # Git репозиторий
├── .env                     # Переменные среды (создать из .env.example)
├── docker-compose.yml       # Docker сервисы
├── services/
│   ├── api-gateway/         # Node.js API (npm install)
│   └── match-engine/        # Go сервис (go mod tidy)
├── apps/
│   └── web/                 # Next.js приложение (npm install)
└── docs/
    └── setup/               # Эти инструкции
```

## Следующие шаги

После установки всех инструментов:

1. **Скопируйте переменные среды:**
   ```bash
   cp .env.example .env
   ```

2. **Запустите инфраструктуру:**
   ```bash
   make up
   # или
   docker-compose up -d postgres redis nats
   ```

3. **Установите зависимости:**
   ```bash
   make install
   # или вручную:
   cd services/api-gateway && npm install
   cd services/match-engine && go mod tidy
   cd apps/web && npm install
   ```

4. **Запустите сервисы разработки:**
   ```bash
   # Terminal 1: API Gateway
   cd services/api-gateway && npm run dev
   
   # Terminal 2: Match Engine
   cd services/match-engine && go run main.go
   
   # Terminal 3: Web App
   cd apps/web && npm run dev
   ```

## Помощь

Если возникают проблемы:

1. Проверьте, что все инструменты установлены правильно
2. Убедитесь, что Docker Desktop запущен
3. Проверьте переменные среды в `.env` файле
4. Посмотрите логи сервисов: `docker-compose logs`

Подробные инструкции по решению проблем есть в каждом файле setup.