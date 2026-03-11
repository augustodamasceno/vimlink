#!/bin/bash
# Vimlink installer — sets up Vim and/or Neovim configurations.
#
# Copyright (c) 2015-2026, Augusto Damasceno.
# All rights reserved.
#
# SPDX-License-Identifier: BSD-2-Clause
#
#  This script:
#    Installs Vim and/or Neovim setups (both by default).
#    Backs up existing config files before overwriting.
#    Downloads and installs a shared English dictionary
#      from Hunspell English Dictionaries.
#
#  Usage:
#    bash install.sh              # install both (default)
#    bash install.sh --vim        # install only Vim
#    bash install.sh --neovim     # install only Neovim

OS=$(uname -s)

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
INSTALL_VIM=true
INSTALL_NEOVIM=true

for arg in "$@"; do
case "$arg" in
--vim)
INSTALL_VIM=true
INSTALL_NEOVIM=false
;;
--neovim)
INSTALL_VIM=false
INSTALL_NEOVIM=true
;;
-h|--help)
echo "Usage: $0 [--vim | --neovim]"
echo "  (no flags)   Install both Vim and Neovim setups (default)"
echo "  --vim        Install only the Vim setup"
echo "  --neovim     Install only the Neovim setup"
exit 0
;;
*)
echo "Unknown option: $arg"
echo "Use --help for usage."
exit 1
;;
esac
done

# ---------------------------------------------------------------------------
# Detect a download tool: wget, curl, or fetch (FreeBSD built-in)
# ---------------------------------------------------------------------------
DOWNLOADER=""
if command -v wget &>/dev/null; then
DOWNLOADER="wget"
elif command -v curl &>/dev/null; then
DOWNLOADER="curl"
elif command -v fetch &>/dev/null; then
DOWNLOADER="fetch"
fi

# ---------------------------------------------------------------------------
# pkg_install PKG_NAME [PKG_NAME_BREW] [PKG_NAME_PACMAN]
#   Tries to install a package using the detected OS package manager.
#   Returns 0 on success, 1 on failure.
# ---------------------------------------------------------------------------
pkg_install() {
local pkg="$1"
local pkg_brew="${2:-$1}"
local pkg_pacman="${3:-$1}"
case "$OS" in
Linux)
if command -v apt-get &>/dev/null; then
sudo apt-get install -y "$pkg"
elif command -v dnf &>/dev/null; then
sudo dnf install -y "$pkg"
elif command -v pacman &>/dev/null; then
sudo pacman -S --noconfirm "$pkg_pacman"
else
return 1
fi
;;
Darwin)
if command -v brew &>/dev/null; then
brew install "$pkg_brew"
else
return 1
fi
;;
FreeBSD)
sudo pkg install -y "$pkg"
;;
*)
return 1
;;
esac
}

# ---------------------------------------------------------------------------
# Check and auto-install a required tool. Exits if it cannot be installed.
# Usage: require_tool COMMAND PKG [PKG_BREW] [PKG_PACMAN] [DESCRIPTION]
# ---------------------------------------------------------------------------
require_tool() {
local cmd="$1"
local pkg="$2"
local pkg_brew="${3:-$2}"
local pkg_pacman="${4:-$2}"
local desc="${5:-$cmd}"
if ! command -v "$cmd" &>/dev/null; then
echo ">>> $desc not found. Attempting to install '$pkg'..."
if pkg_install "$pkg" "$pkg_brew" "$pkg_pacman"; then
if ! command -v "$cmd" &>/dev/null; then
echo "ERROR: '$pkg' installed but '$cmd' still not found."
echo "Please install $desc manually and re-run install.sh."
exit 1
fi
echo ">>> $desc installed successfully."
else
echo "ERROR: Failed to install '$pkg' automatically."
echo "Please install $desc manually:"
case "$OS" in
Linux)
echo "  Debian/Ubuntu: sudo apt install $pkg"
echo "  Fedora/RHEL:   sudo dnf install $pkg"
echo "  Arch Linux:    sudo pacman -S $pkg_pacman"
;;
Darwin)
echo "  macOS: brew install $pkg_brew"
;;
FreeBSD)
echo "  FreeBSD: sudo pkg install $pkg"
;;
esac
exit 1
fi
fi
}

