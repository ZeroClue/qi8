# RunPod Serverless Deployment Guide

Deploy your Qwen Image Model container on RunPod serverless infrastructure for scalable, pay-per-use AI image generation.

## Prerequisites

### Required Accounts
- **RunPod Account**: Sign up at [runpod.io](https://runpod.io)
- **Docker Hub Account**: For container registry access
- **GitHub Account**: For CI/CD pipeline (optional)

### Environment Requirements
- **Docker**: Installed and configured locally
- **Container**: `zeroclue/qi8-comfyui` built and pushed to Docker Hub
- **API Understanding**: Basic knowledge of REST APIs

## Step-by-Step Deployment

### Step 1: Prepare Your Container

#### 1.1 Build and Test Locally
```bash
# Pull the latest image
docker pull zeroclue/qi8-comfyui:latest

# Test locally first
docker run -p 8188:8188 zeroclue/qi8-comfyui:latest

# Test API endpoint
curl -X POST http://localhost:8188/runsync \
  -H "Content-Type: application/json" \
  -d @example-request.json
```

#### 1.2 Verify Container Health
```bash
# Check if models are loaded
docker logs <container_id> | grep "model"

# Test basic functionality
curl http://localhost:8188/system_stats
```

### Step 2: Create RunPod Serverless Template

#### 2.1 Navigate to RunPod Console
1. Log in to [RunPod Console](https://runpod.io/console)
2. Go to **Serverless** → **Templates**
3. Click **+ New Template**

#### 2.2 Configure Template Settings

**Basic Information**
- **Template Name**: `qwen-image-generator`
- **Description**: `Qwen Image Model for AI image generation`
- **Docker Image**: `zeroclue/qi8-comfyui:latest`

**Container Configuration**
```yaml
name: qwen-image-generator
image: zeroclue/qi8-comfyui:latest
ports:
  - "8188:8188"
```

**Environment Variables**
```
MODEL_DOWNLOAD_PARALLEL=true
COMFY_LOG_LEVEL=INFO
HF_TOKEN=your_huggingface_token_here
```

#### 2.3 Set Resource Requirements

**GPU Selection**
- **GPU Type**: A40 or A100 (recommended)
- **GPU Count**: 1
- **vCPU**: 4 cores
- **Memory**: 32GB
- **Storage**: 100GB

**Performance Notes**
- **Minimum**: 8GB VRAM GPU
- **Recommended**: 16GB+ VRAM for optimal performance
- **Cost**: ~$0.50-1.00 per generation depending on GPU

#### 2.4 Configure Network and Health

**Port Configuration**
- **Container Port**: `8188`
- **Protocol**: `HTTP`
- **Health Check**: `/system_stats`

**Timeout Settings**
- **Idle Timeout**: 300 seconds (5 minutes)
- **Request Timeout**: 120 seconds

#### 2.5 Scaling Configuration

**Autoscaling**
- **Min Instances**: 0 (cold start)
- **Max Instances**: 5
- **Cooldown Period**: 60 seconds

**Performance Optimization**
- **Concurrency**: 1 request per instance
- **Boot Time**: ~2-3 minutes (model loading)

### Step 3: Deploy and Test

#### 3.1 Deploy Template
1. Review all configuration settings
2. Click **Create Template**
3. Wait for deployment to complete

#### 3.2 Test Deployment
```bash
# Get your endpoint URL from RunPod console
ENDPOINT="https://your-endpoint.runpod.run"

# Test the endpoint
curl -X POST $ENDPOINT/runsync \
  -H "Content-Type: application/json" \
  -d @example-request.json
```

#### 3.3 Monitor Performance
- Check **Logs** tab for initialization
- Monitor **Metrics** for response times
- Verify **GPU utilization** in dashboard

### Step 4: Configure Environment Variables

#### 4.1 Production Environment
```bash
# Essential variables
MODEL_DOWNLOAD_PARALLEL=true
COMFY_LOG_LEVEL=WARNING  # Reduce log volume in production
SERVE_API_LOCALLY=true   # Enable local API serving
```

#### 4.2 Optional Variables
```bash
# Performance tuning
CUDA_VISIBLE_DEVICES=0
TORCH_CUDA_ARCH_LIST="8.0;8.6;8.9;9.0"

# Security
ALLOW_ORIGINS="https://yourdomain.com"
API_KEY_REQUIRED=true
```

### Step 5: Security Configuration

#### 5.1 Network Security
- **VPC Configuration**: Use private networking if available
- **Firewall Rules**: Restrict access to necessary IPs only
- **SSL/TLS**: Enable HTTPS endpoints

#### 5.2 Access Control
```json
{
  "allowed_origins": ["https://yourapp.com"],
  "rate_limit": {
    "requests_per_minute": 60,
    "burst_limit": 10
  },
  "api_key_required": true
}
```

## Configuration Options

### GPU Selection Guide

#### Entry Level (Development)
- **GPU**: RTX 4000 or similar
- **VRAM**: 8GB minimum
- **Cost**: Low
- **Performance**: Slower generation (15-20 seconds)

#### Production Grade
- **GPU**: A40 or A100
- **VRAM**: 16GB+ recommended
- **Cost**: Medium-High
- **Performance**: Fast generation (8-12 seconds)

#### High Volume
- **GPU**: Multiple A100 instances
- **VRAM**: 40GB+
- **Cost**: High
- **Performance**: Batch processing capability

### Memory and Storage Requirements

#### Minimum Requirements
- **System RAM**: 16GB
- **GPU VRAM**: 8GB
- **Storage**: 50GB

#### Recommended Configuration
- **System RAM**: 32GB+
- **GPU VRAM**: 16GB+
- **Storage**: 100GB+ (for models and cache)

### Performance Optimization

#### Generation Speed
- **8-step generation**: 8-12 seconds on A100
- **Batch processing**: Enable for multiple images
- **Model caching**: Models loaded once per instance

#### Cost Optimization
- **Idle timeout**: Adjust based on usage patterns
- **Autoscaling**: Configure appropriate limits
- **GPU selection**: Balance cost vs. performance

## Monitoring and Management

### Health Checks

#### API Endpoints
```bash
# System status
curl https://your-endpoint.runpod.run/system_stats

# Model availability
curl https://your-endpoint.runpod.run/model_status

# Queue status
curl https://your-endpoint.runpod.run/queue_status
```

#### Custom Health Check
```python
import requests

def health_check(endpoint):
    try:
        response = requests.get(f"{endpoint}/system_stats", timeout=10)
        return response.status_code == 200
    except:
        return False
```

### Performance Metrics

#### Key Metrics to Monitor
- **Response Time**: Average generation time
- **Success Rate**: Percentage of successful generations
- **GPU Utilization**: GPU usage percentage
- **Memory Usage**: RAM and VRAM consumption
- **Error Rate**: Failed requests percentage

#### Monitoring Dashboard
```python
# Example monitoring setup
metrics = {
    "generation_time": "histogram",
    "success_rate": "percentage",
    "gpu_utilization": "gauge",
    "request_count": "counter"
}
```

### Log Management

#### Container Logs
```bash
# View real-time logs
runpod logs <template_id> --follow

# Filter for errors
runpod logs <template_id> | grep "ERROR"

# Monitor model loading
runpod logs <template_id> | grep "model"
```

#### Log Analysis
```python
# Parse log entries
def parse_generation_logs(logs):
    generations = []
    for log in logs:
        if "generation completed" in log:
            generations.append({
                "timestamp": log.timestamp,
                "duration": log.duration,
                "status": log.status
            })
    return generations
```

### Alerting

#### Set Up Alerts
- **High Error Rate**: >5% failure rate
- **Long Response Times**: >30 seconds
- **GPU Memory Issues**: VRAM >90% usage
- **Instance Failures**: Container restarts

#### Alert Configuration
```yaml
alerts:
  high_error_rate:
    condition: error_rate > 0.05
    duration: 5m
    action: send_notification

  slow_generation:
    condition: avg_generation_time > 30s
    duration: 10m
    action: scale_up
```

## Troubleshooting

### Common Issues

#### 1. Cold Start Delays
**Problem**: First request takes 2-3 minutes
**Solution**:
- Enable warm instances
- Use faster GPU types
- Optimize model loading

#### 2. Memory Issues
**Problem**: CUDA out of memory errors
**Solution**:
- Reduce batch size
- Lower image resolution
- Upgrade to higher VRAM GPU

#### 3. Slow Generation
**Problem**: Generation takes >30 seconds
**Solution**:
- Check GPU type
- Verify model optimization
- Monitor system resources

#### 4. Connection Errors
**Problem**: API endpoint not reachable
**Solution**:
- Verify port configuration
- Check network settings
- Review health check configuration

### Debugging Commands

#### Container Diagnostics
```bash
# Check container status
docker ps | grep qi8

# Inspect container resources
docker stats <container_id>

# View container logs
docker logs <container_id> --tail 100
```

#### Network Testing
```bash
# Test endpoint connectivity
curl -I https://your-endpoint.runpod.run

# Test API functionality
curl -X POST https://your-endpoint.runpod.run/runsync \
  -H "Content-Type: application/json" \
  -d '{"test": true}'
```

## Scaling and Cost Management

### Scaling Strategies

#### Horizontal Scaling
- **Multiple Instances**: Configure max instances > 1
- **Load Balancing**: Use RunPod's built-in load balancing
- **Geographic Distribution**: Deploy to multiple regions

#### Vertical Scaling
- **GPU Upgrades**: Move to higher performance GPUs
- **Memory Allocation**: Increase RAM and VRAM
- **Storage Expansion**: Add more disk space

### Cost Optimization

#### Right-Sizing
- **GPU Selection**: Choose appropriate GPU for workload
- **Timeout Configuration**: Optimize idle timeout
- **Autoscaling**: Configure min/max instances appropriately

#### Usage Monitoring
- **Cost Tracking**: Monitor daily/weekly costs
- **Usage Patterns**: Analyze peak usage times
- **Optimization**: Adjust configuration based on usage

### Budget Planning

#### Cost Estimates
- **A100 GPU**: ~$0.80/hour
- **A40 GPU**: ~$0.60/hour
- **RTX 4000**: ~$0.40/hour
- **Per Generation**: ~$0.01-0.05 depending on GPU

#### Budget Alerts
- Set spending limits in RunPod console
- Configure cost alerts for notifications
- Regular cost review and optimization

## Advanced Configuration

### Custom Templates

#### Multi-Model Support
```yaml
templates:
  qwen-standard:
    image: zeroclue/qi8-comfyui:latest
    gpu: a40
    memory: 32gb

  qwen-performance:
    image: zeroclue/qi8-comfyui:latest
    gpu: a100
    memory: 64gb
```

#### Environment-Specific Configs
```yaml
environments:
  development:
    min_instances: 1
    gpu: rtx4000
    debug: true

  production:
    min_instances: 0
    max_instances: 10
    gpu: a100
    monitoring: true
```

### Integration Examples

#### Webhook Integration
```python
import requests

def trigger_generation(prompt):
    webhook_url = "https://your-endpoint.runpod.run/webhook"
    payload = {
        "input": {
            "prompt": prompt,
            "webhook": "https://your-app.com/webhook"
        }
    }
    response = requests.post(webhook_url, json=payload)
    return response.json()
```

#### Batch Processing
```python
def batch_generate(prompts):
    endpoint = "https://your-endpoint.runpod.run/runsync"
    results = []

    for prompt in prompts:
        payload = {"input": {"workflow": create_workflow(prompt)}}
        response = requests.post(endpoint, json=payload)
        results.append(response.json())

    return results
```

---

## Support and Resources

### Documentation
- **API Reference**: [API.md](API.md)
- **Usage Examples**: [EXAMPLES.md](EXAMPLES.md)
- **Setup Guide**: [SETUP.md](SETUP.md)

### Community
- **RunPod Discord**: Community support
- **GitHub Issues**: Report bugs and request features
- **Documentation**: Updates and best practices

### Getting Help
1. Check logs for error messages
2. Verify configuration in RunPod console
3. Review troubleshooting section above
4. Contact RunPod support for platform issues
5. Open GitHub issue for container-specific problems