#!/bin/bash
# Vimlink .vimrc
#
# Copyright (c) 2015-2026, Augusto Damasceno.
# All rights reserved.
# 
# SPDX-License-Identifier: BSD-2-Clause
#
#  This script:
#    Backup previous backup
#    Backup the .vimrc file.
#    Copy the VIMLINK .vimrc file to $HOME/.vimrc
#    Download and install an English 
#      dictionary from Hunspell English Dictionaries.

OS=$(uname -s)

# Detect a download tool: wget, curl, or fetch (FreeBSD built-in)
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

# Required tools — auto-install if missing
require_tool wget   wget   wget   wget   "wget (download tool)"
require_tool unzip  unzip  unzip  unzip  "unzip"
require_tool python3 python3 python3 python3 "Python 3"
require_tool python3 python3-dev python3-dev python3-devel "Python 3 development headers (python3-dev)"
require_tool cmake   cmake   cmake  cmake  "CMake (required to build YouCompleteMe)"
require_tool g++     build-essential g++  gcc  "C++ compiler (required to build YouCompleteMe)"

# Re-detect downloader now that wget/curl is confirmed available
DOWNLOADER=""
if command -v wget &>/dev/null; then
	DOWNLOADER="wget"
elif command -v curl &>/dev/null; then
	DOWNLOADER="curl"
elif command -v fetch &>/dev/null; then
	DOWNLOADER="fetch"
fi

# Download a URL to a local file using whatever tool is available
download() {
	local url="$1"
	local output="$2"
	case "$DOWNLOADER" in
		wget)  wget -O "$output" "$url" ;;
		curl)  curl -L -o "$output" "$url" ;;
		fetch) fetch -o "$output" "$url" ;;
	esac
}

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

# Resolve the absolute Python 3 path (used later to build YCM)
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

# Build YouCompleteMe with C, C++ (clangd) and Python support.
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
			Darwin) echo "  macOS: brew install ctags" ;;
			FreeBSD) echo "  FreeBSD: sudo pkg install ctags" ;;
		esac
	fi
else
	echo "ctags already installed"
fi

if [ ! -d ~/.dic ]; then
	mkdir ~/.dic
fi

if [ ! -f ~/.dic/en_US.dic ]; then
	echo "Installing the English dictionary"
	download "http://downloads.sourceforge.net/wordlist/hunspell-en_US-2020.12.07.zip" \
		"hunspell-en_US-2020.12.07.zip"
	unzip hunspell-en_US-2020.12.07.zip en_US.dic
	rm hunspell-en_US-2020.12.07.zip
	mv en_US.dic ~/.dic/
else
	echo "The English dictionary already exists"
fi

echo "All Done."


