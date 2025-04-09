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

# Copy package files first for better layer caching
COPY package.json package-lock.json* ./
# Copy lerna config if it exists
COPY lerna.json* ./
# Copy workspace package.json files (adjust pattern if needed)
COPY packages/*/*.json packages/

# Install ALL dependencies (including devDependencies needed for build)
# Ensure clean install in case of previous partial installs
RUN rm -rf node_modules && npm install --ignore-scripts

# Copy the rest of the application source code
COPY . .

# Remove Git and Husky-related files AFTER copying everything
RUN rm -rf .git .husky

# Build the application (compile TS to JS, etc.)
# This uses the 'build' script from the root package.json
RUN npm run build

# Optional: Prune devDependencies after build to reduce image size
# RUN npm prune --production

# Make start script executable
RUN chmod +x /app/start.sh

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["/app/start.sh"] 