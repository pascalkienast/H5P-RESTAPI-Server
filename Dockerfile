FROM node:lts-alpine

# Set up working directory
WORKDIR /app

# Copy package files for better caching
COPY package*.json ./
COPY lerna.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Make the data directory - Cloudron will mount volume here
RUN mkdir -p /app/data

# Make start script executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["/app/start.sh"] 