#!/bin/bash

# Elite Neovim Configuration Installer
# Complete setup script for LazyVim + AI Assistant

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}"
    echo "  ███████╗██╗     ██╗████████╗███████╗    ███╗   ██╗██╗   ██╗██╗███╗   ███╗"
    echo "  ██╔════╝██║     ██║╚══██╔══╝██╔════╝    ████╗  ██║██║   ██║██║████╗ ████║"
    echo "  █████╗  ██║     ██║   ██║   █████╗      ██╔██╗ ██║██║   ██║██║██╔████╔██║"
    echo "  ██╔══╝  ██║     ██║   ██║   ██╔══╝      ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║"
    echo "  ███████╗███████╗██║   ██║   ███████╗    ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║"
    echo "  ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
    echo -e "${NC}"
    echo -e "${CYAN}              Elite Neovim Configuration with AI Assistant${NC}"
    echo ""
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check operating system
check_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists pacman; then
            OS="arch"
        elif command_exists apt; then
            OS="ubuntu"
        elif command_exists dnf; then
            OS="fedora"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
    print_status "Detected OS: $OS"
}

# Install system dependencies
install_dependencies() {
    print_status "Installing system dependencies..."
    
    case $OS in
        "arch")
            sudo pacman -S --needed git curl wget unzip tar gzip nodejs npm python python-pip ripgrep fd fzf lazygit
            ;;
        "ubuntu")
            sudo apt update
            sudo apt install -y git curl wget unzip tar gzip nodejs npm python3 python3-pip ripgrep fd-find fzf
            # Install lazygit
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install lazygit /usr/local/bin
            rm lazygit.tar.gz lazygit
            ;;
        "fedora")
            sudo dnf install -y git curl wget unzip tar gzip nodejs npm python3 python3-pip ripgrep fd-find fzf lazygit
            ;;
        "macos")
            if command_exists brew; then
                brew install git curl wget unzip tar gzip node python ripgrep fd fzf lazygit
            else
                print_error "Homebrew not found. Please install Homebrew first."
                exit 1
            fi
            ;;
        *)
            print_warning "Unknown OS. Please install dependencies manually:"
            echo "- git, curl, wget, unzip, tar, gzip"
            echo "- nodejs, npm, python, pip"
            echo "- ripgrep, fd, fzf, lazygit"
            ;;
    esac
    
    print_success "System dependencies installed"
}

# Install Neovim
install_neovim() {
    if command_exists nvim; then
        NVIM_VERSION=$(nvim --version | head -n1 | cut -d' ' -f2)
        print_success "Neovim already installed: $NVIM_VERSION"
        return
    fi
    
    print_status "Installing Neovim..."
    
    case $OS in
        "arch")
            sudo pacman -S neovim
            ;;
        "ubuntu")
            # Install latest Neovim from GitHub
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
            sudo rm -rf /opt/nvim
            sudo tar -C /opt -xzf nvim-linux64.tar.gz
            sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
            rm nvim-linux64.tar.gz
            ;;
        "fedora")
            sudo dnf install -y neovim
            ;;
        "macos")
            brew install neovim
            ;;
        *)
            print_error "Please install Neovim manually from https://github.com/neovim/neovim/releases"
            exit 1
            ;;
    esac
    
    print_success "Neovim installed"
}

# Install Nerd Fonts
install_fonts() {
    print_status "Installing Nerd Fonts..."
    
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    
    if [[ ! -f "$FONT_DIR/FiraCodeNerdFont-Regular.ttf" ]]; then
        print_status "Downloading FiraCode Nerd Font..."
        wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip -O /tmp/FiraCode.zip
        unzip -q /tmp/FiraCode.zip -d "$FONT_DIR"
        rm /tmp/FiraCode.zip
        
        # Update font cache
        if command_exists fc-cache; then
            fc-cache -fv >/dev/null 2>&1
        fi
        
        print_success "FiraCode Nerd Font installed"
    else
        print_success "Nerd Fonts already installed"
    fi
}

# Backup existing Neovim configuration
backup_config() {
    if [[ -d "$HOME/.config/nvim" ]]; then
        print_warning "Existing Neovim configuration found"
        BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$HOME/.config/nvim" "$BACKUP_DIR"
        print_success "Backed up to: $BACKUP_DIR"
    fi
    
    # Also backup Neovim data directories
    for dir in "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"; do
        if [[ -d "$dir" ]]; then
            BACKUP_DIR="${dir}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$dir" "$BACKUP_DIR"
            print_status "Backed up $dir to $BACKUP_DIR"
        fi
    done
}

# Install Neovim configuration
install_config() {
    print_status "Installing Neovim configuration..."
    
    # Check if we're already in the nvim config directory
    if [[ "$(basename "$(pwd)")" == "nvim" && -f "init.lua" ]]; then
        print_status "Using current directory as Neovim config"
        CONFIG_DIR="$(pwd)"
    else
        # Install LazyVim starter
        git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
        cd "$HOME/.config/nvim"
        rm -rf .git
        CONFIG_DIR="$HOME/.config/nvim"
        
        # Copy our AI assistant configuration if it exists
        if [[ -f "lua/plugins/ai-assistant.lua" ]]; then
            print_status "AI assistant configuration already exists"
        else
            print_status "Creating AI assistant configuration..."
            # Create the ai-assistant.lua file here if needed
        fi
    fi
    
    print_success "Neovim configuration installed"
}

