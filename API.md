# Qwen Image Model API Documentation

Fast AI image generation using Qwen models with RunPod serverless infrastructure.

## Quick Start (5-Minute Guide)

### 1. Pull the Container
```bash
docker pull zeroclue/qi8-comfyui:latest
```

### 2. Run the Container
```bash
docker run -p 8188:8188 zeroclue/qi8-comfyui:latest
```

### 3. Make Your First API Call
```bash
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d @example-request.json
```

## API Reference

### Endpoint
```
POST /runsync
```

### Request Format
```json
{
  "input": {
    "workflow": {
      // ComfyUI workflow JSON
    }
  }
}
```

### Response Format (v5.0+)
```json
{
  "id": "job_id",
  "status": "COMPLETED",
  "output": {
    "images": [
      {
        "filename": "ComfyUI_00001_.png",
        "subfolder": "",
        "type": "output"
      }
    ]
  },
  "execution_time": 8.45
}
```

### Status Codes
- `200`: Success
- `400`: Invalid request format
- `500`: Internal server error

## Workflow Reference

### Qwen Model Architecture

The Qwen Image Model uses a sophisticated workflow with these key components:

#### Core Models
- **UNETLoader**: `qwen_image_fp8_e4m3fn.safetensors` - Main diffusion model
- **CLIPLoader**: `qwen_2.5_vl_7b_fp8_scaled.safetensors` - Text understanding
- **VAELoader**: `qwen_image_vae.safetensors` - Image encoding/decoding
- **LoraLoaderModelOnly**: `Qwen-Image-Lightning-8steps-V1.0.safetensors` - Fast generation LoRA

#### Workflow Nodes

**KSampler (Node 3)**
- `seed`: Random seed for reproducible results
- `steps`: Number of sampling steps (8 for Lightning LoRA)
- `cfg`: Classifier-free guidance scale (1.0 for Lightning)
- `sampler_name`: Sampling algorithm ("euler")
- `scheduler`: Noise scheduler ("simple")
- `denoise`: Denoising strength (1.0 for full generation)

**CLIPTextEncode (Nodes 6 & 7)**
- `text`: Prompt text (positive or negative)
- `clip`: Reference to CLIP model

**VAEDecode (Node 8)**
- `samples`: Latent samples from KSampler
- `vae`: Reference to VAE model

**EmptySD3LatentImage (Node 58)**
- `width`: Image width (1328)
- `height`: Image height (1328)
- `batch_size`: Number of images (1)

**SaveImage (Node 60)**
- `filename_prefix`: Output file prefix ("ComfyUI")
- `images`: Images to save

### Parameter Guide

#### Generation Parameters
- **Steps**: 8 (optimized for Lightning LoRA)
- **CFG Scale**: 1.0 (lower for Lightning LoRA)
- **Resolution**: 1328x1328 (native Qwen resolution)
- **Batch Size**: 1 (single image generation)

#### Sampling Options
- **Sampler**: "euler" (recommended for Qwen)
- **Scheduler**: "simple" (works best with Lightning)

#### Model Sampling
- **AuraFlow**: 3.1000000000000005 (Qwen-specific parameter)

## Usage Examples

### Basic Text-to-Image

```json
{
  "input": {
    "workflow": {
      "6": {
        "inputs": {
          "text": "A beautiful sunset over the ocean",
          "clip": ["38", 0]
        },
        "class_type": "CLIPTextEncode"
      }
      // ... rest of workflow
    }
  }
}
```

### Negative Prompting

```json
{
  "input": {
    "workflow": {
      "6": {
        "inputs": {
          "text": "A stunning landscape photograph",
          "clip": ["38", 0]
        },
        "class_type": "CLIPTextEncode"
      },
      "7": {
        "inputs": {
          "text": "blurry, low quality, distorted",
          "clip": ["38", 0]
        },
        "class_type": "CLIPTextEncode"
      }
      // ... rest of workflow
    }
  }
}
```

### Custom Resolution

```json
{
  "input": {
    "workflow": {
      "58": {
        "inputs": {
          "width": 1024,
          "height": 768,
          "batch_size": 1
        },
        "class_type": "EmptySD3LatentImage"
      }
      // ... rest of workflow
    }
  }
}
```

## Prompt Engineering for Qwen

### What Qwen Does Best
- **Urban Scenes**: Cityscapes, street photography, architecture
- **Vibrant Colors**: Neon lights, colorful environments, artistic lighting
- **Cultural Elements**: Hong Kong style, Asian architecture, traditional elements
- **Artistic Styles**: Cinematic, photography, digital art

### Effective Prompt Structure
```
[Subject] + [Setting] + [Style] + [Details] + [Technical Specs]
```

### Example Prompts