# ---------------------------------------------------------------------------
# Download a URL to a local file using whatever tool is available
# ---------------------------------------------------------------------------
download() {
local url="$1"
local output="$2"
case "$DOWNLOADER" in
wget)  wget -O "$output" "$url" ;;
curl)  curl -L -o "$output" "$url" ;;
fetch) fetch -o "$output" "$url" ;;
esac
}

# ---------------------------------------------------------------------------
# Shared dependency: wget/curl and unzip (needed for the dictionary)
# ---------------------------------------------------------------------------
require_tool wget  wget  wget  wget  "wget (download tool)"
require_tool unzip unzip unzip unzip "unzip"

# Re-detect downloader now that wget/curl is confirmed available
DOWNLOADER=""
if command -v wget &>/dev/null; then
DOWNLOADER="wget"
elif command -v curl &>/dev/null; then
DOWNLOADER="curl"
elif command -v fetch &>/dev/null; then
DOWNLOADER="fetch"
fi

# ---------------------------------------------------------------------------
# English dictionary — shared by both Vim and Neovim
# ---------------------------------------------------------------------------
if [ ! -d ~/.dic ]; then
mkdir ~/.dic
fi

if [ ! -f ~/.dic/en_US.dic ]; then
echo "Installing the English dictionary..."
download "http://downloads.sourceforge.net/wordlist/hunspell-en_US-2020.12.07.zip" \
"hunspell-en_US-2020.12.07.zip"
unzip hunspell-en_US-2020.12.07.zip en_US.dic
rm hunspell-en_US-2020.12.07.zip
mv en_US.dic ~/.dic/
else
echo "The English dictionary already exists."
fi

# ===========================================================================
# VIM SETUP
# ===========================================================================
if $INSTALL_VIM; then
echo ""
echo "=== Installing Vim setup ==="

# vim (must be present; if missing try to install it)
if ! command -v vim &>/dev/null; then
echo ">>> vim not found. Attempting to install..."
if pkg_install vim-nox vim vim; then
if ! command -v vim &>/dev/null; then
echo "ERROR: vim still not found after install attempt."
echo "Please install vim manually and re-run install.sh."
exit 1
fi
echo ">>> vim installed successfully."
else
echo "ERROR: Could not install vim automatically."
echo "Please install vim manually and re-run install.sh."
exit 1
fi
fi

# Vim must have +python3 support (vim-nox on Debian/Ubuntu, brew vim on macOS)
if ! vim --version 2>/dev/null | grep -q '+python3'; then
echo ">>> Vim lacks Python 3 support. Attempting to install the correct build..."
case "$OS" in
Linux)
if command -v apt-get &>/dev/null; then
sudo apt-get install -y vim-nox
elif command -v dnf &>/dev/null; then
sudo dnf install -y vim
elif command -v pacman &>/dev/null; then
sudo pacman -S --noconfirm vim
fi
;;
Darwin)
if command -v brew &>/dev/null; then
brew install vim
fi
;;
FreeBSD)
sudo pkg install -y vim
;;
esac
if ! vim --version 2>/dev/null | grep -q '+python3'; then
echo "ERROR: Vim still lacks Python 3 support after install attempt."
echo "Please install a Vim build with Python 3 support manually:"
echo "  Debian/Ubuntu: sudo apt install vim-nox"
echo "  macOS:         brew install vim"
echo "  FreeBSD:       sudo pkg install vim"
exit 1
fi
echo ">>> Vim with Python 3 support installed successfully."
fi

# Required tools for Vim / YouCompleteMe
require_tool python3 python3         python3       python3       "Python 3"
require_tool python3 python3-dev     python3       python3-devel "Python 3 development headers (python3-dev)"
require_tool cmake   cmake           cmake         cmake         "CMake (required to build YouCompleteMe)"
require_tool g++     build-essential g++           gcc           "C++ compiler (required to build YouCompleteMe)"

# Backup and install vimrc
if [ -e ~/.vimrc_backup ]; then
echo "Making a backup of the previous backup"
mv ~/.vimrc_backup ~/.vimrc_backup_movein$(date +"%d%h%y_%H-%M-%S")
fi
if [ -e ~/.vimrc ]; then
echo "Making a backup of the previous vimrc file"
mv ~/.vimrc ~/.vimrc_backup
fi
echo "Installing the vimrc file"
cp vimrc ~/.vimrc

# Resolve the absolute Python 3 path (used to build YCM)
PYTHON3_BIN=$(command -v python3)

