# Go Setup Guide

## Установка Go

### Windows

#### Способ 1: Официальный установщик (рекомендуется)
1. **Перейдите на официальный сайт**: https://golang.org/dl/
2. **Скачайте установщик** для Windows (файл .msi)
3. **Запустите установщик** и следуйте инструкциям
4. **Перезапустите командную строку** после установки

#### Способ 2: Через Chocolatey (если установлен)
```powershell
choco install golang
```

#### Способ 3: Через Scoop (если установлен)
```powershell
scoop install go
```

### Проверка установки

```bash
go version
```

Должно показать версию Go 1.21 или новее.

## Настройка окружения

### Переменные среды

Go автоматически настраивает большинство переменных, но можно проверить:

```bash
# Просмотр всех настроек Go
go env

# Основные переменные
go env GOROOT    # Путь установки Go
go env GOPATH    # Рабочая область Go
go env GOMODCACHE # Кэш модулей
```

### Настройка GOPATH (опционально)
По умолчанию Go использует `~/go` (или `%USERPROFILE%\go` на Windows). Можно изменить:

```bash
# Windows
set GOPATH=C:\Users\YourName\go-workspace
setx GOPATH C:\Users\YourName\go-workspace

# Или через PowerShell
$env:GOPATH = "C:\Users\YourName\go-workspace"
[Environment]::SetEnvironmentVariable("GOPATH", "C:\Users\YourName\go-workspace", "User")
```

## Go Modules (рекомендуемый подход)

### Инициализация модуля
```bash
# В папке проекта
go mod init module-name

# Для нашего проекта
go mod init football-manager/match-engine
```

### Управление зависимостями
```bash
# Добавление зависимости
go get github.com/gin-gonic/gin

# Добавление конкретной версии
go get github.com/gin-gonic/gin@v1.9.1

# Обновление зависимостей
go get -u ./...

# Очистка неиспользуемых зависимостей
go mod tidy

# Просмотр зависимостей
go list -m all
```

## Основные команды Go

### Компиляция и запуск
```bash
# Запуск без компиляции
go run main.go

# Компиляция в исполняемый файл
go build

# Компиляция с указанием имени файла
go build -o myapp.exe

# Установка в GOPATH/bin
go install
```

### Тестирование
```bash
# Запуск тестов
go test

# Запуск тестов с подробным выводом
go test -v

# Запуск тестов во всех подпапках
go test ./...

# Тесты с покрытием кода
go test -cover
go test -coverprofile=coverage.out
go tool cover -html=coverage.out
```

### Форматирование и проверка кода
```bash
# Форматирование кода
go fmt ./...

# Проверка кода на ошибки
go vet ./...

# Статический анализ (требует установки)
golangci-lint run
```

## Настройка для нашего проекта

### Структура Go сервиса
```
services/match-engine/
├── main.go              # Точка входа
├── go.mod              # Описание модуля
├── go.sum              # Хеши зависимостей
├── internal/           # Внутренние пакеты
│   ├── engine/         # Логика движка матчей
│   ├── models/         # Структуры данных
│   └── handlers/       # HTTP обработчики
├── pkg/                # Публичные пакеты
└── cmd/                # Исполняемые файлы
```

### Инициализация Match Engine
```bash
cd services/match-engine

# Инициализация модуля (если не сделано)
go mod init football-manager/match-engine

# Установка зависимостей
go get github.com/gin-gonic/gin
go get github.com/lib/pq  # PostgreSQL драйвер
go get github.com/go-redis/redis/v8  # Redis клиент

# Обновление go.mod
go mod tidy
```

### Запуск Match Engine
```bash
cd services/match-engine
go run main.go
```

## Полезные инструменты

### Установка дополнительных инструментов
```bash
# Линтер (статический анализ кода)
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Автоматическое обновление импортов
go install golang.org/x/tools/cmd/goimports@latest

# Генератор моков для тестирования
go install github.com/golang/mock/mockgen@latest

# Инструмент для работы с базами данных
go install github.com/pressly/goose/v3/cmd/goose@latest

# Профилировщик
go install github.com/google/pprof@latest
```

