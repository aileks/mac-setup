#!/bin/zsh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only."
    exit 1
fi

log_info "Starting macOS setup..."

if ! xcode-select -p &>/dev/null; then
    log_warning "Xcode Command Line Tools not found!"
    echo
    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install
fi

if ! command -v brew &>/dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    log_success "Homebrew installed successfully"
else
    log_info "Homebrew already installed, updating..."
    brew update
fi

log_info "Adding Homebrew taps..."
brew tap nikitabobko/tap
brew tap FelixKratz/formulae

log_info "Installing command line tools..."
brew install git curl wget tmux mise ripgrep fzf tree jq gh

if [[ ! -d "$HOME/.Oh-My-Zsh" ]]; then
    log_info "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh-My-Zsh installed successfully"
else
    log_info "Oh-My-Zsh already installed"
fi

if ! command -v conda &>/dev/null; then
    log_info "Installing Miniconda..."

    mkdir -p $HOME/.local/bin

    if [[ $(uname -m) == "arm64" ]]; then
        CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
    else
        CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
    fi

    curl -o $HOME/miniconda.sh "$CONDA_URL"
    bash $HOME/miniconda.sh -b -p $HOME/.local/bin/miniconda3
    rm $HOME/miniconda.sh

    $HOME/.local/bin/miniconda3/bin/conda init zsh
    log_success "Miniconda installed successfully"
else
    log_info "Conda already installed"
fi

log_info "Installing GUI applications..."

CASK_APPS=(
    "tg-pro"
    "element"
    "ghostty"
    "zed-preview"
    "aerospace"
    "deezer"
    "freetube"
    "protonvpn"
    "proton-mail"
    "proton-drive"
    "zen"
    "notesnook"
    "font-adwaita"
    "font-adwaita-mono-nerd-font"
)

for app in "${CASK_APPS[@]}"; do
    if brew list --cask "$app" &>/dev/null; then
        log_info "$app is already installed, skipping..."
    else
        log_info "Installing $app..."
        brew install --cask "$app"
        log_success "$app installed successfully"
    fi
done

DOTFILES_DIR="$HOME/dotfiles"
if [[ -d "$DOTFILES_DIR" ]]; then
    log_info "Dotfiles directory already exists, updating..."
    cd "$DOTFILES_DIR"
    git pull origin main
else
    log_info "Cloning dotfiles repository..."
    git clone https://github.com/aileks/macdots.git "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

create_symlink() {
    local src="$1"
    local dest="$2"

    if [[ -L "$dest" ]]; then
        log_info "Removing existing symlink: $dest"
        rm "$dest"
    elif [[ -f "$dest" ]] || [[ -d "$dest" ]]; then
        log_info "Backing up existing file/directory: $dest"
        mv "$dest" "${dest}.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    mkdir -p "$(dirname "$dest")"

    ln -sf "$src" "$dest"
    log_success "Created symlink: $dest -> $src"
}

log_info "Creating symlinks for dotfiles..."

SYMLINK_MAPPINGS=(
    "zsh/zshrc:$HOME/.zshrc"
    "tmux/tmux.conf:$HOME/.tmux.conf"
    "aerospace:$HOME/.config/aerospace"
    "ghostty:$HOME/.config/ghostty"
    "sketchybar:$HOME/.config/sketchybar"
    "skhd:$HOME/.config/skhd"
    "zed/settings.json:$HOME/.config/zed/settings.json"
    "zed/keymap.json:$HOME/.config/zed/keymap.json"
)

for mapping in "${SYMLINK_MAPPINGS[@]}"; do
    src_path="${mapping%%:*}"
    dest_path="${mapping##*:}"
    full_src_path="$DOTFILES_DIR/$src_path"

    if [[ -e "$full_src_path" ]]; then
        create_symlink "$full_src_path" "$dest_path"
    else
        log_warning "Source file/directory not found: $full_src_path - skipping symlink creation"
    fi
done

log_info "Running Homebrew cleanup..."
brew cleanup

log_success "macOS setup completed successfully!"
echo
echo "Consider running \`brew doctor\` to check for any issues."
echo
log_info "Don't forget to restart your terminal or run 'source ~/.zshrc' to apply changes!"
