# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

ARG HF_TOKEN

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail comfyui-image-saver@1.16.0

# Models are now downloaded at runtime by check-models.sh script
# This makes the Docker build faster and images smaller

# copy custom scripts to root directory to override base image
COPY check-models.sh /check-models.sh
COPY check-models-parallel.sh /check-models-parallel.sh
COPY start.sh /start.sh

# make scripts executable (REQUIRED for execution)
RUN chmod +x /check-models.sh /check-models-parallel.sh /start.sh

# Add labels for metadata
LABEL maintainer="thezeroclue@gmail.com" \
      version="1.0.0" \
      description="ComfyUI worker with model validation and parallel downloads" \
      source="https://github.com/ZeroClue/qi8"

# Set the entrypoint
ENTRYPOINT ["/start.sh"]
