# Use a lightweight web server image
FROM nginx:latest

# Copy your app into the nginx web root
COPY index.html /usr/share/nginx/html/

# Expose port 80 for web access
EXPOSE 80

# Default command to run nginx
CMD ["nginx", "-g", "daemon off;"]
# Use Node.js base image
FROM node:24-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package files first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy app files
COPY . .

# Expose port
EXPOSE 8080

# Command to run the app
CMD ["node", "server.js"]
