FROM node:lts-alpine

# Set up working directory
WORKDIR /app

# Set environment variables to skip Husky installation
ENV HUSKY=0
ENV HUSKY_SKIP_INSTALL=1
ENV HUSKY_SKIP_HOOKS=1
ENV INIT_CWD=/app

# Copy the entire application first
COPY . .

# Remove Git and Husky-related files to prevent hooks from running
RUN rm -rf .git .husky

# Remove husky prepare script from package.json
RUN if grep -q "\"prepare\":" package.json; then \
    sed -i 's/"prepare": "husky install",/"prepare": "",/g' package.json || true; \
    fi

# Make the data directory - Cloudron will mount volume here
RUN mkdir -p /app/data

# Make start script executable
RUN chmod +x /app/start.sh

# Install dependencies - after all files are copied
# Skip husky and git hooks
RUN npm install --ignore-scripts && \
    npm run download:content-type-cache || true && \
    npm run download:h5p || true

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["/app/start.sh"] 