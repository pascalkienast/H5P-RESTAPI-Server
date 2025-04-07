FROM cloudron/base:5.0.0

# Set up primary application working directory
WORKDIR /app

# Create the data directory for Cloudron's volume mount
# Ensure it exists before chown
RUN mkdir -p /app/data

# Set environment variables
ENV HUSKY=0
ENV HUSKY_SKIP_INSTALL=1
ENV HUSKY_SKIP_HOOKS=1
ENV INIT_CWD=/app

# cloudron user/group are expected to be present in the base image
# RUN addgroup --system cloudron && adduser --system --ingroup cloudron --no-create-home cloudron

# Set ownership for the data directory mount point
# Cloudron requires this directory to be owned by the cloudron user
RUN chown -R cloudron:cloudron /app/data

# Copy the entire application into /app
COPY . .

# Remove Git and Husky-related files to prevent hooks from running
RUN rm -rf .git .husky

# Remove husky prepare script from package.json
RUN if grep -q "\"prepare\":" package.json; then \
    sed -i 's/"prepare": "husky install",/"prepare": "",/g' package.json || true; \
    fi

# Make start script executable (now located at /app/start.sh)
RUN chmod +x /app/start.sh

# Install dependencies - after all files are copied
# Skip husky and git hooks
RUN npm install --ignore-scripts && \
    npm run download:content-type-cache || true && \
    npm run download:h5p || true

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application (now located at /app/start.sh)
CMD ["/app/start.sh"] 