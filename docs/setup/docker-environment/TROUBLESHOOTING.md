# Docker Environment Troubleshooting

Руководство по решению проблем с Docker окружением Football Manager проекта.

## Общие проблемы и решения

### 1. Docker Desktop не запускается

#### Симптомы:
- Docker Desktop показывает ошибку при запуске
- Команды `docker` не работают
- WSL 2 ошибки

#### Решения:

**Проверка WSL 2:**
```powershell
# Проверить версию WSL
wsl --list --verbose

# Обновить WSL до версии 2
wsl --set-default-version 2
wsl --set-version Ubuntu 2
```

**Включение виртуализации в BIOS:**
1. Перезагрузите компьютер
2. Войдите в BIOS (обычно F2, F12, Delete)
3. Найдите настройки виртуализации:
   - Intel: Intel VT-x или Intel Virtualization Technology
   - AMD: AMD-V или SVM Mode
4. Включите виртуализацию
5. Сохраните и перезагрузитесь

**Перезапуск служб Docker:**
```powershell
# Остановить Docker Desktop
Stop-Service -Name "Docker Desktop Service" -Force

# Запустить Docker Desktop
Start-Service -Name "Docker Desktop Service"
```

### 2. Контейнеры не запускаются

#### Симптомы:
- `docker-compose up` завершается с ошибкой
- Контейнеры в статусе "Exited"
- Ошибки в логах

#### Диагностика:

```bash
# Проверить статус контейнеров
docker ps -a

# Посмотреть логи
docker-compose logs postgres
docker-compose logs redis
docker-compose logs nats

# Проверить использование портов
netstat -an | findstr :5432
netstat -an | findstr :6379
netstat -an | findstr :4222
```

#### Решения:

**Порты заняты:**
```bash
# Найти процесс, использующий порт
netstat -ano | findstr :5432

# Завершить процесс (замените PID)
taskkill /PID 1234 /F

# Или изменить порты в docker-compose.yml
ports:
  - "5433:5432"  # Используем другой порт
```

**Проблемы с томами:**
```bash
# Удалить все тома (ОСТОРОЖНО - потеряете данные!)
docker-compose down -v

# Удалить конкретный том
docker volume rm football-manager_postgres_data

# Пересоздать сервисы
docker-compose up -d
```

**Очистка Docker системы:**
```bash
# Удалить неиспользуемые контейнеры, сети, образы
docker system prune -f

# Удалить все (включая тома)
docker system prune -a --volumes
```

### 3. PostgreSQL проблемы

#### Симптомы:
- Не удается подключиться к базе данных
- Ошибки аутентификации
- База данных не создается

#### Диагностика:

```bash
# Проверить статус PostgreSQL
docker exec fm_postgres pg_isready -U fm_user -d football_manager

# Проверить логи PostgreSQL
docker-compose logs postgres

# Подключиться к контейнеру
docker exec -it fm_postgres bash

# Проверить процессы PostgreSQL
docker exec fm_postgres ps aux | grep postgres
```

#### Решения:

**Проблемы с паролем:**
```bash
# Сбросить пароль PostgreSQL
docker exec -it fm_postgres psql -U postgres -c "ALTER USER fm_user PASSWORD 'new_password';"

# Или пересоздать контейнер с новыми переменными
docker-compose down
docker volume rm football-manager_postgres_data
# Измените пароль в .env файле
docker-compose up -d postgres
```

**База данных не создается:**
```bash
# Создать базу данных вручную
docker exec -it fm_postgres createdb -U fm_user football_manager

# Или через SQL
docker exec -it fm_postgres psql -U postgres -c "CREATE DATABASE football_manager OWNER fm_user;"
```

**Проблемы с правами доступа:**
```bash
# Проверить права пользователя
docker exec -it fm_postgres psql -U postgres -c "\du"

# Дать права пользователю
docker exec -it fm_postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE football_manager TO fm_user;"
```

### 4. Redis проблемы

#### Симптомы:
- Redis не отвечает на ping
- Ошибки подключения
- Данные не сохраняются

#### Диагностика:

```bash
# Проверить Redis
docker exec fm_redis redis-cli ping

# Проверить конфигурацию
docker exec fm_redis redis-cli CONFIG GET "*"

# Проверить логи
docker-compose logs redis

# Проверить память
docker exec fm_redis redis-cli INFO memory
```

#### Решения:

**Redis не отвечает:**
```bash
# Перезапустить Redis
docker-compose restart redis

# Проверить, не заполнена ли память
docker exec fm_redis redis-cli INFO memory

# Очистить Redis (потеряете данные!)
docker exec fm_redis redis-cli FLUSHALL
```

**Проблемы с персистентностью:**
```bash
# Включить сохранение данных на диск
docker exec fm_redis redis-cli CONFIG SET save "900 1 300 10 60 10000"

# Принудительно сохранить
docker exec fm_redis redis-cli BGSAVE
```

### 5. NATS проблемы

#### Симптомы:
- NATS сервер недоступен
- Клиенты не могут подключиться
- Сообщения не доставляются

#### Диагностика:

