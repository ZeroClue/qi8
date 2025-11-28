# 🚀 Complete Setup Guide

## Overview

This guide walks you through setting up automated builds and deployments for your **Qwen Image Model ComfyUI container** using GitHub Actions. The pipeline will automatically build and push your `zeroclue/qi8-comfyui` image to Docker Hub.

## ✨ What You'll Get

- **🔄 Automated CI/CD**: Automatic builds on code changes
- **📦 Docker Hub Integration**: Professional container registry
- **🏷️ Version Management**: Semantic versioning with tags
- **⚡ Optimized Builds**: Fast builds with caching
- **🧪 Container Testing**: Basic functionality validation

## 🆕 Quick Setup (5 Minutes)

### 1. Docker Hub Repository
1. Create account at [hub.docker.com](https://hub.docker.com)
2. Create repository named `qi8-comfyui`
3. Generate access token with Read/Write permissions

### 2. GitHub Secrets
Add these secrets to your repository (`Settings` > `Secrets`):
- `DOCKERHUB_USERNAME`: `zeroclue`
- `DOCKERHUB_TOKEN`: *Your Docker Hub token*

### 3. Push & Build
```bash
git add .
git commit -m "Add Qwen Image Model container"
git push origin main
```

🎉 **That's it!** Your container will automatically build and push to Docker Hub.

## Prerequisites

1. **Docker Hub Account**: Create an account at https://hub.docker.com
2. **GitHub Repository**: Your code should be in a GitHub repository
3. **Required Configuration**: Docker Hub username: `zeroclue`, Image name: `qi8-comfyui`

## Step 1: Docker Hub Setup

### 1.1 Create Docker Hub Repository

1. Go to https://hub.docker.com
2. Click "Create Repository"
3. Repository name: `qi8-comfyui`
4. Description: `ComfyUI worker with model validation and parallel downloads`
5. Visibility: Public (or Private if preferred)
6. Click "Create"

### 1.2 Generate Docker Hub Access Token

1. Go to Docker Hub > Account Settings > Security
2. Click "New Access Token"
3. **Token name**: `github-actions-ci`
4. **Description**: `CI/CD pipeline for ComfyUI builds`
5. **Permissions**:
   - ✅ Read
   - ✅ Write
   - ✅ Delete
6. Click "Generate"
7. **Important**: Copy the generated token immediately (you won't see it again)

## Step 2: GitHub Repository Setup

### 2.1 Add Secrets to GitHub Repository

1. Go to your GitHub repository
2. Navigate to **Settings** > **Secrets and variables** > **Actions**
3. Click **New repository secret**

#### Required Secrets:

**Secret 1: DOCKERHUB_USERNAME**
- Name: `DOCKERHUB_USERNAME`
- Value: `zeroclue`
- Description: Docker Hub username for container registry

**Secret 2: DOCKERHUB_TOKEN**
- Name: `DOCKERHUB_TOKEN`
- Value: *Paste the token from Step 1.2*
- Description: Docker Hub access token for authentication

#### Optional Secret:

**Secret 3: HUGGINGFACE_TOKEN** (Recommended for model downloads)
- Name: `HUGGINGFACE_TOKEN`
- Value: *Your HuggingFace token*
- Description: Token for downloading models from HuggingFace

To create a HuggingFace token:
1. Go to https://huggingface.co/settings/tokens
2. Click "New token"
3. Name: `comfyui-ci`
4. Permissions: Read access to models
5. Copy the generated token

### 2.2 Verify Repository Permissions

Ensure your GitHub repository has Actions enabled:
1. Go to **Settings** > **Actions** > **General**
2. Under "Actions permissions", select:
   - ✅ Allow all actions and reusable workflows
   - ✅ Allow GitHub Actions to create and approve pull requests
   - ✅ Allow fork pull requests to run workflows (optional)

## Step 3: First Build

### 3.1 Trigger Initial Build

The workflow is configured to trigger on:
- ✅ Push to `main` branch
- ✅ Creating releases (tags starting with `v`)
- ✅ Manual dispatch

**Option 1: Push to main**
```bash
git add .
git commit -m "Add GitHub Actions CI/CD pipeline"
git push origin main
```

**Option 2: Manual trigger**
1. Go to **Actions** tab in your GitHub repository
2. Select "Build and Push Docker Image" workflow
3. Click "Run workflow"
4. Choose branch and click "Run workflow"

### 3.2 Monitor Build Process

1. Go to the **Actions** tab in your GitHub repository
2. Click on the running workflow
3. Monitor the steps:
   - ✅ System cleanup
   - ✅ Repository checkout
   - ✅ Docker Buildx setup
   - ✅ Docker Hub login
   - ✅ Image build and push
   - ✅ Container testing

### 3.3 Verify Docker Hub Image

1. Go to https://hub.docker.com/repository/docker/zeroclue/qi8-comfyui
2. Verify the image appears with the latest tag
3. Check the image size and build information

## 🐳 Using Your Container

### Quick Test (After Build Completes)

```bash
# Pull your freshly built image
docker pull zeroclue/qi8-comfyui:latest

# Run the container
docker run -p 8188:8188 zeroclue/qi8-comfyui:latest

# Wait for models to download (first time takes 5-10 minutes)
# Then test the API
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{"input":{"workflow":{"6":{"inputs":{"text":"A beautiful sunset","clip":["38",0]},"class_type":"CLIPTextEncode"}}}}'
```

### Advanced Container Options

```bash
# Sequential model download (less memory usage)
docker run -e MODEL_DOWNLOAD_PARALLEL=false -p 8188:8188 zeroclue/qi8-comfyui:latest

# With HuggingFace token (faster model downloads)
docker run -e HF_TOKEN=your_token_here -p 8188:8188 zeroclue/qi8-comfyui:latest

# Production mode (reduced logging)
docker run -e COMFY_LOG_LEVEL=WARNING -p 8188:8188 zeroclue/qi8-comfyui:latest

# Custom resolution
docker run -e CUSTOM_RESOLUTION=1024x768 -p 8188:8188 zeroclue/qi8-comfyui:latest
```

### Environment Variables Guide

| Variable | Default | Description |
|----------|---------|-------------|
| `MODEL_DOWNLOAD_PARALLEL` | `true` | Parallel model downloads (faster startup) |
| `COMFY_LOG_LEVEL` | `DEBUG` | Logging level (`DEBUG`, `INFO`, `WARNING`, `ERROR`) |
| `HF_TOKEN` | - | HuggingFace token for reliable model downloads |
| `SERVE_API_LOCALLY` | `false` | Enable local API serving mode |

### Resource Requirements

- **VRAM**: 8GB minimum, 16GB recommended
- **RAM**: 16GB+ for smooth operation
- **Storage**: 10GB+ for models and cache
- **Network**: Stable internet for model downloads

## Step 5: Release Workflow

### 5.1 Create a Release

1. Go to your GitHub repository
2. Click **Releases** > **Create a new release**
3. **Tag version**: `v1.0.0` (semantic versioning)
4. **Release title**: `Version 1.0.0`
5. **Description**: Describe the changes
6. Click **Publish release**

This will automatically trigger the GitHub Actions workflow and create versioned tags:
- `zeroclue/qi8-comfyui:v1.0.0`
- `zeroclue/qi8-comfyui:v1.0`
- `zeroclue/qi8-comfyui:v1`

## Troubleshooting

### Common Issues

**1. Docker Hub Authentication Failed**
- Verify `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets
- Ensure Docker Hub token has correct permissions
- Check if Docker Hub repository exists

**2. Build Timeout**
- The workflow includes system cleanup to prevent timeouts
- Large model downloads may cause timeouts during testing phase
- Monitor GitHub Actions logs for specific errors

**3. Model Download Failures**
- Ensure `HUGGINGFACE_TOKEN` is provided if required
- Check network connectivity during container testing
- Model downloads happen at container startup, not build time

**4. Permission Errors**
- Ensure GitHub Actions has permission to write packages
- Check repository Actions permissions in settings

### Monitoring

- **GitHub Actions**: Monitor build times, success rates, and error logs
- **Docker Hub Insights**: Track image pulls and usage statistics
- **Build Cache**: GitHub Actions cache automatically optimizes subsequent builds

## Advanced Configuration

### Manual Workflow Dispatch

You can trigger builds manually:
1. Go to **Actions** tab
2. Select "Build and Push Docker Image" workflow
3. Click "Run workflow"
4. Optionally provide a version override

### Build Optimization

The pipeline includes several optimizations:
- ✅ System cleanup before builds
- ✅ Docker layer caching with GitHub Actions cache
- ✅ Multi-stage build with BuildKit
- ✅ Optimized .dockerignore file

### Security Considerations

- ✅ Secrets are properly managed in GitHub repository
- ✅ Tokens are not logged in workflow output
- ✅ Minimal permissions granted to workflows
- ✅ Docker Hub token can be rotated regularly

## 🎯 Success Indicators

Your CI/CD pipeline is working correctly when:

✅ **GitHub Actions**: Workflow completes successfully on main branch push
✅ **Docker Hub**: Image appears in your repository with correct tags
✅ **Container Testing**: Container starts and model validation works
✅ **API Response**: Your test request returns a successful response
✅ **Version Tags**: Semantic versioning creates appropriate tags
✅ **Fast Builds**: Subsequent builds are faster due to cache optimization

## 🆘 Getting Help

### Quick Troubleshooting

**❌ Container won't start**
```bash
# Check container logs
docker logs <container_id>
# Look for model download progress
```

**❌ Build fails**
```bash
# Check GitHub Actions logs
# Verify DOCKERHUB_USERNAME and DOCKERHUB_TOKEN secrets
```

**❌ API returns errors**
```bash
# Test with simple request first
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{"input":{"workflow":{"6":{"inputs":{"text":"test","clip":["38",0]},"class_type":"CLIPTextEncode"}}}}'
```

### Support Resources

- 📖 **[API Documentation](API.md)** - Complete API reference
- 🚀 **[Deployment Guide](DEPLOYMENT.md)** - RunPod serverless setup
- 🎨 **[Examples & Prompts](EXAMPLES.md)** - Usage examples and inspiration
- 🐛 **GitHub Issues** - Report bugs and request features

### Common Solutions

**Problem**: "Build takes too long"
**Solution**: First build downloads models (~10GB), subsequent builds are faster with caching

**Problem**: "API doesn't respond"
**Solution**: Wait 5-10 minutes for model download completion on first run

**Problem**: "Memory errors"
**Solution**: Set `MODEL_DOWNLOAD_PARALLEL=false` or use GPU with 16GB+ VRAM

## 🎉 You're All Set!

Your **Qwen Image Model** container is now ready for:
- 🔄 **Automated builds** on every push to main branch
- 📦 **Professional Docker Hub** deployment
- 🚀 **RunPod serverless** production use
- 🎨 **High-quality AI image generation**

**Next Steps:**
1. 🎨 Try generating images with different prompts from [EXAMPLES.md](EXAMPLES.md)
2. 🚀 Deploy to RunPod serverless with the [Deployment Guide](DEPLOYMENT.md)
3. 🔧 Customize workflows using the [API Documentation](API.md)

**Happy Creating! 🎨✨**