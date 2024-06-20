#!/bin/bash

docker run -d --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:rocm
#docker exec -it ollama ollama run llama3
#docker exec -it ollama ollama pull qwen2
#docker exec -it ollama ollama pull qwen2:1.5b
docker exec -it ollama ollama pull deepseek-coder-v2:236b
docker exec -it ollama ollama pull deepseek-coder-v2:16b 
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
