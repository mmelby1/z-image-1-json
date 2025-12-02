# 1. Start from the specific base version
FROM runpod/worker-comfyui:5.5.1-base

# 2. UPDATE COMFTUI (CRITICAL FIX FOR Z-IMAGE)
# Z-Image Turbo support is brand new. We must update ComfyUI to the latest commit.
RUN cd /comfyui && \
    git config --global --add safe.directory /comfyui && \
    git pull

# 3. Upgrade critical python dependencies
RUN python -m pip install --no-cache-dir --upgrade safetensors

# 4. INSTALL CUSTOM NODES
RUN comfy-node-install \
    comfyui-manager \
    comfyui-kjnodes \
    comfyui_essentials \
    comfyui-logicutils

# 5. DOWNLOAD MODELS

# Node 8: CLIPLoader
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors \
  --relative-path models/text_encoders \
  --filename qwen_3_4b.safetensors

# Node 7: VAELoader (Using Public Comfy-Org URL)
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors \
  --relative-path models/vae \
  --filename ae.safetensors

# Node 6: UNETLoader
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors \
  --relative-path models/diffusion_models \
  --filename z_image_turbo_bf16.safetensors
