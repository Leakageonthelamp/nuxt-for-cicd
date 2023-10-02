# Build stage
FROM node:18.14-alpine3.16 AS builder

# Set the working directory
WORKDIR /app

# Install necessary tools
RUN apk add --no-cache git

# Cache npm modules
COPY package*.json yarn.lock ./
RUN yarn --frozen-lockfile

# Copy the source code and build the project
COPY . .
RUN yarn build

# Final stage
FROM node:18.14-alpine3.16

# Set the working directory
WORKDIR /app

# Copy the build output and node_modules from the build stage
COPY --from=builder /app/.output /app/.output

# Run the application
CMD ["node", ".output/server/index.mjs"]
