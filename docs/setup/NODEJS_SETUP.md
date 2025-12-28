# Node.js Setup Guide

## Установка Node.js

### Рекомендуемый способ: Node Version Manager (NVM)

#### Windows - установка nvm-windows
1. **Скачайте nvm-windows** с GitHub:
   https://github.com/coreybutler/nvm-windows/releases

2. **Скачайте файл** `nvm-setup.exe` из последнего релиза

3. **Запустите установщик** от имени администратора

4. **Перезапустите командную строку** или PowerShell

#### Установка Node.js через NVM
```bash
# Просмотр доступных версий
nvm list available

# Установка последней LTS версии
nvm install lts

# Установка конкретной версии (рекомендуется 20+)
nvm install 20.10.0

# Использование установленной версии
nvm use 20.10.0

# Установка версии по умолчанию
nvm alias default 20.10.0
```

### Альтернативный способ: Прямая установка

1. **Перейдите на официальный сайт**: https://nodejs.org/
2. **Скачайте LTS версию** (рекомендуется 20.x.x или новее)
3. **Запустите установщик** и следуйте инструкциям
4. **Убедитесь, что выбрана опция** "Add to PATH"

## Проверка установки

```bash
node --version    # Должно показать v20.x.x или новее
npm --version     # Должно показать версию npm
```

## Настройка npm

### Обновление npm до последней версии
```bash
npm install -g npm@latest
```

### Настройка глобальной папки (опционально)
Для избежания проблем с правами доступа:

```bash
# Создание папки для глобальных пакетов
mkdir %APPDATA%\npm-global

# Настройка npm для использования новой папки
npm config set prefix %APPDATA%\npm-global

# Добавление в PATH (добавьте в переменные среды)
# %APPDATA%\npm-global
```

### Полезные глобальные пакеты
```bash
# TypeScript компилятор
npm install -g typescript

# TSX для запуска TypeScript файлов
npm install -g tsx

# Nodemon для автоперезапуска
npm install -g nodemon

# Yarn (альтернативный пакетный менеджер)
npm install -g yarn
```

## Управление версиями Node.js

### С помощью NVM
```bash
# Список установленных версий
nvm list

# Переключение между версиями
nvm use 18.17.0
nvm use 20.10.0

# Установка и использование последней версии
nvm install node
nvm use node
```

## Настройка для нашего проекта

### 1. Установка зависимостей API Gateway
```bash
cd services/api-gateway
npm install
```

### 2. Установка зависимостей Web App
```bash
cd apps/web
npm install
```

### 3. Запуск в режиме разработки
```bash
# API Gateway
cd services/api-gateway
npm run dev

# Web App
cd apps/web
npm run dev
```

## Package.json скрипты

### API Gateway (services/api-gateway/package.json)
```json
{
  "scripts": {
    "dev": "tsx watch src/index.ts",      // Разработка с автоперезапуском
    "build": "tsc",                       // Сборка TypeScript
    "start": "node dist/index.js",        // Запуск продакшн версии
    "test": "vitest",                     // Запуск тестов
    "lint": "eslint src --ext .ts",       // Проверка кода
    "format": "prettier --write src"      // Форматирование кода
  }
}
```

### Web App (apps/web/package.json)
```json
{
  "scripts": {
    "dev": "next dev",           // Разработка
    "build": "next build",       // Сборка для продакшн
    "start": "next start",       // Запуск продакшн версии
    "lint": "next lint",         // Проверка кода
    "type-check": "tsc --noEmit" // Проверка типов
  }
}
```

## Решение проблем

### Проблемы с правами доступа (Windows)
1. Запустите командную строку от имени администратора
2. Или настройте глобальную папку npm (см. выше)

### Медленная установка пакетов
```bash
# Использование другого registry
npm config set registry https://registry.npmmirror.com/

# Или вернуться к официальному
npm config set registry https://registry.npmjs.org/

# Очистка кэша
npm cache clean --force
```

### Конфликты версий
```bash
# Удаление node_modules и переустановка
rm -rf node_modules package-lock.json
npm install

# Или на Windows
rmdir /s node_modules
del package-lock.json
npm install
```

### Проблемы с TypeScript
```bash
# Установка TypeScript глобально
npm install -g typescript

# Проверка версии
tsc --version

# Инициализация tsconfig.json
tsc --init
```

## Рекомендуемые расширения VS Code

Для удобной разработки установите:
- **Node.js Extension Pack**
- **TypeScript Importer**
- **ESLint**
- **Prettier**
- **Auto Rename Tag**
- **Bracket Pair Colorizer**

## Переменные среды

### Создание .env файла
```bash
# Скопируйте пример
cp .env.example .env

# Отредактируйте под ваши настройки
```

### Загрузка переменных в Node.js
```javascript
import dotenv from 'dotenv';
dotenv.config();

const port = process.env.API_PORT || 3000;
```

## Полезные команды для разработки

```bash
# Проверка устаревших пакетов
npm outdated

# Обновление пакетов
npm update

# Аудит безопасности
npm audit
npm audit fix

# Информация о пакете
npm info package-name

# Список установленных пакетов
npm list
npm list -g --depth=0  # Глобальные пакеты
```