# Install vim-plug if not present
PLUG_FILE="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG_FILE" ]; then
echo "Installing vim-plug..."
mkdir -p "$HOME/.vim/autoload"
download "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "$PLUG_FILE"
else
echo "vim-plug already installed"
fi

echo "Installing vim plugins (this may take a moment)..."
vim +PlugInstall +qall

# Build YouCompleteMe with C, C++ (clangd) and Python support
YCM_DIR="$HOME/.vim/plugged/YouCompleteMe"
if [ -d "$YCM_DIR" ]; then
if [ -n "$PYTHON3_BIN" ] && [ -x "$PYTHON3_BIN" ]; then
echo "Building YouCompleteMe (Python: $PYTHON3_BIN)..."
"$PYTHON3_BIN" "$YCM_DIR/install.py" --clangd-completer
else
echo "WARNING: python3 not found. Skipping YouCompleteMe build."
echo "Install python3 and run:"
echo "  python3 ~/.vim/plugged/YouCompleteMe/install.py --clangd-completer"
fi
else
echo "WARNING: YouCompleteMe directory not found. PlugInstall may have failed."
fi

# Install ctags if not present
if ! command -v ctags &>/dev/null; then
echo ">>> ctags not found. Attempting to install..."
if pkg_install exuberant-ctags ctags ctags; then
echo ">>> ctags installed successfully."
else
echo "WARNING: Failed to install ctags automatically."
echo "Please install ctags manually:"
case "$OS" in
Linux)
echo "  Debian/Ubuntu: sudo apt install exuberant-ctags"
echo "  Fedora/RHEL:   sudo dnf install ctags"
echo "  Arch Linux:    sudo pacman -S ctags"
;;
Darwin)  echo "  macOS: brew install ctags" ;;
FreeBSD) echo "  FreeBSD: sudo pkg install ctags" ;;
esac
fi
else
echo "ctags already installed"
fi

echo "=== Vim setup complete ==="
fi

# ===========================================================================
# NEOVIM SETUP
# ===========================================================================
if $INSTALL_NEOVIM; then
echo ""
echo "=== Installing Neovim setup ==="

# Install neovim
if ! command -v nvim &>/dev/null; then
echo ">>> neovim not found. Attempting to install..."
if pkg_install neovim neovim neovim; then
if ! command -v nvim &>/dev/null; then
echo "ERROR: neovim still not found after install attempt."
echo "Please install neovim (>= 0.10) manually and re-run install.sh."
exit 1
fi
echo ">>> neovim installed successfully."
else
echo "ERROR: Could not install neovim automatically."
echo "Please install neovim (>= 0.10) manually:"
echo "  Debian/Ubuntu: sudo apt install neovim"
echo "  Fedora/RHEL:   sudo dnf install neovim"
echo "  Arch Linux:    sudo pacman -S neovim"
echo "  macOS:         brew install neovim"
echo "  FreeBSD:       sudo pkg install neovim"
exit 1
fi
else
echo "neovim already installed"
fi

# git is required by lazy.nvim to clone plugins
require_tool git git git git "git (required by lazy.nvim)"

# Node.js is required by the GitHub Copilot plugin
if ! command -v node &>/dev/null; then
echo "WARNING: Node.js not found. Required by the Copilot plugin."
echo "Please install Node.js manually:"
echo "  Debian/Ubuntu: sudo apt install nodejs"
echo "  Fedora/RHEL:   sudo dnf install nodejs"
echo "  Arch Linux:    sudo pacman -S nodejs"
echo "  macOS:         brew install node"
echo "  FreeBSD:       sudo pkg install node"
else
echo "Node.js already installed"
fi

# ripgrep is required by Telescope live_grep
if ! command -v rg &>/dev/null; then
echo ">>> ripgrep not found. Attempting to install..."
if pkg_install ripgrep ripgrep ripgrep; then
echo ">>> ripgrep installed successfully."
else
echo "WARNING: Failed to install ripgrep automatically."
echo "Telescope live_grep will not work without it."
echo "Please install ripgrep manually:"
echo "  Debian/Ubuntu: sudo apt install ripgrep"
echo "  Fedora/RHEL:   sudo dnf install ripgrep"
echo "  Arch Linux:    sudo pacman -S ripgrep"
echo "  macOS:         brew install ripgrep"
echo "  FreeBSD:       sudo pkg install ripgrep"
fi
else
echo "ripgrep already installed"
fi

