FROM cloudron/base:5.0.0

# Set up primary application working directory
WORKDIR /app

# Create the data directory for Cloudron's volume mount
# Ensure it exists before chown
RUN mkdir -p /app/data && chown -R cloudron:cloudron /app/data

# Set environment variables
ENV HUSKY=0
ENV HUSKY_SKIP_INSTALL=1
ENV HUSKY_SKIP_HOOKS=1
ENV INIT_CWD=/app
# Prevent potential issues with incompatible husky installs in docker
ENV HUSKY_SKIP_HOOKS=1
# Ensure Node/NPM can find binaries installed via npx during build
ENV PATH=/app/node_modules/.bin:$PATH

# cloudron user/group are expected to be present in the base image
# RUN addgroup --system cloudron && adduser --system --ingroup cloudron --no-create-home cloudron

# Set ownership for the data directory mount point
# Cloudron requires this directory to be owned by the cloudron user
RUN chown -R cloudron:cloudron /app/data

# Copy ALL package manifests and Lerna config first to leverage Docker cache
COPY package.json package-lock.json* lerna.json* ./

# Copy the packages directory structure and their package.json files
# This helps npm/lerna understand the workspace structure
COPY packages/ packages/

# Install ALL dependencies using npm ci, but skip potentially problematic postinstall scripts
RUN npm ci --ignore-scripts

# Explicitly run lerna bootstrap to ensure cross-package linking
# The --ci flag respects package-lock and doesn't modify it
RUN npx lerna bootstrap --ci

# Copy the rest of the application source code
# This will overwrite placeholders copied earlier but ensures all code is present
COPY . .

# Remove Git/Husky AFTER copying everything and AFTER install/bootstrap
RUN rm -rf .git .husky

# Run download scripts AFTER all code is present
RUN npm run download:content-type-cache || true
RUN npm run download:h5p || true

# Build the application (compile TS to JS, etc.)
# This uses the 'build' script from the root package.json
RUN npm run build

# Optional: Prune devDependencies after build to reduce image size
# RUN npm prune --omit=dev

# Make start script executable
RUN chmod +x /app/start.sh

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["/app/start.sh"] 