### Настройка golangci-lint
Создайте файл `.golangci.yml` в корне Go проекта:

```yaml
linters-settings:
  govet:
    check-shadowing: true
  golint:
    min-confidence: 0
  gocyclo:
    min-complexity: 15
  maligned:
    suggest-new: true
  dupl:
    threshold: 100
  goconst:
    min-len: 2
    min-occurrences: 2

linters:
  disable-all: true
  enable:
    - bodyclose
    - deadcode
    - depguard
    - dogsled
    - dupl
    - errcheck
    - exportloopref
    - exhaustive
    - goconst
    - gocritic
    - gofmt
    - goimports
    - gomnd
    - goprintffuncname
    - gosec
    - gosimple
    - govet
    - ineffassign
    - misspell
    - nolintlint
    - rowserrcheck
    - staticcheck
    - structcheck
    - stylecheck
    - typecheck
    - unconvert
    - unparam
    - unused
    - varcheck
    - whitespace

run:
  timeout: 5m
```

## Настройка IDE

### VS Code
Установите расширение **Go** от Google:
1. Откройте VS Code
2. Перейдите в Extensions (Ctrl+Shift+X)
3. Найдите и установите "Go" от Google
4. Перезапустите VS Code
5. Откройте Go файл - расширение предложит установить дополнительные инструменты

### GoLand (JetBrains)
Профессиональная IDE для Go с полной поддержкой из коробки.

## Работа с базами данных

### PostgreSQL драйвер
```bash
go get github.com/lib/pq
```

Пример подключения:
```go
import (
    "database/sql"
    _ "github.com/lib/pq"
)

db, err := sql.Open("postgres", "postgresql://user:password@localhost/dbname?sslmode=disable")
```

### Более продвинутый драйвер pgx
```bash
go get github.com/jackc/pgx/v5
```

## Решение проблем

### Проблемы с прокси модулей
```bash
# Отключение прокси (если проблемы с доступом)
go env -w GOPROXY=direct
go env -w GOSUMDB=off

# Или использование другого прокси
go env -w GOPROXY=https://goproxy.cn,direct
```

### Проблемы с сертификатами
```bash
# Отключение проверки сертификатов (только для разработки!)
go env -w GOINSECURE=example.com
```

### Очистка кэша модулей
```bash
go clean -modcache
```

### Проблемы с PATH
Убедитесь, что `GOROOT/bin` и `GOPATH/bin` добавлены в PATH:
- `C:\Go\bin` (или где установлен Go)
- `%USERPROFILE%\go\bin` (для установленных инструментов)

## Полезные команды для разработки

```bash
# Информация о модуле
go list -m

# Зависимости модуля
go mod graph

# Проверка на уязвимости
go list -json -deps ./... | nancy sleuth

# Бенчмарки
go test -bench=.

# Профилирование
go test -cpuprofile=cpu.prof -memprofile=mem.prof -bench=.
go tool pprof cpu.prof

# Сборка для разных платформ
GOOS=linux GOARCH=amd64 go build
GOOS=windows GOARCH=amd64 go build
```

## Пример Makefile для Go проекта

```makefile
.PHONY: build run test clean lint

# Переменные
BINARY_NAME=match-engine
MAIN_PATH=./cmd/main.go

# Сборка
build:
	go build -o bin/$(BINARY_NAME) $(MAIN_PATH)

# Запуск
run:
	go run $(MAIN_PATH)

# Тесты
test:
	go test -v ./...

# Тесты с покрытием
test-coverage:
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out

# Линтинг
lint:
	golangci-lint run

# Форматирование
fmt:
	go fmt ./...
	goimports -w .

# Очистка
clean:
	go clean
	rm -f bin/$(BINARY_NAME)
	rm -f coverage.out

# Установка зависимостей
deps:
	go mod download
	go mod tidy

# Обновление зависимостей
update-deps:
	go get -u ./...
	go mod tidy
```