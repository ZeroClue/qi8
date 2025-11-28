# Qwen Image Model for ComfyUI

🎨 **Fast AI image generation using Qwen models on RunPod serverless infrastructure**

Generate stunning images from text descriptions in just 8 seconds using the advanced Qwen Image Model with Lightning LoRA optimization.

## ✨ What It Does

- **🖼️ High-Quality Images**: 1328x1328 resolution with vibrant, professional results
- **⚡ Lightning Fast**: 8-step generation process (8-12 seconds per image)
- **🌟 Urban Scene Specialist**: Optimized for cityscapes, neon lighting, and cultural photography
- **🚀 Production Ready**: Built for RunPod serverless deployment with automatic scaling
- **🔧 Easy to Use**: Simple API interface with comprehensive examples

## 🚀 Quick Start (3 Easy Steps)

### Step 1: Pull the Container
```bash
docker pull zeroclue/qi8-comfyui:latest
```

### Step 2: Run Locally
```bash
docker run -p 8188:8188 zeroclue/qi8-comfyui:latest
```

### Step 3: Generate Your First Image
```bash
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{"input":{"workflow":{"6":{"inputs":{"text":"A beautiful sunset over mountains","clip":["38",0]},"class_type":"CLIPTextEncode"},"7":{"inputs":{"text":"","clip":["38",0]},"class_type":"CLIPTextEncode"},"3":{"inputs":{"seed":12345,"steps":8,"cfg":1,"sampler_name":"euler","scheduler":"simple","denoise":1,"model":["66",0],"positive":["6",0],"negative":["7",0],"latent_image":["58",0]},"class_type":"KSampler"},"8":{"inputs":{"samples":["3",0],"vae":["39",0]},"class_type":"VAEDecode"},"37":{"inputs":{"filename":"qwen_image_fp8_e4m3fn.safetensors"},"class_type":"UNETLoader"},"38":{"inputs":{"filename":"qwen_2.5_vl_7b_fp8_scaled.safetensors"},"class_type":"CLIPLoader"},"39":{"inputs":{"filename":"qwen_image_vae.safetensors"},"class_type":"VAELoader"},"58":{"inputs":{"width":1328,"height":1328,"batch_size":1},"class_type":"EmptySD3LatentImage"},"60":{"inputs":{"filename_prefix":"ComfyUI","images":["8",0]},"class_type":"SaveImage"},"66":{"inputs":{"value":3.1000000000000005,"model":["73",0]},"class_type":"ModelSamplingAuraFlow"},"73":{"inputs":{"filename":"Qwen-Image-Lightning-8steps-V1.0.safetensors","model":["37",0]},"class_type":"LoraLoaderModelOnly"}}}'
```

🎉 **That's it!** Your first AI-generated image is ready. Check the container output for the image filename.

## 🎯 Example Use Cases

### 🌃 Urban Photography
- **Hong Kong street scenes** with vibrant neon lights
- **Modern architecture** and cityscape photography
- **Cultural landmarks** and traditional elements

### 🎨 Artistic Creation
- **Cyberpunk environments** with futuristic elements
- **Cinematic scenes** with dramatic lighting
- **Digital art** and creative illustrations

### ⚡ Rapid Prototyping
- **Concept art** for games and films
- **Marketing visuals** and promotional materials
- **Social media content** and brand imagery

## ✨ Key Features

- **⚡ Fast Generation**: 8-step Lightning LoRA process
- **🎨 High Quality**: 1328x1328 professional resolution
- **🔧 Easy to Use**: Simple REST API interface
- **📦 Pre-configured**: All models download automatically
- **🚀 Production Ready**: Optimized for RunPod serverless
- **🌈 Vibrant Colors**: Specialized for colorful, dynamic scenes
- **🏙️ Urban Optimized**: Excellent for city and street photography

## 🛠️ Advanced Usage

### Custom Prompts
```bash
# Urban night scene
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{"input":{"workflow":{"6":{"inputs":{"text":"Neon-lit Tokyo street at night, vibrant colors, reflections on wet pavement, cinematic photography","clip":["38",0]},"class_type":"CLIPTextEncode"}}}}'

# Natural landscape
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{"input":{"workflow":{"6":{"inputs":{"text":"Serene mountain lake at sunrise, peaceful, golden hour lighting, nature photography","clip":["38",0]},"class_type":"CLIPTextEncode"}}}}'
```

### Different Resolutions
```bash
# Portrait orientation (768x1024)
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{"input":{"workflow":{"58":{"inputs":{"width":768,"height":1024,"batch_size":1},"class_type":"EmptySD3LatentImage"}}}}'

# Landscape orientation (1024x768)
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{"input":{"workflow":{"58":{"inputs":{"width":1024,"height":768,"batch_size":1},"class_type":"EmptySD3LatentImage"}}}}'
```

## 🐳 Docker Options

