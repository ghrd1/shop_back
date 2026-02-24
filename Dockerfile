# syntax = docker/dockerfile:1
ARG RUBY_VERSION=3.2.10
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

# Переключаем на production для сервера
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# --- BUILD STAGE ---
FROM base as build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libvips \
    pkg-config \
    libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile

COPY . .

RUN bundle exec bootsnap precompile app/ lib/

# --- FINAL STAGE ---
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Даем права на выполнение скриптов (ВАЖНО для Linux/Render)
RUN chmod +x /rails/bin/docker-entrypoint /rails/entrypoint.sh

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Указываем порт 10000, который ждет Render
EXPOSE 10000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "10000"]