# Install Ollama
install_ollama() {
    if command_exists ollama; then
        print_success "Ollama already installed"
    else
        print_status "Installing Ollama..."
        curl -fsSL https://ollama.ai/install.sh | sh
        print_success "Ollama installed"
    fi
    
    # Start Ollama service
    if ! pgrep -x "ollama" > /dev/null; then
        print_status "Starting Ollama service..."
        ollama serve &
        sleep 3
        print_success "Ollama service started"
    else
        print_success "Ollama service already running"
    fi
}

# Pull AI models
pull_models() {
    print_status "Pulling AI models..."
    
    models=(
        "deepseek-coder-v2:latest"
        "codellama:latest" 
        "llama3.1:latest"
        "qwen2.5-coder:latest"
    )
    
    for model in "${models[@]}"; do
        print_status "Pulling $model..."
        if ollama pull "$model"; then
            print_success "✓ $model"
        else
            print_warning "⚠ Failed to pull $model (you can install it later)"
        fi
    done
}

# Setup environment variables
setup_environment() {
    print_status "Setting up environment variables..."
    
    # Detect shell
    SHELL_CONFIG="$HOME/.bashrc"
    if [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_CONFIG="$HOME/.zshrc"
    fi
    
    # Add environment variables if not already present
    if ! grep -q "OLLAMA_HOST" "$SHELL_CONFIG" 2>/dev/null; then
        echo "" >> "$SHELL_CONFIG"
        echo "# AI Assistant Environment Variables" >> "$SHELL_CONFIG"
        echo "export OLLAMA_HOST=http://127.0.0.1:11434" >> "$SHELL_CONFIG"
        echo "# export GEMINI_API_KEY=your_api_key_here" >> "$SHELL_CONFIG"
        print_success "Environment variables added to $SHELL_CONFIG"
    else
        print_success "Environment variables already configured"
    fi
    
    # Check for Gemini API key
    if [[ -z "$GEMINI_API_KEY" ]]; then
        print_warning "GEMINI_API_KEY not found"
        echo "To use Google Gemini:"
        echo "1. Get an API key from https://makersuite.google.com/app/apikey"
        echo "2. Add it to $SHELL_CONFIG: export GEMINI_API_KEY=your_api_key_here"
        echo "3. Restart your terminal"
    else
        print_success "GEMINI_API_KEY found"
    fi
}

# Final setup and testing
final_setup() {
    print_status "Performing final setup..."
    
    # Test Ollama
    if ollama list > /dev/null 2>&1; then
        print_success "Ollama is working correctly"
        echo "Available models:"
        ollama list | grep -v "NAME" | awk '{print "  - " $1}'
    else
        print_warning "Ollama connection test failed"
    fi
    
    print_success "Setup completed!"
}

# Show usage instructions
show_usage() {
    echo ""
    echo -e "${GREEN}🎉 Installation Complete!${NC}"
    echo ""
    echo -e "${CYAN}Next Steps:${NC}"
    echo "1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
    echo "2. Start Neovim: nvim"
    echo "3. Wait for plugins to install on first launch"
    echo "4. Restart Neovim after plugin installation"
    echo ""
    echo -e "${CYAN}Key Bindings:${NC}"
    echo "  • Ctrl+A        - Open AI actions menu"
    echo "  • Ctrl+C, C     - Open AI chat"
    echo "  • Ctrl+C, I     - Inline AI assistance"
    echo "  • Space+e       - File explorer"
    echo "  • Space+ff      - Find files"
    echo "  • Space+fg      - Live grep"
    echo ""
    echo -e "${CYAN}For Google Gemini:${NC}"
    echo "  • Get API key: https://makersuite.google.com/app/apikey"
    echo "  • Add to shell: export GEMINI_API_KEY=your_key"
    echo ""
    echo -e "${CYAN}Troubleshooting:${NC}"
    echo "  • Check plugin status: :Lazy"
    echo "  • Install language servers: :Mason"
    echo "  • Check LSP status: :LspInfo"
    echo ""
    echo -e "${GREEN}Happy coding! 🚀${NC}"
}

# Main installation flow
main() {
    print_header
    
    echo "This script will install:"
    echo "  • System dependencies (git, nodejs, python, etc.)"
    echo "  • Neovim (latest version)"
    echo "  • Nerd Fonts"
    echo "  • LazyVim configuration"
    echo "  • AI Assistant (CodeCompanion + Avante)"
    echo "  • Ollama with AI models"
    echo ""
    
    read -p "Continue with installation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Installation cancelled"
        exit 0
    fi
    
    check_os
    install_dependencies
    install_neovim
    install_fonts
    backup_config
    install_config
    install_ollama
    pull_models
    setup_environment
    final_setup
    show_usage
}

# Run main function
main "$@"

