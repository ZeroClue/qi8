# Qwen Image Model - Examples & Prompt Engineering

🎨 **Comprehensive guide to creating stunning AI images with the Qwen Image Model**

This guide provides practical examples, prompt engineering techniques, and advanced workflows to help you get the most out of the Qwen Image Model.

## 🚀 Quick Examples

### Basic Usage
```bash
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{"input":{"workflow":{"6":{"inputs":{"text":"A beautiful sunset over mountains","clip":["38",0]},"class_type":"CLIPTextEncode"}}}}'
```

### Advanced Workflow
```bash
# Full workflow with custom parameters
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "workflow": {
        "6": {
          "inputs": {
            "text": "Neon-lit cyberpunk city at night, vibrant colors, flying vehicles",
            "clip": ["38", 0]
          },
          "class_type": "CLIPTextEncode"
        },
        "3": {
          "inputs": {
            "seed": 12345,
            "steps": 8,
            "cfg": 1.0,
            "sampler_name": "euler",
            "scheduler": "simple",
            "denoise": 1.0,
            "model": ["66", 0],
            "positive": ["6", 0],
            "negative": ["7", 0],
            "latent_image": ["58", 0]
          },
          "class_type": "KSampler"
        },
        "58": {
          "inputs": {
            "width": 1328,
            "height": 1328,
            "batch_size": 1
          },
          "class_type": "EmptySD3LatentImage"
        }
      }
    }
  }'
```

## 🎯 Prompt Engineering Masterclass

### The Qwen Advantage

The Qwen Image Model excels at:
- **Urban environments** and cityscapes
- **Vibrant, colorful scenes** with rich saturation
- **Cultural architecture** and traditional elements
- **Neon lighting** and dramatic illumination
- **Artistic photography** with professional quality

### Prompt Structure Formula

```
[Main Subject] + [Setting/Environment] + [Lighting/Time] + [Style/Mood] + [Artistic Details] + [Technical Specifications]
```

## 🌃 Urban & City Examples

### Hong Kong Style (Qwen's Specialty)

**Classic Hong Kong Street**
```
A vibrant, warm neon-lit street scene in Hong Kong at dusk, with a mix of colorful Chinese and English signs glowing brightly. The atmosphere is lively, cinematic, and rain-washed with reflections on the pavement. The colors are vivid, full of pink, blue, red, and green hues. Crowded buildings with overlapping neon signs. 1980s Hong Kong style.
```

**Modern Tokyo Nightscape**
```
Shibuya crossing at night, massive digital screens displaying anime advertisements, streams of people crossing under neon lights, vibrant purple and pink illumination, modern architecture, sense of organized chaos, urban energy, high-tech atmosphere, professional street photography style.
```

**Cyberpunk Megalopolis**
```
Futuristic cyberpunk city with towering skyscrapers, flying vehicles between buildings, holographic advertisements in multiple languages, neon glow reflecting off wet streets, dense urban landscape, Blade Runner aesthetic, cybernetic elements, dramatic lighting contrasts.
```

### Architectural Photography

**Modern Architecture**
```
Contemporary glass skyscraper during golden hour, geometric patterns, reflections in glass facade, minimalist design, clean lines, architectural photography, professional composition, warm afternoon light, urban sophistication.
```

**Traditional Architecture**
```
Ancient Chinese temple courtyard with ornate wooden architecture, traditional roof tiles, red lanterns hanging, stone pathways with moss, serene atmosphere, cultural heritage preservation, natural lighting through trees.
```

## 🎨 Artistic & Creative Examples

### Digital Art & Illustration

**Fantasy City**
```
Magical floating city in the clouds, bioluminescent plants on buildings, waterfalls cascading between floating platforms, ethereal lighting, fantasy digital art style, detailed textures, vibrant colors, dreamlike atmosphere.
```

**Steampunk Metropolis**
```
Victorian-era city with steampunk technology, brass and copper machinery, steam-powered airships flying between clock towers, intricate mechanical details, warm gaslight illumination, sepia tones mixed with bright brass colors.
```

