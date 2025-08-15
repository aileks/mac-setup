#!/bin/zsh

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

DOTFILES_REPO="https://github.com/aileks/mac-setup.git"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_SUFFIX=".backup.$(date +%Y%m%d_%H%M%S)"

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

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

cleanup_on_error() {
    log_error "Script failed. Check the output above for details."
    exit 1
}

trap cleanup_on_error ERR

command_exists() {
    command -v "$1" &>/dev/null
}

is_installed() {
    brew list --formula "$1" &>/dev/null 2>&1 || brew list --cask "$1" &>/dev/null 2>&1
}

wait_for_user() {
    local message="$1"
    echo -e "${YELLOW}$message${NC}"
    read -p "Press Enter to continue..."
}

TOTAL_STEPS=9
CURRENT_STEP=0

show_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    log_step "[$CURRENT_STEP/$TOTAL_STEPS] $1"
}

check_system() {
    show_progress "Checking system requirements"

    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only."
        exit 1
    fi

    log_info "Running on macOS $(sw_vers -productVersion)"

    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

install_xcode_tools() {
    show_progress "Installing Xcode Command Line Tools"

    if ! xcode-select -p &>/dev/null; then
        log_warning "Xcode Command Line Tools not found!"
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install
        wait_for_user "Please complete the Xcode Command Line Tools installation and then"

        if ! xcode-select -p &>/dev/null; then
            log_error "Xcode Command Line Tools installation failed or incomplete"
            exit 1
        fi
    fi

    log_success "Xcode Command Line Tools are installed"
}

install_homebrew() {
    show_progress "Setting up Homebrew"

    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        if [[ $(uname -m) == "arm64" ]]; then
            if ! grep -q "/opt/homebrew/bin/brew" "$HOME/.zprofile" 2>/dev/null; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
            fi
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        log_success "Homebrew installed successfully"
    else
        log_info "Homebrew already installed, updating..."
        brew update
        log_success "Homebrew updated"
    fi

    log_info "Adding Homebrew taps..."
    brew tap nikitabobko/tap &>/dev/null || true
    brew tap FelixKratz/formulae &>/dev/null || true
}

install_cli_tools() {
    show_progress "Installing command line tools"

    local cli_tools=(git curl wget tmux mise ripgrep fzf trash-cli fastfetch tree btop jq gh bash eza zoxide)
    local failed_installs=()

    for tool in "${cli_tools[@]}"; do
        if is_installed "$tool"; then
            log_info "$tool is already installed, skipping..."
        else
            log_info "Installing $tool..."
            if brew install "$tool" &>/dev/null; then
                log_success "$tool installed successfully"
            else
                log_warning "Failed to install $tool"
                failed_installs+=("$tool")
            fi
        fi
    done

    if [[ ${#failed_installs[@]} -gt 0 ]]; then
        log_warning "Some tools failed to install: ${failed_installs[*]}"
    fi
}

install_oh_my_zsh() {
    show_progress "Setting up Oh-My-Zsh"

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh-My-Zsh..."
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        log_success "Oh-My-Zsh installed successfully"
    else
        log_info "Oh-My-Zsh already installed"
    fi

    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi

    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting" ]]; then
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
            "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting"
    fi
}

install_miniconda() {
    show_progress "Setting up Miniconda"

    if ! command_exists conda; then
        log_info "Installing Miniconda..."

        local install_dir="$HOME/.local/bin"
        mkdir -p "$install_dir"

        local conda_url
        if [[ $(uname -m) == "arm64" ]]; then
            conda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
        else
            conda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
        fi

        local installer_path="$HOME/miniconda.sh"
        if curl -fsSL -o "$installer_path" "$conda_url"; then
            bash "$installer_path" -b -p "$install_dir/miniconda3"
            rm "$installer_path"

            "$install_dir/miniconda3/bin/conda" init zsh
            log_success "Miniconda installed successfully"
        else
            log_error "Failed to download Miniconda installer"
            return 1
        fi
    else
        log_info "Conda already installed"
    fi
}

install_gui_apps() {
    show_progress "Installing GUI applications"

    local cask_apps=(
        "tg-pro" "element" "ghostty" "zed" "aerospace" "deezer" "freetube"
        "protonvpn" "proton-mail" "proton-drive" "brave-browser" "notesnook"
        "font-adwaita" "font-adwaita-mono-nerd-font"
    )
    local failed_installs=()

    for app in "${cask_apps[@]}"; do
        if is_installed "$app"; then
            log_info "$app is already installed, skipping..."
        else
            log_info "Installing $app..."
            if brew install --cask "$app" &>/dev/null; then
                log_success "$app installed successfully"
            else
                log_warning "Failed to install $app"
                failed_installs+=("$app")
            fi
        fi
    done

    if [[ ${#failed_installs[@]} -gt 0 ]]; then
        log_warning "Some apps failed to install: ${failed_installs[*]}"
        log_info "You can try installing them manually later with: brew install --cask <app_name>"
    fi
}

setup_dotfiles() {
    if [[ "$TOTAL_STEPS" -gt 1 ]]; then
      show_progress "Setting up dotfiles"
    fi

    if [[ -d "$DOTFILES_DIR" ]]; then
        log_info "Dotfiles directory already exists, updating..."
        cd "$DOTFILES_DIR"
        if git pull origin main &>/dev/null; then
            log_success "Dotfiles updated successfully"
        else
            log_warning "Failed to update dotfiles, continuing with existing version"
        fi
        cd - &>/dev/null
    else
        log_info "Cloning dotfiles repository..."
        if git clone "$DOTFILES_REPO" "$DOTFILES_DIR" &>/dev/null; then
            log_success "Dotfiles cloned successfully"
        else
            log_error "Failed to clone dotfiles repository"
            return 1
        fi
    fi

    log_info "Creating symlinks for dotfiles..."
    local symlink_mappings=(
        "zsh/zshrc:$HOME/.zshrc"
        "tmux/tmux.conf:$HOME/.tmux.conf"
        "aerospace:$HOME/.config/aerospace"
        "borders:$HOME/.config/borders"
        "fastfetch:$HOME/.config/fastfetch"
        "ghostty:$HOME/.config/ghostty"
        "sketchybar:$HOME/.config/sketchybar"
        "skhd:$HOME/.config/skhd"
        "zed/settings.json:$HOME/.config/zed/settings.json"
        "zed/keymap.json:$HOME/.config/zed/keymap.json"
    )

    for mapping in "${symlink_mappings[@]}"; do
        local src_path="${mapping%%:*}"
        local dest_path="${mapping##*:}"
        local full_src_path="$DOTFILES_DIR/$src_path"

        if [[ -e "$full_src_path" ]]; then
            create_symlink "$full_src_path" "$dest_path"
        else
            log_warning "Source file/directory not found: $full_src_path - skipping symlink creation"
        fi
    done
}

create_symlink() {
    local src="$1"
    local dest="$2"
    local dest_dir

    dest_dir=$(dirname "$dest")
    if [[ ! -d "$dest_dir" ]]; then
        mkdir -p "$dest_dir"
        log_info "Created directory: $dest_dir"
    fi

    if [[ -e "$dest" && ! -L "$dest" ]] || [[ -L "$dest" && ! -e "$dest" ]]; then
         log_info "Backing up existing file/directory: $dest"
         mv "$dest" "${dest}${BACKUP_SUFFIX}"
    elif [[ -L "$dest" ]]; then
        log_info "Removing existing symlink: $dest"
        rm "$dest"
    fi

    if ln -s "$src" "$dest"; then
        log_success "Created symlink: $dest -> $src"
    else
        log_error "Failed to create symlink: $dest -> $src"
        return 1
    fi
}

update_dotfiles() {
    TOTAL_STEPS=1
    CURRENT_STEP=0

    show_progress "Updating and re-linking dotfiles"

    if ! command_exists git; then
        log_error "Git is not installed. Please install Git and try again, or run the full setup."
        exit 1
    fi
    log_info "Prerequisite check passed: Git is installed."

    setup_dotfiles

    echo
    log_success "Dotfiles have been updated and re-linked successfully."
    log_info "Restart your terminal or run 'source ~/.zshrc' to apply changes."
}

cleanup_and_finish() {
    show_progress "Cleaning up and finishing"

    log_info "Running Homebrew cleanup..."
    brew cleanup &>/dev/null

    log_success "macOS setup completed successfully!"
    echo
    log_info "Summary:"
    echo "  • Xcode Command Line Tools: $(xcode-select -p 2>/dev/null && echo "✓ Installed" || echo "✗ Not found")"
    echo "  • Homebrew: $(command_exists brew && echo "✓ Installed" || echo "✗ Not found")"
    echo "  • Oh-My-Zsh: $([[ -d "$HOME/.oh-my-zsh" ]] && echo "✓ Installed" || echo "✗ Not found")"
    echo "  • Conda: $(command_exists conda && echo "✓ Installed" || echo "✗ Not found")"
    echo "  • Dotfiles: $([[ -d "$DOTFILES_DIR" ]] && echo "✓ Configured" || echo "✗ Not found")"
    echo
    echo "Next steps:"
    echo "  1. Run 'brew doctor' to check for any issues"
    echo "  2. Restart your terminal or run 'source ~/.zshrc' to apply changes"
    echo "  3. Configure any installed applications as needed"

    local backup_zshrc
    backup_zshrc=$(find "$HOME" -maxdepth 1 -name ".zshrc.backup.*" -print -quit)
    if [[ -n "$backup_zshrc" ]]; then
        echo "  4. Your old .zshrc was backed up to: $backup_zshrc"
    fi

    echo
    log_warning "A REBOOT IS RECOMMENDED TO ENSURE ALL SYSTEM CHANGES TAKE EFFECT PROPERLY."
    echo
    read -r "?Would you like to reboot now? (y/N): "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Rebooting in 5 seconds... (Press Ctrl+C to cancel)"
        sleep 5
        log_warning "Rebooting now!"
        sudo reboot
    else
        log_info "Remember to reboot your system when convenient to complete the setup."
    fi
}

main() {
    echo -e "${YELLOW}Which would you like to do?${NC}"
    echo "  1) Perform a full macOS setup (installs tools, apps, and dotfiles)"
    echo "  2) Update and symlink dotfiles only"
    read -r "choice?Enter your choice (1 or 2): "
    echo

    case "$choice" in
        1)
            log_info "Starting full macOS setup..."
            check_system
            install_xcode_tools
            install_homebrew
            install_cli_tools
            install_oh_my_zsh
            install_miniconda
            install_gui_apps
            setup_dotfiles
            cleanup_and_finish
            ;;
        2)
            log_info "Starting dotfiles update..."
            update_dotfiles
            ;;
        *)
            log_error "Invalid choice. Please run the script again and enter 1 or 2."
            exit 1
            ;;
    esac
}

main "$@"
