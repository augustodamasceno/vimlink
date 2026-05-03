#Requires -Version 5.1
# Vimlink installer for Windows — sets up Vim and/or Neovim configurations.
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
#    Requires winget (App Installer) and PowerShell 5.1+.
#
#  Usage:
#    .\install.ps1              # install both (default)
#    .\install.ps1 -Vim         # install only Vim
#    .\install.ps1 -Neovim      # install only Neovim

param(
    [switch]$Vim,
    [switch]$Neovim,
    [switch]$Help
)

if ($Help) {
    Write-Host "Usage: .\install.ps1 [-Vim | -Neovim]"
    Write-Host "  (no flags)   Install both Vim and Neovim setups (default)"
    Write-Host "  -Vim         Install only the Vim setup"
    Write-Host "  -Neovim      Install only the Neovim setup"
    exit 0
}

if ($Vim.IsPresent -and $Neovim.IsPresent) {
    $InstallVim    = $true
    $InstallNeovim = $true
} elseif ($Vim.IsPresent) {
    $InstallVim    = $true
    $InstallNeovim = $false
} elseif ($Neovim.IsPresent) {
    $InstallVim    = $false
    $InstallNeovim = $true
} else {
    $InstallVim    = $true
    $InstallNeovim = $true
}

# ---------------------------------------------------------------------------
# Helper: check if a command exists in PATH
# ---------------------------------------------------------------------------
function Test-Command {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# ---------------------------------------------------------------------------
# Helper: find an executable in PATH or common install directories.
# Returns the full path to the exe, or $null if not found.
# Also adds the exe's directory to the current session PATH when found
# outside of the standard PATH so subsequent calls work too.
# ---------------------------------------------------------------------------
function Find-Executable {
    param([string]$Command)
    $found = Get-Command $Command -ErrorAction SilentlyContinue
    if ($found) { return $found.Source }

    $searchRoots = @(
        $env:ProgramFiles,
        ${env:ProgramFiles(x86)},
        "$env:LOCALAPPDATA\Programs"
    ) | Where-Object { $_ -and (Test-Path $_) }

    foreach ($root in $searchRoots) {
        $exe = Get-ChildItem -Path $root -Filter "$Command.exe" -Recurse -ErrorAction SilentlyContinue |
               Select-Object -First 1
        if ($exe) {
            # Extend PATH so the rest of the script can use the command by name
            $env:PATH = $exe.DirectoryName + ';' + $env:PATH
            return $exe.FullName
        }
    }
    return $null
}

# ---------------------------------------------------------------------------
# Helper: install a package via winget and refresh PATH
# ---------------------------------------------------------------------------
function Install-WingetPackage {
    param([string]$Id, [string]$Name)
    Write-Host ">>> $Name not found. Attempting to install via winget..."
    winget install --id $Id --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to install $Name (winget id: $Id). Please install it manually."
        return $false
    }
    # Reload PATH from registry so newly installed tools are available
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' +
                [System.Environment]::GetEnvironmentVariable('PATH', 'User')
    return $true
}

# ---------------------------------------------------------------------------
# Helper: require a tool, exit on failure
# ---------------------------------------------------------------------------
function Require-Tool {
    param([string]$Command, [string]$WingetId, [string]$Name)
    if (Find-Executable $Command) { return }

    $ok = Install-WingetPackage -Id $WingetId -Name $Name
    if (-not $ok) {
        Write-Error "$Name is required but could not be installed. Please install it manually: winget install --id $WingetId"
        exit 1
    }
    # After install, try PATH (registry-refreshed) then fallback search
    if (-not (Find-Executable $Command)) {
        Write-Error "$Name installed but '$Command' still not found. Open a new PowerShell window and re-run install.ps1."
        exit 1
    }
    Write-Host ">>> $Name installed successfully."
}

# ---------------------------------------------------------------------------
# English dictionary — shared by both Vim and Neovim
# ---------------------------------------------------------------------------
$DicDir  = "$HOME\.dic"
$DicFile = "$DicDir\en_US.dic"

if (-not (Test-Path $DicDir)) {
    New-Item -ItemType Directory -Path $DicDir | Out-Null
}

