# Use a lightweight web server image
FROM nginx:latest

# Copy your app into the nginx web root
COPY index.html /usr/share/nginx/html/

# Expose port 80 for web access
EXPOSE 80

# Default command to run nginx
CMD ["nginx", "-g", "daemon off;"]
