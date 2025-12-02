# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

# make sure we have a new safetensors build
RUN python -m pip install --no-cache-dir --upgrade safetensors

# download models into comfyui
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors \
  --relative-path models/text_encoders \
  --filename qwen_3_4b.safetensors

RUN comfy model download \
  --url https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors \
  --relative-path models/vae \
  --filename ae.safetensors

RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors \
  --relative-path models/diffusion_models \
  --filename z_image_turbo_bf16.safetensors
