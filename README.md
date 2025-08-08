# macOS Setup Script & Dotfiles

Automated setup script for macOS that installs essential software and configures dotfiles.

## Usage

> [!NOTE]
> If there are any applications you do not want to install, be sure to comment them out in the `install.zsh` script.

```bash
git clone https://github.com/aileks/macdots.git
cd macdots && ./install.sh
```

## Features

- Bootstraps Homebrew if needed
- Automatically installs essential applications
- Backs up existing dotfile directories
- Works on Intel and Apple Silicon Macs
- Colored output with status messages

## Post-installation

1. Restart terminal or run `source ~/.zshrc`
2. Run `brew doctor` to check for issues
