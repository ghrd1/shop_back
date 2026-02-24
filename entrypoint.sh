#!/bin/bash
set -e

echo "Запуск entrypoint.sh..."

# Ждём PostgreSQL
echo "Ждём запуска PostgreSQL..."
until pg_isready -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER > /dev/null 2>&1; do
  echo "Postgres не доступен, пробуем снова..."
  sleep 1
done
echo "PostgreSQL доступен!"

# Создаём базу, если её нет, и применяем миграции
echo "Создаём базу и применяем миграции..."
bin/rails db:create db:migrate 2>/dev/null || true

# Заполняем мок-данными только если таблицы пусты
echo "Заполняем базу данными, если пустая..."
bin/rails db:seed

# Удаляем старый PID и стартуем сервер
echo "Стартуем сервер Rails..."
exec bash -c "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"