if (-not (Test-Path $DicFile)) {
    Write-Host "Installing the English dictionary..."
    $ZipUrl   = "https://downloads.sourceforge.net/wordlist/hunspell-en_US-2020.12.07.zip"
    $ZipPath  = "$env:TEMP\hunspell-en_US-2020.12.07.zip"
    $ExtractDir = "$env:TEMP\hunspell-en_US-extract"

    # WebClient follows HTTP redirects reliably (SourceForge uses them)
    (New-Object System.Net.WebClient).DownloadFile($ZipUrl, $ZipPath)

    if (-not (Test-Path $ZipPath) -or (Get-Item $ZipPath).Length -lt 1024) {
        Write-Error "Dictionary download failed or file is too small. Please download manually from $ZipUrl"
        exit 1
    }

    if (Test-Path $ExtractDir) { Remove-Item $ExtractDir -Recurse -Force }
    Expand-Archive -Path $ZipPath -DestinationPath $ExtractDir -Force

    $DicSource = Get-ChildItem -Path $ExtractDir -Filter "en_US.dic" -Recurse | Select-Object -First 1
    if (-not $DicSource) {
        Write-Error "en_US.dic not found inside the archive."
        exit 1
    }
    Move-Item -Path $DicSource.FullName -Destination $DicFile -Force
    Remove-Item $ZipPath    -ErrorAction SilentlyContinue
    Remove-Item $ExtractDir -Recurse -ErrorAction SilentlyContinue
} else {
    Write-Host "The English dictionary already exists."
}