**Hong Kong Street Scene**
```
A vibrant, warm neon-lit street scene in Hong Kong at dusk, with a mix of colorful Chinese and English signs glowing brightly. The atmosphere is lively, cinematic, and rain-washed with reflections on the pavement.
```

**Urban Photography**
```
Modern cityscape at golden hour, dramatic lighting, architectural photography, high contrast, professional camera quality.
```

**Artistic Interpretation**
```
Futuristic city with floating gardens, bioluminescent lighting, cyberpunk aesthetics, neon colors, digital painting style.
```

## Error Handling

### Common Errors

**Model Loading Failed**
```json
{
  "error": "Failed to load model: qwen_image_fp8_e4m3fn.safetensors"
}
```
**Solution**: Wait for automatic model download or check HuggingFace token

**Invalid Workflow Format**
```json
{
  "error": "Invalid workflow JSON structure"
}
```
**Solution**: Verify JSON syntax and required node connections

**Memory Issues**
```json
{
  "error": "CUDA out of memory"
}
```
**Solution**: Reduce batch size or image resolution

### Troubleshooting Checklist

1. **Container Status**: Verify container is running with `docker ps`
2. **Model Availability**: Check models are downloaded in container logs
3. **API Endpoint**: Confirm port 8188 is accessible
4. **Request Format**: Validate JSON structure
5. **Network**: Check firewall settings for port 8188

## Performance Optimization

### Generation Speed
- **8-step generation**: ~8-12 seconds per image
- **Parallel processing**: Use multiple containers for scaling
- **GPU optimization**: CUDA-enabled instances recommended

### Resource Requirements
- **VRAM**: Minimum 8GB, 16GB recommended
- **RAM**: 16GB+ for smooth operation
- **Storage**: 10GB+ for models and cache

### Batch Processing
```json
{
  "input": {
    "workflow": {
      "58": {
        "inputs": {
          "width": 1328,
          "height": 1328,
          "batch_size": 4
        },
        "class_type": "EmptySD3LatentImage"
      }
      // ... rest of workflow
    }
  }
}
```

## Integration Examples

### Python Client
```python
import requests
import json

def generate_image(prompt):
    url = "http://localhost:8188/runsync"

    with open('example-request.json', 'r') as f:
        workflow = json.load(f)

    # Update prompt
    workflow['input']['workflow']['6']['inputs']['text'] = prompt

    response = requests.post(url, json=workflow)
    return response.json()

# Generate image
result = generate_image("A beautiful mountain landscape")
print(result)
```

### JavaScript Client
```javascript
async function generateImage(prompt) {
    const response = await fetch('http://localhost:8188/runsync', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            input: {
                workflow: {
                    // Your workflow JSON
                }
            }
        })
    });

    return await response.json();
}
```

## Environment Variables

### Container Configuration
- `MODEL_DOWNLOAD_PARALLEL`: `true`/`false` (default: `true`)
- `COMFY_LOG_LEVEL`: `DEBUG`/`INFO`/`WARNING`/`ERROR` (default: `DEBUG`)
- `HF_TOKEN`: HuggingFace token for model downloads
- `SERVE_API_LOCALLY`: `true`/`false` (default: `false`)

### Usage Examples
```bash
# Sequential model download
docker run -e MODEL_DOWNLOAD_PARALLEL=false -p 8188:8188 zeroclue/qi8-comfyui:latest

# With HuggingFace token
docker run -e HF_TOKEN=your_token_here -p 8188:8188 zeroclue/qi8-comfyui:latest

# Local API serving
docker run -e SERVE_API_LOCALLY=true -p 8188:8188 zeroclue/qi8-comfyui:latest
```

## Advanced Configuration

### Custom Workflows
You can modify the workflow JSON to:
- Change sampling parameters
- Add additional processing nodes
- Implement custom post-processing
- Create complex generation pipelines

### Model Variants
The container supports these Qwen model configurations:
- Standard Qwen Image Model
- Qwen Lightning LoRA (8-step fast generation)
- Custom LoRA loading
- Model fine-tuning support

## Monitoring and Logging

### Container Logs
```bash
# View real-time logs
docker logs -f <container_id>

# Check model download status
docker logs <container_id> | grep "model"
```

### Performance Metrics
- **Generation Time**: Average 8-12 seconds
- **Memory Usage**: 8-16GB VRAM
- **Success Rate**: 99%+ with proper configuration

---

## Support

- **API Issues**: Check workflow JSON format
- **Model Problems**: Verify model download completion
- **Performance**: Adjust batch size and resolution
- **Deployment**: See [DEPLOYMENT.md](DEPLOYMENT.md) for RunPod setup

For additional examples and prompts, see [EXAMPLES.md](EXAMPLES.md).