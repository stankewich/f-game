# Git Setup Guide

## Установка Git

### Windows
1. Скачайте Git с официального сайта: https://git-scm.com/download/win
2. Запустите установщик и следуйте инструкциям
3. Рекомендуемые настройки:
   - Use Git from the command line and also from 3rd-party software
   - Use the OpenSSL library
   - Checkout Windows-style, commit Unix-style line endings
   - Use Windows' default console window

### Проверка установки
```bash
git --version
```

## Настройка Git

### Настройка пользователя (локально для проекта)
```bash
git config user.name "ваше_имя"
git config user.email "ваш_email@example.com"
```

### Настройка пользователя (глобально)
```bash
git config --global user.name "ваше_имя"
git config --global user.email "ваш_email@example.com"
```

## Инициализация репозитория

### 1. Инициализация локального репозитория
```bash
git init
```

### 2. Создание .gitignore
Создайте файл `.gitignore` в корне проекта с содержимым для исключения ненужных файлов.

### 3. Добавление файлов и первый коммит
```bash
git add .
git commit -m "Initial project setup"
```

### 4. Переименование ветки в main
```bash
git branch -M main
```

## Подключение к удаленному репозиторию

### Создание репозитория на GitHub
1. Перейдите на https://github.com
2. Нажмите "New repository"
3. Введите название репозитория
4. Выберите Public или Private
5. **НЕ добавляйте** README, .gitignore или лицензию (если у вас уже есть локальные файлы)
6. Нажмите "Create repository"

### Подключение удаленного репозитория

#### Вариант 1: HTTPS (рекомендуется для начинающих)
```bash
git remote add origin https://github.com/username/repository-name.git
git push -u origin main
```

#### Вариант 2: SSH (требует настройки SSH ключей)
```bash
git remote add origin git@github.com:username/repository-name.git
git push -u origin main
```

### Проверка подключения
```bash
git remote -v
```

## Основные команды Git

### Проверка статуса
```bash
git status
```

### Добавление изменений
```bash
git add .                # Добавить все файлы
git add filename.txt     # Добавить конкретный файл
```

### Коммит изменений
```bash
git commit -m "Описание изменений"
```

### Отправка изменений в удаленный репозиторий
```bash
git push
```

### Получение изменений из удаленного репозитория
```bash
git pull
```

### Просмотр истории коммитов
```bash
git log --oneline
```

## Решение проблем

### Проблема с SSH ключами
Если получаете ошибку "Permission denied (publickey)", используйте HTTPS:
```bash
git remote set-url origin https://github.com/username/repository-name.git
```

### Проблема с аутентификацией HTTPS
При первом push через HTTPS Git может открыть браузер для аутентификации через GitHub.

### Изменение URL удаленного репозитория
```bash
git remote set-url origin новый_url
```

## Пример полной настройки для нашего проекта

```bash
# 1. Инициализация
git init

# 2. Настройка пользователя
git config user.name "stankewich"
git config user.email "dinoevich@yandex.ru"

# 3. Добавление файлов
git add .
git commit -m "Initial project setup: documentation, infrastructure, and basic service structure"

# 4. Переименование ветки
git branch -M main

# 5. Подключение удаленного репозитория
git remote add origin https://github.com/stankewich/f-game.git

# 6. Отправка кода
git push -u origin main
```