### Environment Variables
```bash
# Sequential model download (slower startup, less memory)
docker run -e MODEL_DOWNLOAD_PARALLEL=false -p 8188:8188 zeroclue/qi8-comfyui:latest

# With HuggingFace token (faster model downloads)
docker run -e HF_TOKEN=your_token_here -p 8188:8188 zeroclue/qi8-comfyui:latest

# Reduced logging for production
docker run -e COMFY_LOG_LEVEL=WARNING -p 8188:8188 zeroclue/qi8-comfyui:latest
```

### Resource Requirements
- **VRAM**: 8GB minimum, 16GB recommended
- **RAM**: 16GB+ for smooth operation
- **Storage**: 10GB+ for models and cache

## 📚 What Makes This Special

This container uses the **Qwen Image Model**, specifically optimized for:

🌈 **Vibrant, Colorful Generation**
- Excellent for neon lighting, colorful environments
- Rich saturation and dynamic contrast
- Perfect for artistic and creative applications

🏙️ **Urban and Street Photography**
- Superior performance on cityscapes and architecture
- Natural understanding of urban environments
- Great for cultural and architectural elements

⚡ **Fast 8-Step Generation**
- Lightning LoRA optimization for speed
- Consistent, high-quality output
- Ideal for rapid prototyping and batch processing

## 🚀 Production Deployment

For production use, deploy on **RunPod Serverless**:

1. **Cost Effective**: Pay only for what you use
2. **Auto-scaling**: Handle traffic spikes automatically
3. **Global Coverage**: Deploy in multiple regions
4. **Monitoring**: Built-in performance metrics

👉 **[See Deployment Guide](DEPLOYMENT.md)** for complete setup instructions

## 🔧 API Reference

### Quick API Summary
```javascript
// Generate image
const response = await fetch('http://localhost:8188/runsync', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    input: {
      workflow: { /* ComfyUI workflow JSON */ }
    }
  })
});

const result = await response.json();
// result.output.images contains generated images
```

### Response Format
```json
{
  "status": "COMPLETED",
  "output": {
    "images": [
      {
        "filename": "ComfyUI_00001_.png",
        "type": "output"
      }
    ]
  },
  "execution_time": 8.45
}
```

📖 **[Complete API Documentation](API.md)** for detailed reference

## 💡 Prompt Engineering Tips

### What Works Best
- **Urban Scenes**: "Neon-lit city street, vibrant colors, wet pavement"
- **Cultural Elements**: "Traditional architecture mixed with modern design"
- **Artistic Styles**: "Cinematic photography, dramatic lighting"
- **Colorful Environments**: "Vibrant market scene, rich textures and colors"

### Prompt Structure
```
[Subject] + [Setting] + [Lighting] + [Style] + [Details]
```

### Examples
✅ **Good**: "Sunset over Hong Kong skyline, neon signs reflecting on wet streets, cinematic photography"
✅ **Good**: "Futuristic city with floating gardens, bioluminescent lighting, digital art style"
❌ **Poor**: "a picture of a city"
❌ **Poor": "city, night, lights"

## 🆘 Getting Help

### 📖 Documentation
- **[API Documentation](API.md)** - Technical reference and examples
- **[Deployment Guide](DEPLOYMENT.md)** - RunPod serverless setup
- **[Examples & Prompts](EXAMPLES.md)** - Additional usage examples

### 🐛 Common Issues

**❌ Container won't start**
```bash
# Check container status
docker logs <container_id>
# Ensure models download completes (may take 5-10 minutes first time)
```

**❌ API returns errors**
```bash
# Test with simple workflow
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{"input":{"workflow":{"6":{"inputs":{"text":"test","clip":["38",0]},"class_type":"CLIPTextEncode"}}}}'
```

**❌ Generation is slow**
- Verify GPU availability (CUDA required)
- Check VRAM usage (minimum 8GB recommended)
- Consider batch processing for multiple images

### 💬 Community Support
- **GitHub Issues**: Report bugs and request features
- **Documentation**: Updated regularly with best practices

## 🔮 What's Next

### Planned Features
- [ ] Additional LoRA models for different styles
- [ ] Batch processing API endpoints
- [ ] Image-to-image generation support
- [ ] Custom model fine-tuning guides
- [ ] Integration examples for popular frameworks

### Performance Improvements
- [ ] Faster cold start times
- [ ] Optimized model loading
- [ ] Multi-GPU support
- [ ] Advanced caching mechanisms

---

## 📄 License

This project builds upon open-source AI models and ComfyUI framework. Please respect model licenses and usage terms.

## 🙏 Acknowledgments

- **Qwen Team** - For the amazing Qwen Image Model
- **ComfyUI** - Powerful workflow-based AI image generation
- **RunPod** - Serverless GPU infrastructure
- **HuggingFace** - Model hosting and distribution

---

**Happy Generating! 🎨**

If you create something amazing with this container, we'd love to see it! Feel free to share your results and feedback.