### Cinematic Scenes

**Film Noir Style**
```
1940s detective noir city street, dramatic shadows from streetlights, lone figure in trench coat, wet pavement reflecting neon signs, black and white with selective color, moody atmosphere, film grain texture, cinematic lighting.
```

**Sci-Fi Epic**
```
Futuristic space port city on alien planet, multiple moons in the sky, exotic architecture blending organic and technological elements, glowing energy streams, otherworldly color palette, science fiction concept art, epic scale.
```

## 🌅 Natural & Landscape Examples

### Diverse Environments

**Mountain Serenity**
```
Serene mountain lake at sunrise, crystal clear water reflecting snow-capped peaks, morning mist rising from the surface, golden hour lighting, peaceful atmosphere, landscape photography style, natural beauty, tranquility.
```

**Deset Oasis**
```
Sahara desert oasis with palm trees, crystal blue water pool surrounded by golden sand dunes, dramatic sunset with orange and purple sky, sense of isolation and beauty, warm color palette, natural wonder.
```

## ⚡ Advanced Techniques

### Negative Prompting

**Remove Unwanted Elements**
```bash
# Positive prompt
"Beautiful city street with modern architecture"

# Negative prompt
"blurry, low quality, distorted, ugly, text, watermark, signature, duplicate, poorly drawn face, mutation, deformed"
```

**Improve Quality**
```bash
# Add these to negative prompts for better results
"jpeg artifacts, compression artifacts, noisy, grainy, oversaturated, undersaturated, bad anatomy, extra limbs, missing limbs"
```

### Parameter Tuning

**Different Samplers**
- `euler`: Fast, good for general use
- `dpmpp_2m`: Higher quality, slower
- `ddim`: Deterministic results

**CFG Scale Effects**
- `0.8-1.2`: More creative, less constrained (good for Lightning LoRA)
- `2-7`: More precise, follows prompt closely
- `8-15`: Very strict, may reduce creativity

### Resolution Experiments

**Portrait Mode (768x1024)**
```json
{
  "input": {
    "workflow": {
      "58": {
        "inputs": {
          "width": 768,
          "height": 1024,
          "batch_size": 1
        },
        "class_type": "EmptySD3LatentImage"
      }
    }
  }
}
```

**Landscape Mode (1024x768)**
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
    }
  }
}
```

**Square Format (512x512)**
```json
{
  "input": {
    "workflow": {
      "58": {
        "inputs": {
          "width": 512,
          "height": 512,
          "batch_size": 4
        },
        "class_type": "EmptySD3LatentImage"
      }
    }
  }
}
```

## 🎪 Special Effects & Styles

### Photography Styles

**Professional Photography**
```
Professional architectural photography, sharp focus, perfect lighting, high dynamic range, commercial quality, detailed textures, color graded, compositionally balanced, expert level photography.
```

**Vintage Photography**
```
1970s vintage street photography, film grain, slight color fading, authentic period details, natural lighting, candid moment captured, nostalgic atmosphere, medium format camera quality.
```

**Drone Photography**
```
Aerial drone shot of coastal city, top-down perspective, geometric street patterns, ocean meeting urban landscape, golden hour lighting, professional drone photography, high resolution, expansive view.
```

### Art Styles

**Impressionism**
```
Impressionist painting of Paris street, loose brushstrokes, vibrant colors broken into dabs of paint, light and shadow effects, Monet style, artistic interpretation, painterly texture.
```

**Concept Art**
```
Video game concept art of fantasy city environment, digital painting style, dramatic lighting, atmospheric effects, detailed architecture, game development quality, matte painting technique.
```

## 🔄 Batch Processing

### Generate Multiple Variations

**Different Seeds**
```bash
# Generate 4 variations with different seeds
for seed in 12345 67890 11111 22222; do
  curl -X POST http://localhost:8188/runsync \
    -H "Content-Type: application/json" \
    -d "{
      \"input\": {
        \"workflow\": {
          \"3\": {
            \"inputs\": {
              \"seed\": $seed,
              \"steps\": 8,
              \"cfg\": 1.0,
              \"sampler_name\": \"euler\",
              \"scheduler\": \"simple\",
              \"model\": [\"66\", 0],
              \"positive\": [\"6\", 0],
              \"negative\": [\"7\", 0],
              \"latent_image\": [\"58\", 0]
            },
            \"class_type\": \"KSampler\"
          },
          \"6\": {
            \"inputs\": {
              \"text\": \"Cyberpunk city street with neon lights\",
              \"clip\": [\"38\", 0]
            },
            \"class_type\": \"CLIPTextEncode\"
          },
          \"58\": {
            \"inputs\": {
              \"width\": 1328,
              \"height\": 1328,
              \"batch_size\": 1
            },
            \"class_type\": \"EmptySD3LatentImage\"
          }
        }
      }
    }"
