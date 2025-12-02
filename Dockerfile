# 1. Start from the specific base version
FROM runpod/worker-comfyui:5.5.1-base

# 2. Upgrade critical python dependencies
# New models like Z-Image/Flux often require the latest safetensors library
RUN python -m pip install --no-cache-dir --upgrade safetensors

# 3. INSTALL CUSTOM NODES
# Based on your workflow, these are the recommended support nodes.
# 'ModelSamplingAuraFlow' is included in ComfyUI Core in this base version,
# but we install 'manager' and 'essentials' to handle any auxiliary logic.
RUN comfy-node-install \
    comfyui-manager \
    comfyui-kjnodes \
    comfyui_essentials \
    comfyui-logicutils

# 4. DOWNLOAD MODELS (Matched to your JSON IDs)

# Node 8: CLIPLoader expects 'qwen_3_4b.safetensors'
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors \
  --relative-path models/text_encoders \
  --filename qwen_3_4b.safetensors

# Node 7: VAELoader expects 'ae.safetensors'
# FIXED: Changed URL to Comfy-Org public repo to avoid "Unauthorized" error
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors \
  --relative-path models/vae \
  --filename ae.safetensors

# Node 6: UNETLoader expects 'z_image_turbo_bf16.safetensors'
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors \
  --relative-path models/diffusion_models \
  --filename z_image_turbo_bf16.safetensors
