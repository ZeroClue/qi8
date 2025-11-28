# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Docker-based AI image generation service** that leverages the Qwen Image Model with ComfyUI workflow system, optimized for RunPod serverless deployment. The service provides fast, high-quality image generation (8-12 seconds) with expertise in urban scenes and vibrant, colorful imagery.

## Development Commands

### Building and Testing
```bash
# Build the Docker container locally (for testing)
docker build -t qi8-comfyui:local .

# Run the container for local testing
docker run -p 8188:8188 qi8-comfyui:local

# Test API with example request
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d @example-request.json

# Test with the production image
docker pull zeroclue/qi8-comfyui:latest
docker run -p 8188:8188 zeroclue/qi8-comfyui:latest
```

### Environment Variables for Development
```bash
# Sequential model download (slower startup, less memory)
docker run -e MODEL_DOWNLOAD_PARALLEL=false -p 8188:8188 qi8-comfyui:local

# With HuggingFace token (faster model downloads)
docker run -e HF_TOKEN=your_token_here -p 8188:8188 qi8-comfyui:local

# Production logging level
docker run -e COMFY_LOG_LEVEL=WARNING -p 8188:8188 qi8-comfyui:local
```

### CI/CD Pipeline
```bash
# The GitHub Actions workflow automatically builds and pushes to Docker Hub
# Triggered by: push to main, releases, manual dispatch
# Image: zeroclue/qi8-comfyui:latest
# Registry: Docker Hub
```

## Architecture & Core Components

### Container Architecture
- **Base Image**: `runpod/worker-comfyui:5.5.0-base` (pre-configured ComfyUI environment)
- **Runtime Model**: Downloads models at runtime (not built into container) for smaller image size
- **Memory Optimization**: Uses `libtcmalloc` for better memory management
- **Custom Scripts**: Model validation, parallel downloads, and startup orchestration

### Key Models Used
- **Diffusion Model**: `qwen_image_fp8_e4m3fn.safetensors` (Main image generation model)
- **Text Encoder**: `qwen_2.5_vl_7b_fp8_scaled.safetensors` (Text understanding)
- **VAE**: `qwen_image_vae.safetensors` (Image encoding/decoding)
- **LoRA**: `Qwen-Image-Lightning-8steps-V1.0.safetensors` (Fast generation optimization)

### Core Scripts
- **`start.sh`**: Main entrypoint, sets up memory management, model downloads, and ComfyUI startup
- **`check-models.sh`**: Sequential model validation and downloading
- **`check-models-parallel.sh`**: Parallel model validation for faster startup

### Model Architecture
The service uses a sophisticated ComfyUI workflow with these key components:

**Core Workflow Nodes:**
- **UNETLoader**: Loads the main Qwen diffusion model
- **CLIPLoader**: Handles text encoding with Qwen 2.5 VL model
- **VAELoader**: Manages image encoding/decoding
- **LoraLoaderModelOnly**: Applies Lightning LoRA for 8-step fast generation
- **KSampler**: Controls sampling parameters (euler, simple scheduler)
- **ModelSamplingAuraFlow**: Qwen-specific sampling with value 3.1
- **EmptySD3LatentImage**: Creates latent tensors (default 1328x1328)
- **CLIPTextEncode**: Processes positive and negative prompts
- **VAEDecode**: Decodes latent samples to final images

## API Configuration

### Endpoint Structure
- **URL**: `http://localhost:8188/runsync`
- **Method**: POST
- **Format**: JSON with ComfyUI workflow

### Request/Response Format
```json
{
  "input": {
    "workflow": {
      // ComfyUI node-based workflow JSON
    }
  }
}

// Response:
{
  "status": "COMPLETED",
  "output": {
    "images": [{"filename": "ComfyUI_00001_.png", "type": "output"}]
  },
  "execution_time": 8.45
}
```

### Key Generation Parameters
- **Steps**: 8 (optimized for Lightning LoRA)
- **CFG Scale**: 1.0 (lower for Lightning LoRA)
- **Resolution**: 1328x1328 (native Qwen resolution)
- **Sampler**: "euler" with "simple" scheduler
- **Batch Size**: 1 (single image generation)

