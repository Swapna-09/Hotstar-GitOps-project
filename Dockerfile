# Use Node.js Alpine base image
#FROM node:alpine

# Create and set the working directory inside the container
#WORKDIR /app

# Copy package.json and package-lock.json to the working directory
#COPY package.json package-lock.json /app/

# Install dependencies
#RUN npm install

# Copy the entire codebase to the working directory
#COPY . /app/

# Expose the port your app runs on (replace <PORT_NUMBER> with your app's actual port)
#EXPOSE 3000

# Define the command to start your application (replace "start" with the actual command to start your app)
#CMD ["npm", "start"]


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

# # Define the command to start your application
# CMD ["npm", "start"]

# Use lightweight Node.js Alpine image
FROM node:18-alpine

# Install build tools required for npm modules with native code
RUN apk add --no-cache python3 make g++ bash git

# Create a non-root user
RUN addgroup -S nodejs && adduser -S nodejs -G nodejs

# Set working directory
WORKDIR /app

# Copy package.json first for caching npm install
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Set ownership to non-root user
RUN chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
