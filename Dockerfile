FROM ollama/ollama:0.9.6

ENV API_BASE_URL=http://127.0.0.1:11434
ENV MODEL_NAME_AT_ENDPOINT=qwen2.5:1.5b

# Install system dependencies and Node.js
RUN apt-get update && apt-get install -y \
  curl gnupg bash \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g pnpm \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY .env.docker package.json pnpm-lock.yaml ./
RUN pnpm install

COPY . .
RUN pnpm run build

# Copy and set startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

# Reset the entrypoint to bash
ENTRYPOINT ["/bin/bash"]

# Run the startup script
CMD ["/start.sh"]