done
```

### Parameter Variations

**Experiment with Different Settings**
```bash
# Test different CFG values
for cfg in 0.8 1.0 1.2 1.5; do
  curl -X POST http://localhost:8188/runsync \
    -H "Content-Type: application/json" \
    -d "{\"input\":{\"workflow\":{\"3\":{\"inputs\":{\"cfg\":$cfg}}}}}"
done
```

## 🎭 Thematic Collections

### Theme: "Neon Cities"

**Tokuro Style**
```
Tokyo-style cyberpunk district, narrow alleyways filled with neon signs in Japanese characters, vending machines glowing with colorful lights, rainy night, reflections on wet asphalt, blade runner aesthetic, future noir.
```

**Shanghai Bund**
```
Shanghai Bund at night, historic colonial buildings illuminated alongside modern skyscrapers, Huangpu River reflecting city lights, boats on water, mix of architectural styles, vibrant blue and gold lighting, metropolitan elegance.
```

**Seoul Gangnam**
```
Seoul Gangnam district, modern Korean architecture, massive LED displays, K-pop culture elements, colorful fashion boutiques, busy street life, contemporary urban design, bright pink and blue lighting scheme.
```

### Theme: "Historic Cities"

**Ancient Rome**
```
Ancient Rome during golden hour, Roman Colosseum with detailed architecture, cobblestone streets, togas and ancient clothing, warm Mediterranean lighting, historical accuracy, cinematic historical drama.
```

**Medieval European Town**
```
Medieval European town square, Gothic cathedral spires, timber-framed houses, cobblestone streets, market stalls with colorful awnings, Renaissance festival atmosphere, warm afternoon light.
```

## 🛠️ Technical Workflows

### Image-to-Image (Advanced)

**Style Transfer Concept**
```json
{
  "input": {
    "workflow": {
      "6": {
        "inputs": {
          "text": "Transform this photo into cyberpunk style, neon colors, futuristic elements",
          "clip": ["38", 0]
        },
        "class_type": "CLIPTextEncode"
      },
      "57": {
        "inputs": {
          "image": "input_image_base64",
          "upload": "image"
        },
        "class_type": "LoadImage"
      }
    }
  }
}
```

### ControlNet Integration (Future Enhancement)

**Sketch to Image**
```json
{
  "input": {
    "workflow": {
      "controlnet": {
        "inputs": {
          "image": "sketch_base64",
          "strength": 0.8,
          "control_mode": "balanced"
        },
        "class_type": "ControlNetLoader"
      }
    }
  }
}
```

## 💡 Pro Tips & Best Practices

### Prompt Writing Guidelines

1. **Be Specific**: Instead of "city", use "neo-Tokyo district with tall skyscrapers"
2. **Include Lighting**: "golden hour", "dramatic shadows", "neon glow"
3. **Add Style**: "photorealistic", "digital art", "cinematic"
4. **Specify Mood**: "serene", "chaotic", "mysterious", "vibrant"
5. **Technical Details**: "8K resolution", "professional photography", "HDR"

### Common Mistakes to Avoid

❌ **Too Vague**: "a nice picture of a city"
✅ **Specific**: "Hong Kong street at night with neon signs reflecting on wet pavement"

❌ **Conflicting Elements**: "minimalist and ornate detailed"
✅ **Consistent Style**: "minimalist architectural photography with clean lines"

❌ **Too Many Styles**: "photo, painting, drawing, cartoon"
✅ **Single Style**: "professional architectural photography"

### Quality Enhancement

**For Better Results:**
1. **Use Descriptive Adjectives**: "vibrant", "serene", "dramatic", "ethereal"
2. **Include Technical Terms**: "depth of field", "HDR", "rule of thirds"
3. **Specify Time of Day**: "golden hour", "blue hour", "midday sun"
4. **Add Weather**: "misty morning", "afternoon rain", "clear night sky"
5. **Mention Equipment**: "shot on 8K camera", "drone photography"

### Workflow Optimization

**Speed vs Quality:**
- **Fastest**: 4 steps, CFG 0.8, lower resolution
- **Balanced**: 8 steps, CFG 1.0, 1024x1024 (default)
- **Highest Quality**: 20+ steps, CFG 2-7, high resolution

**Memory Management:**
- Use smaller batch sizes for lower VRAM
- Reduce resolution for memory constraints
- Clear cache between large generations

## 📚 Example Library

### Copy-Paste Ready Examples

**Urban Photography**
```bash
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "workflow": {
        "6": {
          "inputs": {
            "text": "Professional architectural photography of modern glass skyscraper during golden hour, geometric patterns, clean lines, urban sophistication, high-end real estate photography",
            "clip": ["38", 0]
          },
          "class_type": "CLIPTextEncode"
        },
        "7": {
          "inputs": {
            "text": "blurry, low quality, distorted, oversaturated, amateur photography, bad composition",
            "clip": ["38", 0]
          },
          "class_type": "CLIPTextEncode"
        },
        "3": {
          "inputs": {
            "seed": 12345,
            "steps": 8,
            "cfg": 1.0,
            "sampler_name": "euler",
            "scheduler": "simple",
            "denoise": 1.0,
            "model": ["66", 0],
            "positive": ["6", 0],
            "negative": ["7", 0],
            "latent_image": ["58", 0]
          },
          "class_type": "KSampler"
        },
        "58": {
          "inputs": {
            "width": 1328,
            "height": 1328,
            "batch_size": 1
          },
          "class_type": "EmptySD3LatentImage"
        }
      }
    }
  }'