# ===========================================================================
# VIM SETUP
# ===========================================================================
if ($InstallVim) {
    Write-Host ""
    Write-Host "=== Installing Vim setup ==="

    # Vim
    Require-Tool -Command "vim" -WingetId "vim.vim" -Name "Vim"
    $VimExe = Find-Executable "vim"

    # Python 3
    if (-not (Find-Executable "python")) {
        Install-WingetPackage -Id "Python.Python.3" -Name "Python 3" | Out-Null
    }

    # CMake (needed to build YouCompleteMe)
    if (-not (Find-Executable "cmake")) {
        Install-WingetPackage -Id "Kitware.CMake" -Name "CMake" | Out-Null
    }

    # LLVM — provides clangd and clang-format
    if (-not (Find-Executable "clangd")) {
        Install-WingetPackage -Id "LLVM.LLVM" -Name "LLVM (clangd + clang-format)" | Out-Null
    }

    # Universal Ctags
    if (-not (Find-Executable "ctags")) {
        Write-Host ">>> ctags not found. Attempting to install via winget..."
        Install-WingetPackage -Id "UniversalCtags.Ctags" -Name "Universal Ctags" | Out-Null
    } else {
        Write-Host "ctags already installed"
    }

    # Backup and install _vimrc
    # On Windows, Vim reads $HOME\_vimrc (equivalent to ~/.vimrc on Unix)
    $VimRC = "$HOME\_vimrc"
    if (Test-Path "$HOME\_vimrc_backup") {
        $ts = Get-Date -Format "ddMMMyy_HH-mm-ss"
        Rename-Item "$HOME\_vimrc_backup" "$HOME\_vimrc_backup_movein$ts"
    }
    if (Test-Path $VimRC) {
        Write-Host "Making a backup of the previous _vimrc file"
        Rename-Item $VimRC "$HOME\_vimrc_backup"
    }
    Write-Host "Installing the vimrc file"
    Copy-Item "vimrc" $VimRC

    # Install vim-plug into both autoload locations:
    #   ~/vimfiles/autoload/  — native Windows Vim runtimepath
    #   ~/.vim/autoload/      — Git/MinGW Vim and the path used in vimrc's plug#begin
    $PlugDirs = @("$HOME\vimfiles\autoload", "$HOME\.vim\autoload")
    $PlugUrl  = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    $Downloaded = $false

    foreach ($dir in $PlugDirs) {
        $PlugFile = "$dir\plug.vim"
        if (-not (Test-Path $PlugFile)) {
            Write-Host "Installing vim-plug -> $PlugFile ..."
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
            if (-not $Downloaded) {
                $TmpPlug = "$env:TEMP\plug.vim"
                (New-Object System.Net.WebClient).DownloadFile($PlugUrl, $TmpPlug)
                if (-not (Test-Path $TmpPlug) -or (Get-Item $TmpPlug).Length -lt 1024) {
                    Write-Error "vim-plug download failed. Please download manually:`n  $PlugUrl`n  -> $PlugFile"
                    exit 1
                }
                $Downloaded = $true
            }
            Copy-Item $TmpPlug $PlugFile
        } else {
            Write-Host "vim-plug already installed in $dir"
        }
    }
    if ($Downloaded) { Remove-Item $TmpPlug -ErrorAction SilentlyContinue }

    Write-Host "Installing vim plugins (this may take a moment)..."
    & "$VimExe" +PlugInstall +qall

    # Build YouCompleteMe
    # vimrc uses plug#begin('~/.vim/plugged') so plugins land in $HOME\.vim\plugged
    $YcmDir = "$HOME\.vim\plugged\YouCompleteMe"
    if (Test-Path $YcmDir) {
        $Python3 = Find-Executable "python"
        if ($Python3) {
            Write-Host "Building YouCompleteMe (Python: $Python3)..."
            & "$Python3" "$YcmDir\install.py" --clangd-completer
        } else {
            Write-Warning "python not found. Skipping YouCompleteMe build."
            Write-Host "Install Python 3 and run: python `"$YcmDir\install.py`" --clangd-completer"
        }
    } else {
        Write-Warning "YouCompleteMe directory not found. PlugInstall may have failed."
    }

    Write-Host "=== Vim setup complete ==="
}

# ===========================================================================
# NEOVIM SETUP
# ===========================================================================
if ($InstallNeovim) {
    Write-Host ""
    Write-Host "=== Installing Neovim setup ==="

    # Neovim
    Require-Tool -Command "nvim" -WingetId "Neovim.Neovim" -Name "Neovim"
    $NvimExe = Find-Executable "nvim"

    # git — required by lazy.nvim
    if (-not (Find-Executable "git")) {
        Install-WingetPackage -Id "Git.Git" -Name "Git" | Out-Null
    } else {
        Write-Host "git already installed"
    }

    # Node.js — required by the GitHub Copilot plugin
    if (-not (Find-Executable "node")) {
        Write-Warning "Node.js not found. Required by the Copilot plugin."
        Write-Host "Install Node.js manually: winget install --id OpenJS.NodeJS"
    } else {
        Write-Host "Node.js already installed"
    }

    # ripgrep — required by Telescope live_grep
    if (-not (Find-Executable "rg")) {
        Install-WingetPackage -Id "BurntSushi.ripgrep.MSVC" -Name "ripgrep" | Out-Null
    } else {
        Write-Host "ripgrep already installed"
    }

    # LLVM — clangd + clang-format
    if (-not (Find-Executable "clangd")) {
        Install-WingetPackage -Id "LLVM.LLVM" -Name "LLVM (clangd + clang-format)" | Out-Null
    } else {
        Write-Host "clangd already installed"
    }

    # pyright — Python language server
    if (-not (Find-Executable "pyright")) {
        Write-Host ">>> pyright not found. Attempting to install via pip..."
        if (Find-Executable "pip") {
            pip install --user pyright
        } else {
            Write-Warning "pip not found. Please install pyright manually: pip install pyright"
        }
    } else {
        Write-Host "pyright already installed"
    }

    # cmake-language-server
    if (-not (Find-Executable "cmake-language-server")) {
        Write-Host ">>> cmake-language-server not found. Attempting to install via pip..."
        if (Find-Executable "pip") {
            pip install --user cmake-language-server
        } else {
            Write-Warning "pip not found. Please install cmake-language-server manually: pip install cmake-language-server"
        }
    } else {
        Write-Host "cmake-language-server already installed"
    }

    # black — Python formatter
    if (-not (Find-Executable "black")) {
        Write-Host ">>> black not found. Attempting to install via pip..."
        if (Find-Executable "pip") {
            pip install --user black
        } else {
            Write-Warning "pip not found. Please install black manually: pip install black"
        }
    } else {
        Write-Host "black already installed"
    }

    # debugpy — Python debug adapter for nvim-dap
    $Python3 = Find-Executable "python"
    if ($Python3) {
        $null = & "$Python3" -c "import debugpy" 2>$null
    } else {
        $LASTEXITCODE = 1
    }
    if ($LASTEXITCODE -ne 0) {
        Write-Host ">>> debugpy not found. Attempting to install via pip..."
        if (Find-Executable "pip") {
            pip install --user debugpy
        } else {
            Write-Warning "pip not found. Please install debugpy manually: pip install debugpy"
        }
    } else {
        Write-Host "debugpy already installed"
    }

    # Backup and install init.lua
    # On Windows, Neovim reads %LOCALAPPDATA%\nvim\init.lua
    $NvimConfigDir = "$env:LOCALAPPDATA\nvim"
    if (-not (Test-Path $NvimConfigDir)) {
        New-Item -ItemType Directory -Path $NvimConfigDir | Out-Null
    }

    $NvimInit = "$NvimConfigDir\init.lua"
    if (Test-Path $NvimInit) {
        $ts     = Get-Date -Format "ddMMMyy_HH-mm-ss"
        $Backup = "$NvimConfigDir\init.lua.backup_$ts"
        Write-Host "Making a backup of the existing init.lua -> $Backup"
        Move-Item $NvimInit $Backup
    }

    Write-Host "Installing nvim\init.lua -> $NvimInit"
    Copy-Item "nvim\init.lua" $NvimInit

    Write-Host ""
    Write-Host "lazy.nvim and all Neovim plugins will be downloaded automatically"
    Write-Host "the first time you open Neovim."

    Write-Host "=== Neovim setup complete ==="
}

Write-Host ""
Write-Host "All Done."
