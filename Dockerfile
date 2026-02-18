# #Use Node.js Alpine base image
# FROM node:alpine

# #Create and set the working directory inside the container
# WORKDIR /app

# #Copy package.json and package-lock.json to the working directory
# COPY package.json package-lock.json /app/

# #Install dependencies
# RUN npm install

# #Copy the entire codebase to the working directory
# COPY . /app/

# #Expose the port your app runs on (replace <PORT_NUMBER> with your app's actual port)
# EXPOSE 3000

# #Define the command to start your application (replace "start" with the actual command to start your app)
# CMD ["npm", "start"]


# # Use Node.js Alpine base image
# FROM node:alpine

# # Create a non-root user and group
# RUN addgroup -S nodejs && adduser -S nodejs -G nodejs

# # Create and set the working directory inside the container
# WORKDIR /app

# # Copy package.json and package-lock.json to the working directory
# COPY package.json package-lock.json /app/

# # Install dependencies
# RUN npm install

# # Copy the entire codebase to the working directory
# COPY . /app/

# # Give ownership of the working directory to the non-root user
# RUN chown -R nodejs:nodejs /app

# # Switch to the non-root user
# USER nodejs

# # Expose the port your app runs on
# EXPOSE 3000

FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first to leverage Docker cache
COPY package*.json ./

# Install ALL dependencies
# Note: We run this as root (default) so it has permission to write to /app
RUN npm install

# Copy the rest of the source code
COPY . .

# --- Stage 2: Production Stage ---
FROM node:20-alpine AS runner

WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# 1. Create the user and group first
RUN addgroup -S nodejs && adduser -S nodeapp -G nodejs

# 2. Copy only what is needed from the builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/ .

# 3. Change ownership of the /app directory to our new user
RUN chown -R nodeapp:nodejs /app

# 4. Switch to the non-root user
USER nodeapp

EXPOSE 3000

CMD ["npm", "start"]
