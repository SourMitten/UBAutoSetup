#!/bin/bash
# UBAutoSetup - Quick Ubuntu setup automation
# Run with: sudo bash setup.sh

set -e

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

# Install system packages for Full mode (exclude LNFinal libs)
install_full_packages() {
  echo "---- Installing Full system packages ----"
  apt update -y && apt upgrade -y
  apt install -y \
    python3 python3-pip git curl wget vim htop net-tools unzip build-essential software-properties-common
  apt autoremove -y
  apt clean
}

# Install Python packages for LNFinal
install_lnfinal_packages() {
  echo "---- Installing LNFinal Python packages ----"
  pip3 install --upgrade pip
  pip3 install psutil rich keyboard speedtest-cli
}

# Install extra Python packages for Ext mode
install_ext_only_packages() {
  echo "---- Installing extra Python packages for Ext mode ----"
  pip3 install requests numpy pandas matplotlib flask beautifulsoup4
}

# Menu prompt
echo
echo "Select setup mode:"
echo "  [1] LNFinal Setup  - Minimal Python libs + speedtest-cli"
echo "  [2] Full Setup     - Essential dev tools only"
echo "  [3] Ext. Setup     - Full Setup + LNFinal + extra little greebly libraries = Extended Setup!"
echo
read -p "Enter your choice (1, 2, or 3): " CHOICE
echo

case "$CHOICE" in
  1)
    echo "---- [LNFinal Setup] ----"
    apt update -y
    apt install -y python3-pip || { echo "[ERROR] Failed to install python3-pip."; exit 11; }
    install_lnfinal_packages

    check_install "Python 3" python3
    check_install "pip3" pip3
    python3 -c "import psutil, rich, keyboard, speedtest" 2>/dev/null || { echo "[ERROR] Python packages failed to import."; exit 14; }

    echo "---- [LNFinal Setup] Completed ----"
    ;;

  2)
    echo "---- [Full Setup] ----"
    install_full_packages
    # Full mode does NOT install LNFinal Python libs
    check_install "Python 3" python3
    check_install "pip3" pip3
    check_install "Git" git
    check_install "Curl" curl
    check_install "Vim" vim

    echo "---- [Full Setup] Completed ----"
    ;;

  3)
    echo "---- [Ext. Setup] ----"
    echo "Full Setup + LNFinal + extra little greebly libraries + handy CLI tools = Extended Setup!"

    # Step 1: Full system packages
    install_full_packages
    
    # Step 2: LNFinal Python packages
    install_lnfinal_packages
    
    # Step 3: Ext. only Python packages
    install_ext_only_packages

    # Step 4: Extra CLI tools for Ext mode
    echo "---- Installing extra CLI tools for Ext mode ----"
    apt install -y tmux tree nmap jq

    # Verification
    check_install "Python 3" python3
    check_install "pip3" pip3
    check_install "Git" git
    check_install "Curl" curl
    check_install "Vim" vim
    check_install "tmux" tmux
    check_install "tree" tree
    check_install "nmap" nmap
    check_install "jq" jq
    python3 -c "import psutil, rich, keyboard, speedtest, requests, numpy, pandas, matplotlib, flask, bs4" 2>/dev/null || { echo "[ERROR] Python packages failed to import."; exit 14; }

    echo "---- [Ext. Setup] Completed ----"
    ;;

  *)
    echo "[ERROR] Invalid selection. Enter 1, 2, or 3."
    exit 2
    ;;
esac

echo
echo "==== [UBAutoSetup] All tasks completed successfully! ===="