# clangd — C/C++ language server
if ! command -v clangd &>/dev/null; then
echo ">>> clangd not found. Attempting to install..."
if pkg_install clangd llvm clangd; then
echo ">>> clangd installed successfully."
else
echo "WARNING: Failed to install clangd automatically."
echo "C/C++ LSP will not work without it."
echo "Please install clangd manually:"
echo "  Debian/Ubuntu: sudo apt install clangd"
echo "  Fedora/RHEL:   sudo dnf install clang-tools-extra"
echo "  Arch Linux:    sudo pacman -S clang"
echo "  macOS:         brew install llvm"
fi
else
echo "clangd already installed"
fi

# pyright — Python language server (installed via pip)
if ! command -v pyright &>/dev/null; then
echo ">>> pyright not found. Attempting to install via pip..."
if command -v pip3 &>/dev/null; then
pip3 install --user pyright
elif command -v pip &>/dev/null; then
pip install --user pyright
else
echo "WARNING: pip not found. Cannot install pyright automatically."
echo "Please install pyright manually: pip install pyright"
fi
else
echo "pyright already installed"
fi

# cmake-language-server — CMake LSP (installed via pip)
if ! command -v cmake-language-server &>/dev/null; then
echo ">>> cmake-language-server not found. Attempting to install via pip..."
if command -v pip3 &>/dev/null; then
pip3 install --user cmake-language-server
elif command -v pip &>/dev/null; then
pip install --user cmake-language-server
else
echo "WARNING: pip not found. Cannot install cmake-language-server automatically."
fi
else
echo "cmake-language-server already installed"
fi

# black — Python formatter
if ! command -v black &>/dev/null; then
echo ">>> black not found. Attempting to install via pip..."
if command -v pip3 &>/dev/null; then
pip3 install --user black
elif command -v pip &>/dev/null; then
pip install --user black
else
echo "WARNING: pip not found. Cannot install black automatically."
fi
else
echo "black already installed"
fi

# debugpy — Python debug adapter for nvim-dap
if ! python3 -c "import debugpy" &>/dev/null 2>&1; then
echo ">>> debugpy not found. Attempting to install via pip..."
if command -v pip3 &>/dev/null; then
pip3 install --user debugpy
elif command -v pip &>/dev/null; then
pip install --user debugpy
else
echo "WARNING: pip not found. Cannot install debugpy automatically."
fi
else
echo "debugpy already installed"
fi

# clang-format — C/C++ formatter
if ! command -v clang-format &>/dev/null; then
echo ">>> clang-format not found. Attempting to install..."
if pkg_install clang-format clang-format clang; then
echo ">>> clang-format installed successfully."
else
echo "WARNING: Failed to install clang-format automatically."
echo "  Debian/Ubuntu: sudo apt install clang-format"
echo "  Fedora/RHEL:   sudo dnf install clang-tools-extra"
echo "  Arch Linux:    sudo pacman -S clang"
echo "  macOS:         brew install clang-format"
fi
else
echo "clang-format already installed"
fi

# gdb — C/C++ debugger for nvim-dap
if ! command -v gdb &>/dev/null; then
echo ">>> gdb not found. Attempting to install..."
if pkg_install gdb gdb gdb; then
echo ">>> gdb installed successfully."
else
echo "WARNING: Failed to install gdb automatically."
echo "C/C++ debugging in nvim-dap will not work without it."
fi
else
echo "gdb already installed"
fi

# Backup and install init.lua
NVIM_CONFIG_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"

if [ -e "$NVIM_CONFIG_DIR/init.lua" ]; then
BACKUP="$NVIM_CONFIG_DIR/init.lua.backup_$(date +"%d%h%y_%H-%M-%S")"
echo "Making a backup of the existing init.lua -> $BACKUP"
mv "$NVIM_CONFIG_DIR/init.lua" "$BACKUP"
fi

echo "Installing nvim/init.lua -> $NVIM_CONFIG_DIR/init.lua"
cp nvim/init.lua "$NVIM_CONFIG_DIR/init.lua"

echo ""
echo "lazy.nvim and all Neovim plugins will be downloaded automatically"
echo "the first time you open Neovim."

echo "=== Neovim setup complete ==="
fi

echo ""
echo "All Done."
