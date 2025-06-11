#!/bin/bash

# Setup script for AI Assistant (CodeCompanion + Avante)
# This script helps configure Ollama and environment variables

set -e

echo "🚀 Setting up AI Assistant for Neovim..."

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "❌ Ollama is not installed. Installing Ollama..."
    curl -fsSL https://ollama.ai/install.sh | sh
    echo "✅ Ollama installed successfully"
else
    echo "✅ Ollama is already installed"
fi

# Start Ollama service if not running
if ! pgrep -x "ollama" > /dev/null; then
    echo "🔄 Starting Ollama service..."
    ollama serve &
    sleep 5
    echo "✅ Ollama service started"
fi

# Pull recommended models
echo "📥 Pulling recommended Ollama models..."
models=("deepseek-coder-v2:latest" "codellama:latest" "llama3.1:latest" "qwen2.5-coder:latest")

for model in "${models[@]}"; do
    echo "Pulling $model..."
    ollama pull "$model" || echo "⚠️  Failed to pull $model (you can install it later)"
done

echo "✅ Model installation completed"

# Setup environment variables
echo "🔧 Setting up environment variables..."

# Create/update shell configuration
SHELL_CONFIG="$HOME/.bashrc"
if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
fi

echo "" >> "$SHELL_CONFIG"
echo "# AI Assistant Environment Variables" >> "$SHELL_CONFIG"
echo "export OLLAMA_HOST=http://127.0.0.1:11434" >> "$SHELL_CONFIG"

# Check for Gemini API key
if [ -z "$GEMINI_API_KEY" ]; then
    echo "⚠️  GEMINI_API_KEY not found in environment."
    echo "📝 To use Google Gemini, you need to:"
    echo "   1. Get an API key from https://makersuite.google.com/app/apikey"
    echo "   2. Add it to your shell config:"
    echo "      echo 'export GEMINI_API_KEY=your_api_key_here' >> $SHELL_CONFIG"
    echo "   3. Restart your terminal or run: source $SHELL_CONFIG"
else
    echo "✅ GEMINI_API_KEY found in environment"
fi

echo "" >> "$SHELL_CONFIG"
echo "# Uncomment and set your Gemini API key below:" >> "$SHELL_CONFIG"
echo "# export GEMINI_API_KEY=your_api_key_here" >> "$SHELL_CONFIG"

echo "✅ Environment setup completed"

# Test Ollama connection
echo "🧪 Testing Ollama connection..."
if ollama list > /dev/null 2>&1; then
    echo "✅ Ollama is working correctly"
    echo "📋 Available models:"
    ollama list
else
    echo "❌ Ollama connection failed. Please check your installation."
fi

echo ""
echo "🎉 Setup completed!"
echo ""
echo "📖 Usage:"
echo "   • Ctrl+A        - Open CodeCompanion actions"
echo "   • Ctrl+C, C     - Open CodeCompanion chat"
echo "   • Ctrl+C, I     - Inline CodeCompanion"
echo "   • LocalLeader+A - Toggle CodeCompanion"
echo "   • Alt+L         - Accept Avante suggestion"
echo "   • Alt+]         - Next Avante suggestion"
echo "   • Alt+[         - Previous Avante suggestion"
echo ""
echo "🔄 Please restart your terminal or run: source $SHELL_CONFIG"
echo "🚀 Then restart Neovim to load the new configuration!"

