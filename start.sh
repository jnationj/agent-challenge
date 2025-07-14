#!/bin/bash

echo "▶ Starting Ollama..."
ollama serve &

echo "⏳ Waiting for Ollama to be ready..."
until curl -s http://127.0.0.1:11434 > /dev/null; do
  sleep 1
done

echo "✅ Ollama is up. Pulling model: $MODEL_NAME_AT_ENDPOINT"
ollama pull "$MODEL_NAME_AT_ENDPOINT"

echo "🚀 Starting the agent app..."
pnpm run dev