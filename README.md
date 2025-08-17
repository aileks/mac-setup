# macOS Setup Script & Dotfiles

Automated setup script for macOS that installs essential software and configures dotfiles.

## Usage

> [!NOTE]
> If there are any applications you do not want to install, be sure to comment them out in the `install.zsh` script.

```sh
zsh -c "$(curl -fsSL https://aileks.dev/mac)"

# Or clone the repo
git clone https://github.com/aileks/dotfiles.git && cd dotfiles
./install.zsh
```
