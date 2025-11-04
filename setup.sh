#!/bin/bash
# UBAutoSetup - Quick Ubuntu setup automation
# Run with: sudo bash setup.sh

set -e  # Stop on first error

echo "==== [UBAutoSetup] Ubuntu Setup Assistant ===="

if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Please run as root (sudo bash setup.sh)"
  exit 1
fi

# Function to verify installs
check_install() {
  local name="$1"
  local cmd="$2"

  if ! command -v $cmd &>/dev/null; then
    echo "[ERROR] $name failed to install or not found."
    exit 10
  else
    echo "[OK] $name installed successfully."
  fi
}

# Menu prompt
echo
echo "Select setup mode:"
echo "  [1] Full Setup  - Installs all essential dev tools"
echo "  [2] LNFinal Setup - Installs pip, psutil, and rich only"
echo
read -p "Enter your choice (1 or 2): " CHOICE
echo

# Run based on selection
case "$CHOICE" in
  1)
    echo "---- [Full Setup] Starting full environment setup ----"
    apt update -y && apt upgrade -y

    apt install -y \
      python3 \
      python3-pip \
      git \
      curl \
      wget \
      vim \
      htop \
      net-tools \
      unzip \
      build-essential \
      software-properties-common || { echo "[ERROR] Failed installing base packages."; exit 20; }

    apt autoremove -y
    apt clean

    # Verify installs
    check_install "Python 3" python3
    check_install "pip3" pip3
    check_install "Git" git
    check_install "Curl" curl
    check_install "Vim" vim

    echo "---- [Full Setup] Completed successfully ----"
    ;;
  2)
    echo "---- [LNFinal Setup] Installing Python dependencies ----"
    apt update -y

    if ! command -v pip3 &>/dev/null; then
      apt install -y python3-pip || { echo "[ERROR] Failed to install python3-pip."; exit 11; }
    fi

    pip3 install --upgrade pip || { echo "[ERROR] Failed to upgrade pip."; exit 12; }
    pip3 install psutil rich || { echo "[ERROR] Failed to install psutil or rich."; exit 13; }

    check_install "Python 3" python3
    check_install "pip3" pip3
    python3 -c "import psutil, rich" 2>/dev/null || { echo "[ERROR] psutil or rich failed to import."; exit 14; }

    echo "---- [LNFinal Setup] Completed successfully ----"
    ;;
  *)
    echo "[ERROR] Invalid selection. Please enter 1 or 2."
    exit 2
    ;;
esac

echo
echo "==== [UBAutoSetup] All tasks completed successfully! ===="
