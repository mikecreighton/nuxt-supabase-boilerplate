# Use a Node.js base image
FROM node:lts-alpine

# Set the working directory
WORKDIR /app

# Accept build arguments for environment variables
# CapRover can pass these via build arguments in the app configuration
ARG SUPABASE_URL
ARG SUPABASE_KEY

# Convert build arguments to environment variables
# This makes them available during both build and runtime
ENV SUPABASE_URL=$SUPABASE_URL
ENV SUPABASE_KEY=$SUPABASE_KEY
ENV NODE_ENV=production

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Nuxt.js application
# Environment variables are now available during build
RUN npm run build

# Expose the port your Nuxt.js app listens on (default is 3000)
EXPOSE 3000

# Start the Nuxt.js application
CMD ["node", ".output/server/index.mjs"]
