# H5P REST API Server for Cloudron

This repository contains the necessary files to deploy the H5P REST API Server to Cloudron.

## Prerequisites

- A Cloudron server
- Docker installed on your local machine
- Cloudron CLI installed (`npm install -g cloudron`)

## Building and Deploying to Cloudron

### Method 1: Using Cloudron CLI

1. Clone this repository:
   ```
   git clone https://github.com/pascalkienast/H5P-RESTAPI-Server
   cd H5P-RESTAPI-Server
   ```

2. Login to your Cloudron:
   ```
   cloudron login https://my.cloudron.domain
   ```

3. Build and publish the app:
   ```
   cloudron build
   ```
   When prompted, enter a Docker repository name (e.g., `your-docker-repo/h5p-restapi-server`).

4. Install the app on your Cloudron:
   ```
   cloudron install --image your-docker-repo/h5p-restapi-server
   ```

### Method 2: Using Docker Registry

1. Build the Docker image:
   ```
   docker build -t your-docker-repo/h5p-restapi-server:1.0.0 .
   ```

2. Push the image to your Docker registry:
   ```
   docker push your-docker-repo/h5p-restapi-server:1.0.0
   ```

3. Install on your Cloudron using the web interface:
   - Go to your Cloudron admin panel
   - Select "App Store" → "Install App" → "Custom App"
   - Enter the Docker image URL
   - Follow the installation wizard

## Configuration

After installation, the app will be available at the domain you specified during installation. 

The H5P REST API Server stores all data in `/app/data` within the container, which is mapped to persistent storage by Cloudron.

## Updating

To update the app:

1. Build a new version of the Docker image with an incremented version tag
2. Push the new image to your Docker registry
3. Run `cloudron update --app APPID --image your-docker-repo/h5p-restapi-server:new-version`

## Troubleshooting

- Check Cloudron app logs from the Cloudron admin dashboard
- Ensure the app has the necessary memory allocation (can be configured in CloudronManifest.json)
- Verify the app has the correct permissions for persistent storage

## License

This deployment configuration is provided under the same license as the original H5P REST API Server. 