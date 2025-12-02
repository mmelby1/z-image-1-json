# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

# make sure we have wget (usually already there, but this is safe)
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# set working dir to comfyui root
WORKDIR /comfyui

# create model directories (if they don't already exist)
RUN mkdir -p /comfyui/models/text_encoders \
             /comfyui/models/vae \
             /comfyui/models/diffusion_models

# --------------------------------------------------------------------
# download Z-Image-Turbo models into ComfyUI's model folders
# (using the same URLs as the official Z-Image Turbo / DO tutorial)
# --------------------------------------------------------------------

# Text encoder (Qwen)
RUN cd /comfyui/models/text_encoders && \
    wget -O qwen_3_4b.safetensors \
    https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors

# VAE (Flux 1 VAE)
RUN cd /comfyui/models/vae && \
    wget -O ae.safetensors \
    https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors

# Diffusion model
RUN cd /comfyui/models/diffusion_models && \
    wget -O z_image_turbo_bf16.safetensors \
    https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors

# --------------------------------------------------------------------
# debug: list model files + sizes during the image build
# this will show up in the same build logs you pasted earlier
# --------------------------------------------------------------------
RUN echo "=== DEBUG: /comfyui/models contents ===" && \
    ls -lh /comfyui/models && \
    echo "=== DEBUG: text_encoders ===" && \
    ls -lh /comfyui/models/text_encoders && \
    echo "=== DEBUG: vae ===" && \
    ls -lh /comfyui/models/vae && \
    echo "=== DEBUG: diffusion_models ===" && \
    ls -lh /comfyui/models/diffusion_models

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