```bash
# Проверить NATS мониторинг
curl http://localhost:8222/varz
# или
Invoke-WebRequest -Uri http://localhost:8222/varz

# Проверить подключения
curl http://localhost:8222/connz

# Проверить логи
docker-compose logs nats
```

#### Решения:

**NATS не запускается:**
```bash
# Проверить конфигурацию
docker-compose config

# Перезапустить с правильными параметрами
docker-compose down
docker-compose up -d nats

# Проверить порты
netstat -an | findstr :4222
netstat -an | findstr :8222
```

### 6. Проблемы с производительностью

#### Симптомы:
- Медленная работа контейнеров
- Высокое использование CPU/памяти
- Долгий запуск сервисов

#### Диагностика:

```bash
# Мониторинг ресурсов
docker stats

# Проверить использование дискового пространства
docker system df

# Проверить логи на ошибки
docker-compose logs | findstr ERROR
docker-compose logs | findstr WARN
```

#### Решения:

**Увеличение ресурсов Docker Desktop:**
1. Откройте Docker Desktop
2. Settings → Resources → Advanced
3. Увеличьте:
   - Memory: до 4-8 GB
   - CPU: до 2-4 cores
   - Disk image size: при необходимости

**Оптимизация PostgreSQL:**
```sql
-- Подключиться к PostgreSQL
docker exec -it fm_postgres psql -U fm_user -d football_manager

-- Проверить настройки
SHOW shared_buffers;
SHOW work_mem;
SHOW maintenance_work_mem;

-- Оптимизировать для разработки
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET work_mem = '4MB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';

-- Перезапустить PostgreSQL
SELECT pg_reload_conf();
```

**Очистка неиспользуемых данных:**
```bash
# Удалить неиспользуемые образы
docker image prune -f

# Удалить неиспользуемые тома
docker volume prune -f

# Удалить неиспользуемые сети
docker network prune -f
```

### 7. Проблемы с сетью

#### Симптомы:
- Контейнеры не могут общаться между собой
- Нет доступа к интернету из контейнеров
- DNS не работает

#### Диагностика:

```bash
# Проверить сети Docker
docker network ls

# Проверить конфигурацию сети
docker network inspect football-manager_fm_network

# Проверить подключение между контейнерами
docker exec fm_postgres ping fm_redis
docker exec fm_redis ping fm_nats
```

#### Решения:

**Пересоздание сети:**
```bash
# Остановить все сервисы
docker-compose down

# Удалить сеть
docker network rm football-manager_fm_network

# Запустить заново
docker-compose up -d
```

**Проблемы с DNS:**
```bash
# Проверить DNS в контейнере
docker exec fm_postgres nslookup fm_redis
docker exec fm_postgres cat /etc/resolv.conf

# Перезапустить Docker Desktop если проблемы с DNS
```

### 8. Проблемы с данными

#### Симптомы:
- Данные не сохраняются между перезапусками
- Ошибки при записи в базу данных
- Тома не монтируются

#### Диагностика:

```bash
# Проверить тома
docker volume ls
docker volume inspect football-manager_postgres_data

# Проверить монтирование
docker exec fm_postgres df -h
docker exec fm_postgres ls -la /var/lib/postgresql/data
```

#### Решения:

**Пересоздание томов:**
```bash
# ОСТОРОЖНО: Это удалит все данные!
docker-compose down -v
docker volume prune -f
docker-compose up -d
```

**Проблемы с правами доступа:**
```bash
# Проверить владельца файлов
docker exec fm_postgres ls -la /var/lib/postgresql/data

# Исправить права (если нужно)
docker exec fm_postgres chown -R postgres:postgres /var/lib/postgresql/data
```

## Полезные команды для диагностики

### Общая информация

```bash
# Версия Docker
docker version

# Информация о системе Docker
docker system info

# Использование дискового пространства
docker system df

# События Docker в реальном времени
docker system events
```

### Мониторинг

```bash
# Статистика контейнеров в реальном времени
docker stats

# Процессы в контейнере
docker exec fm_postgres ps aux

# Использование памяти
docker exec fm_postgres free -h

# Использование диска
docker exec fm_postgres df -h
```

### Логи и отладка

```bash
# Логи всех сервисов
docker-compose logs

# Логи конкретного сервиса с временными метками
docker-compose logs -t postgres

# Последние N строк логов
docker-compose logs --tail=50 postgres

# Логи в реальном времени
docker-compose logs -f
```

## Когда обращаться за помощью

Если проблема не решается:

1. **Соберите информацию:**
   ```bash
   docker version > debug_info.txt
   docker system info >> debug_info.txt
   docker-compose logs >> debug_info.txt
   ```

2. **Проверьте документацию:**
   - [Docker Documentation](https://docs.docker.com/)
   - [PostgreSQL Docker Hub](https://hub.docker.com/_/postgres)
   - [Redis Docker Hub](https://hub.docker.com/_/redis)
   - [NATS Docker Hub](https://hub.docker.com/_/nats)

3. **Поищите в сообществе:**
   - Stack Overflow
   - Docker Community Forums
   - GitHub Issues соответствующих проектов

4. **Создайте минимальный воспроизводимый пример** для получения помощи