```

**Artistic Creation**
```bash
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "workflow": {
        "6": {
          "inputs": {
            "text": "Futuristic cyberpunk city with floating gardens, bioluminescent lighting, digital art style, vibrant purple and blue color scheme, concept art for video game",
            "clip": ["38", 0]
          },
          "class_type": "CLIPTextEncode"
        },
        "3": {
          "inputs": {
            "seed": 54321,
            "steps": 8,
            "cfg": 1.2,
            "sampler_name": "euler",
            "scheduler": "simple",
            "denoise": 1.0,
            "model": ["66", 0],
            "positive": ["6", 0],
            "negative": ["7", 0],
            "latent_image": ["58", 0]
          },
          "class_type": "KSampler"
        },
        "58": {
          "inputs": {
            "width": 1024,
            "height": 768,
            "batch_size": 1
          },
          "class_type": "EmptySD3LatentImage"
        }
      }
    }
  }'
```

---

## 🎨 Next Steps

### Experiment and Create
- Try different prompt combinations
- Explore various artistic styles
- Share your best results
- Develop your own signature style

### Advanced Topics
- **Custom LoRA models** for specific styles
- **Fine-tuning** on your own datasets
- **Integration** with web applications
- **Automation** for batch processing

### Community & Inspiration
- **Share your creations** with the community
- **Learn from others** successful prompts
- **Contribute** examples and techniques
- **Stay updated** with model improvements

---

**Happy Creating! 🎨✨**

Remember that prompt engineering is both art and science. Experiment, iterate, and don't be afraid to try unconventional combinations. The Qwen Image Model rewards creative and specific prompts!