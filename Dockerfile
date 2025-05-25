# syntax = docker/dockerfile:1

FROM ruby:3.4.2-slim AS base

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    nodejs \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

FROM base AS deps

# Install gems
COPY Gemfile Gemfile.lock /app
RUN gem install bundler && \
    bundle install --jobs 4

FROM deps AS final
# Copy the application code
COPY . .

# Expose ports
EXPOSE 9292

# Set the entrypoint command
CMD ["rackup", "-o", "0.0.0.0"]
