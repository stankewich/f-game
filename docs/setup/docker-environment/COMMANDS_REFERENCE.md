# Docker Commands Reference

Справочник команд Docker для работы с Football Manager проектом.

## Основные команды Docker Compose

### Управление сервисами

```bash
# Запуск всех сервисов в фоновом режиме
docker-compose up -d

# Запуск конкретных сервисов
docker-compose up -d postgres redis nats

# Запуск с пересборкой образов
docker-compose up -d --build

# Остановка всех сервисов
docker-compose down

# Остановка с удалением томов (ОСТОРОЖНО!)
docker-compose down -v

# Остановка с удалением образов
docker-compose down --rmi all

# Перезапуск всех сервисов
docker-compose restart

# Перезапуск конкретного сервиса
docker-compose restart postgres

# Пауза/возобновление сервисов
docker-compose pause
docker-compose unpause
```

### Просмотр информации

```bash
# Статус сервисов
docker-compose ps

# Подробная информация о сервисах
docker-compose ps -a

# Конфигурация (проверка синтаксиса)
docker-compose config

# Конфигурация с разрешенными переменными
docker-compose config --resolve-env-vars

# Список образов
docker-compose images

# Топ процессов в контейнерах
docker-compose top
```

### Логи

```bash
# Все логи
docker-compose logs

# Логи конкретного сервиса
docker-compose logs postgres
docker-compose logs redis
docker-compose logs nats

# Логи в реальном времени
docker-compose logs -f

# Логи с временными метками
docker-compose logs -t

# Последние N строк
docker-compose logs --tail=50

# Логи за определенное время
docker-compose logs --since="2023-12-28T10:00:00"
docker-compose logs --until="2023-12-28T11:00:00"
```

## Команды Docker

### Управление контейнерами

```bash
# Список запущенных контейнеров
docker ps

# Список всех контейнеров
docker ps -a

# Подробная информация о контейнере
docker inspect fm_postgres

# Статистика использования ресурсов
docker stats

# Статистика конкретного контейнера
docker stats fm_postgres

# Остановка контейнера
docker stop fm_postgres

# Запуск остановленного контейнера
docker start fm_postgres

# Перезапуск контейнера
docker restart fm_postgres

# Удаление контейнера
docker rm fm_postgres

# Принудительное удаление запущенного контейнера
docker rm -f fm_postgres
```

### Выполнение команд в контейнерах

```bash
# Интерактивная оболочка
docker exec -it fm_postgres bash
docker exec -it fm_redis sh
docker exec -it fm_nats sh

# Выполнение одной команды
docker exec fm_postgres ls -la /var/lib/postgresql/data
docker exec fm_redis redis-cli ping
docker exec fm_nats nats-server --version

# Выполнение команды от имени пользователя
docker exec -u postgres fm_postgres whoami

# Выполнение команды с переменными среды
docker exec -e PGPASSWORD=fm_password fm_postgres psql -U fm_user -d football_manager
```

## Команды для работы с базой данных

### PostgreSQL

```bash
# Проверка готовности PostgreSQL
docker exec fm_postgres pg_isready -U fm_user -d football_manager

# Подключение к базе данных
docker exec -it fm_postgres psql -U fm_user -d football_manager

# Выполнение SQL команды
docker exec fm_postgres psql -U fm_user -d football_manager -c "SELECT version();"

# Список баз данных
docker exec fm_postgres psql -U fm_user -l

# Создание базы данных
docker exec fm_postgres createdb -U fm_user new_database

# Удаление базы данных
docker exec fm_postgres dropdb -U fm_user old_database

# Создание дампа базы данных
docker exec fm_postgres pg_dump -U fm_user football_manager > backup.sql

# Восстановление из дампа
docker exec -i fm_postgres psql -U fm_user -d football_manager < backup.sql

# Создание дампа в контейнере
docker exec fm_postgres pg_dump -U fm_user -f /tmp/backup.sql football_manager

# Копирование файла из контейнера
docker cp fm_postgres:/tmp/backup.sql ./backup.sql

# Копирование файла в контейнер
docker cp ./backup.sql fm_postgres:/tmp/backup.sql
```

### Полезные SQL команды в PostgreSQL

```sql
-- Подключиться к базе данных
\c football_manager

-- Список таблиц
\dt

-- Описание таблицы
\d table_name

-- Список пользователей
\du

-- Размер базы данных
SELECT pg_size_pretty(pg_database_size('football_manager'));

-- Активные подключения
SELECT * FROM pg_stat_activity;

-- Завершить все подключения к базе
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'football_manager' AND pid <> pg_backend_pid();
```

### Redis

```bash
# Проверка работы Redis
docker exec fm_redis redis-cli ping

# Подключение к Redis CLI
docker exec -it fm_redis redis-cli

# Выполнение команды Redis
docker exec fm_redis redis-cli SET test_key "test_value"
docker exec fm_redis redis-cli GET test_key

# Информация о Redis
docker exec fm_redis redis-cli INFO

# Статистика памяти
docker exec fm_redis redis-cli INFO memory

# Список всех ключей (осторожно в продакшене!)
docker exec fm_redis redis-cli KEYS "*"

# Очистка всех данных
docker exec fm_redis redis-cli FLUSHALL

# Мониторинг команд в реальном времени
docker exec fm_redis redis-cli MONITOR
```

