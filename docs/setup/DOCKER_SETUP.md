# Docker Setup Guide

## Установка Docker Desktop

### Windows

#### Системные требования
- Windows 10 64-bit: Pro, Enterprise, или Education (Build 16299 или новее)
- Windows 11 64-bit: Home или Pro версия 21H2 или новее
- WSL 2 feature включен
- Виртуализация включена в BIOS

#### Установка
1. **Скачайте Docker Desktop** с официального сайта:
   https://www.docker.com/products/docker-desktop/

2. **Запустите установщик** `Docker Desktop Installer.exe`

3. **Следуйте инструкциям установщика:**
   - Убедитесь, что выбрана опция "Use WSL 2 instead of Hyper-V"
   - Выберите "Add shortcut to desktop" если нужно

4. **Перезагрузите компьютер** после установки

5. **Запустите Docker Desktop** из меню Пуск

6. **Дождитесь полной загрузки** Docker Desktop (может занять несколько минут при первом запуске)

#### Настройка WSL 2 (если требуется)
Если WSL 2 не установлен:

1. Откройте PowerShell как администратор
2. Выполните команды:
```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
3. Перезагрузите компьютер
4. Скачайте и установите WSL 2 kernel update: https://aka.ms/wsl2kernel
5. Установите WSL 2 как версию по умолчанию:
```powershell
wsl --set-default-version 2
```

### Проверка установки

Откройте командную строку или PowerShell и выполните:

```bash
docker --version
docker-compose --version
```

Должны увидеть версии Docker и Docker Compose.

### Тест установки

Запустите тестовый контейнер:
```bash
docker run hello-world
```

Если увидите сообщение "Hello from Docker!", установка прошла успешно.

## Основные команды Docker

### Управление контейнерами
```bash
docker ps                    # Показать запущенные контейнеры
docker ps -a                 # Показать все контейнеры
docker stop container_name   # Остановить контейнер
docker start container_name  # Запустить контейнер
docker rm container_name     # Удалить контейнер
```

### Управление образами
```bash
docker images               # Показать все образы
docker pull image_name      # Скачать образ
docker rmi image_name       # Удалить образ
```

### Docker Compose
```bash
docker-compose up           # Запустить сервисы
docker-compose up -d        # Запустить в фоновом режиме
docker-compose down         # Остановить и удалить контейнеры
docker-compose logs         # Показать логи
docker-compose ps           # Показать статус сервисов
```

## Настройка для разработки

### Увеличение ресурсов (рекомендуется)
1. Откройте Docker Desktop
2. Перейдите в Settings (шестеренка)
3. Выберите Resources → Advanced
4. Увеличьте:
   - Memory до 4-8 GB
   - CPU до 2-4 cores
   - Disk image size при необходимости

### Включение BuildKit (для быстрой сборки)
Добавьте в переменные среды или .env файл:
```
DOCKER_BUILDKIT=1
COMPOSE_DOCKER_CLI_BUILD=1
```

## Решение проблем

### Docker Desktop не запускается
1. Убедитесь, что виртуализация включена в BIOS
2. Проверьте, что WSL 2 установлен и настроен
3. Перезапустите службу Docker:
   - Откройте Services (services.msc)
   - Найдите "Docker Desktop Service"
   - Перезапустите службу

### Медленная работа
1. Увеличьте выделенную память в настройках Docker Desktop
2. Убедитесь, что проект находится в WSL 2 файловой системе (для Windows)
3. Исключите папку проекта из антивируса

### Ошибки с правами доступа
На Windows обычно не требуется дополнительных настроек, но если возникают проблемы:
1. Запустите Docker Desktop от имени администратора
2. Добавьте пользователя в группу "docker-users"

### Проблемы с сетью
Если контейнеры не могут подключиться к интернету:
1. Перезапустите Docker Desktop
2. Проверьте настройки брандмауэра
3. Попробуйте изменить DNS в настройках Docker Desktop на 8.8.8.8

## Полезные команды для нашего проекта

### Запуск инфраструктуры
```bash
# Запуск всех сервисов
docker-compose up -d

# Запуск только базы данных и Redis
docker-compose up -d postgres redis

# Просмотр логов
docker-compose logs -f postgres

# Остановка всех сервисов
docker-compose down

# Полная очистка (удаление volumes)
docker-compose down -v
```

### Подключение к базе данных
```bash
# Подключение к PostgreSQL
docker-compose exec postgres psql -U fm_user -d football_manager

# Подключение к Redis
docker-compose exec redis redis-cli
```

### Мониторинг ресурсов
```bash
# Использование ресурсов контейнерами
docker stats

# Информация о системе Docker
docker system df
docker system info
```