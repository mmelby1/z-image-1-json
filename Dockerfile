# 1. Start from the specific base version
FROM runpod/worker-comfyui:5.5.1-base

# 2. UPDATE COMFYUI (CRITICAL FIX FOR Z-IMAGE)
# Z-Image support was added just days ago, so we must be on the absolute latest commit.
RUN cd /comfyui && \
    git config --global --add safe.directory /comfyui && \
    git checkout master && \
    git pull

# 3. Upgrade critical python dependencies for Qwen 3.4B
# We install 'accelerate', 'transformers', and 'sentencepiece' because the Qwen text encoder requires them.
# 'protobuf' is added because it's often a hidden dependency for loading safe tensors in new tokenizers.
RUN python -m pip install --no-cache-dir --upgrade \
    transformers \
    accelerate \
    sentencepiece \
    protobuf \
    safetensors

# 4. INSTALL CUSTOM NODES
RUN comfy-node-install \
    comfyui-manager \
    comfyui-kjnodes \
    comfyui_essentials \
    comfyui-logicutils

# 5. DOWNLOAD MODELS
# Text Encoder (Qwen 3.4B) - 7.6 GB
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors \
  --relative-path models/text_encoders \
  --filename qwen_3_4b.safetensors

# VAE (Autoencoder) - 319 MB
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors \
  --relative-path models/vae \
  --filename ae.safetensors

# Diffusion Model (Z-Image Turbo) - 11.7 GB
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors \
  --relative-path models/diffusion_models \
  --filename z_image_turbo_bf16.safetensors