### Полезные команды Redis

```bash
# В Redis CLI:
redis-cli

# Основные команды:
SET key value          # Установить значение
GET key               # Получить значение
DEL key               # Удалить ключ
EXISTS key            # Проверить существование ключа
EXPIRE key seconds    # Установить время жизни ключа
TTL key              # Время до истечения ключа
KEYS pattern         # Найти ключи по шаблону
TYPE key             # Тип данных ключа
INFO                 # Информация о сервере
FLUSHDB              # Очистить текущую БД
FLUSHALL             # Очистить все БД
```

### NATS

```bash
# Проверка NATS через HTTP API
curl http://localhost:8222/varz
# или в PowerShell:
Invoke-WebRequest -Uri http://localhost:8222/varz

# Информация о подключениях
curl http://localhost:8222/connz

# Информация о подписках
curl http://localhost:8222/subsz

# Статистика маршрутизации
curl http://localhost:8222/routez

# Логи NATS
docker exec fm_nats cat /tmp/nats-server.log
```

## Управление томами

```bash
# Список томов
docker volume ls

# Подробная информация о томе
docker volume inspect football-manager_postgres_data

# Создание тома
docker volume create my_volume

# Удаление тома
docker volume rm football-manager_postgres_data

# Удаление неиспользуемых томов
docker volume prune

# Резервное копирование тома
docker run --rm -v football-manager_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres_backup.tar.gz -C /data .

# Восстановление тома
docker run --rm -v football-manager_postgres_data:/data -v $(pwd):/backup alpine tar xzf /backup/postgres_backup.tar.gz -C /data
```

## Управление сетями

```bash
# Список сетей
docker network ls

# Подробная информация о сети
docker network inspect football-manager_fm_network

# Создание сети
docker network create my_network

# Подключение контейнера к сети
docker network connect my_network fm_postgres

# Отключение контейнера от сети
docker network disconnect my_network fm_postgres

# Удаление сети
docker network rm my_network

# Удаление неиспользуемых сетей
docker network prune
```

## Управление образами

```bash
# Список образов
docker images

# Подробная информация об образе
docker inspect postgres:15

# Скачивание образа
docker pull postgres:15

# Удаление образа
docker rmi postgres:15

# Удаление неиспользуемых образов
docker image prune

# Удаление всех неиспользуемых образов
docker image prune -a

# История образа
docker history postgres:15

# Поиск образов в Docker Hub
docker search postgres
```

## Мониторинг и отладка

```bash
# Статистика использования ресурсов
docker stats

# События Docker в реальном времени
docker system events

# Информация о системе Docker
docker system info

# Использование дискового пространства
docker system df

# Подробная информация об использовании места
docker system df -v

# Очистка системы
docker system prune

# Агрессивная очистка (удаляет все неиспользуемое)
docker system prune -a --volumes

# Процессы в контейнере
docker exec fm_postgres ps aux

# Использование памяти в контейнере
docker exec fm_postgres free -h

# Использование диска в контейнере
docker exec fm_postgres df -h

# Сетевые подключения в контейнере
docker exec fm_postgres netstat -tulpn
```

## Копирование файлов

```bash
# Из контейнера на хост
docker cp fm_postgres:/var/lib/postgresql/data/postgresql.conf ./

# С хоста в контейнер
docker cp ./config.conf fm_postgres:/tmp/

# Копирование папки
docker cp fm_postgres:/var/lib/postgresql/data ./postgres_data

# Копирование с сохранением прав
docker cp -a fm_postgres:/var/lib/postgresql/data ./postgres_data
```

## Полезные алиасы для PowerShell

Добавьте в ваш PowerShell профиль (`$PROFILE`):

```powershell
# Docker Compose алиасы
function dcu { docker-compose up -d $args }
function dcd { docker-compose down $args }
function dcl { docker-compose logs $args }
function dcr { docker-compose restart $args }
function dcp { docker-compose ps $args }

# Docker алиасы
function dps { docker ps $args }
function dex { docker exec -it $args }
function dlogs { docker logs $args }
function dstats { docker stats $args }

# Специфичные для проекта
function fm-up { docker-compose up -d postgres redis nats }
function fm-down { docker-compose down }
function fm-logs { docker-compose logs -f }
function fm-db { docker exec -it fm_postgres psql -U fm_user -d football_manager }
function fm-redis { docker exec -it fm_redis redis-cli }
```

## Быстрые команды для разработки

```bash
# Полный перезапуск окружения
docker-compose down && docker-compose up -d

# Перезапуск с очисткой данных (ОСТОРОЖНО!)
docker-compose down -v && docker-compose up -d

# Просмотр логов всех сервисов
docker-compose logs -f

# Быстрая проверка состояния
docker-compose ps && docker exec fm_postgres pg_isready -U fm_user -d football_manager && docker exec fm_redis redis-cli ping

# Подключение к базе данных
docker exec -it fm_postgres psql -U fm_user -d football_manager

# Мониторинг ресурсов
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
```

Этот справочник поможет вам эффективно работать с Docker окружением проекта Football Manager.