## Development Workflow

### Local Development Process
1. **Build locally**: `docker build -t qi8-comfyui:local .`
2. **Test functionality**: Run container and verify model downloads
3. **Test API**: Use `example-request.json` to test image generation
4. **Push changes**: Commit to main branch triggers automated build
5. **Deploy**: Use production image on RunPod serverless

### Production Deployment
1. **CI/CD**: GitHub Actions builds and pushes to Docker Hub automatically
2. **Target Platform**: RunPod serverless with GPU support
3. **Resource Requirements**: 8GB+ VRAM, 16GB+ RAM, stable internet
4. **Configuration**: Environment variables for model download and logging

### Testing Approach
- **Container Testing**: Basic functionality validation in CI/CD pipeline
- **Model Validation**: Scripts verify model integrity before starting ComfyUI
- **API Testing**: Use provided example requests for validation
- **Performance Testing**: Monitor generation times (8-12 seconds expected)

## Qwen Model Specializations

### What Qwen Does Best
- **Urban Scenes**: Excellent for cityscapes, street photography, architecture
- **Vibrant Colors**: Superior performance with neon lighting and colorful environments
- **Cultural Elements**: Strong understanding of Asian architecture and cultural elements
- **Artistic Styles**: Excels at cinematic and artistic photography

### Effective Prompt Structure
```
[Subject] + [Setting] + [Lighting] + [Style] + [Details] + [Technical Specs]
```

### Prompt Engineering Tips
- **Urban Photography**: "Neon-lit city street, vibrant colors, wet pavement, cinematic"
- **Cultural Elements**: "Traditional architecture mixed with modern design"
- **Artistic Styles**: "Cinematic photography, dramatic lighting, professional camera quality"

## File Structure & Important Files

### Core Files
- **`Dockerfile`**: Container definition with ComfyUI base and custom scripts
- **`start.sh`**: Main entrypoint script handling model loading and service startup
- **`check-models.sh` / `check-models-parallel.sh`**: Model validation and download scripts
- **`example-request.json`**: Complete workflow example for testing API functionality
- **`.github/workflows/docker-build.yml`**: CI/CD pipeline for automated builds

### Documentation Files
- **`README.md`**: Quick start guide and overview
- **`API.md`**: Complete API reference and workflow documentation
- **`DEPLOYMENT.md`**: RunPod serverless deployment guide
- **`SETUP.md`**: CI/CD and development setup instructions
- **`EXAMPLES.md`**: Additional usage examples and prompt engineering

## Environment Variables

### Core Configuration
- `MODEL_DOWNLOAD_PARALLEL`: `true`/`false` (default: `true`) - Parallel vs sequential model downloads
- `COMFY_LOG_LEVEL`: `DEBUG`/`INFO`/`WARNING`/`ERROR` (default: `DEBUG`) - Logging verbosity
- `HF_TOKEN`: HuggingFace token for model downloads (optional but recommended)
- `SERVE_API_LOCALLY`: `true`/`false` (default: `false`) - Local API serving mode

### Resource Requirements
- **VRAM**: 8GB minimum, 16GB recommended for optimal performance
- **RAM**: 16GB+ for smooth operation during model downloads
- **Storage**: 10GB+ for models and cache
- **Network**: Stable internet connection for model downloads

## Troubleshooting Common Issues

### Container Startup Issues
- **Model Download Failures**: Check network connectivity and HF_TOKEN
- **Memory Issues**: Set `MODEL_DOWNLOAD_PARALLEL=false` or use larger instance
- **Slow Startup**: First run takes 5-10 minutes for model downloads

### API Issues
- **Connection Refused**: Wait for model download completion before testing API
- **Invalid Workflow**: Verify JSON structure matches provided examples
- **Generation Failures**: Check GPU availability and VRAM usage

### Performance Issues
- **Slow Generation**: Verify GPU type and available VRAM
- **Memory Errors**: Reduce batch size or image resolution
- **Quality Issues**: Adjust prompts and generation parameters