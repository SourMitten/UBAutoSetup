#!/bin/bash
# UBAutoSetup - Quick Ubuntu setup automation
# Run with: sudo bash setup.sh

set -e

echo "==== [UBAutoSetup] Debian-based Setup Assistant ===="

# SSM (System Monitoring) requires root privileges because it accesses 
# system-level information, reads protected kernel metrics, and uses 
# privileged features to monitor hardware and processes accurately.
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Please run as root (sudo bash setup.sh). System tools require root privileges."
  exit 1
fi

# Prevent apt from hanging on configuration file prompts during upgrades
export DEBIAN_FRONTEND=noninteractive

# Function to verify installs
check_install() {
  local name="$1"
  local cmd="$2"
  # command -v is used instead of 'which' as it is POSIX compliant and 
  # correctly resolves paths and aliases regardless of whether the script 
  # is run as root or a standard user.
  if ! command -v "$cmd" &>/dev/null; then
    echo "[ERROR] $name failed to install. Command '$cmd' was not found in the system PATH."
    exit 10
  else
    echo "[OK] $name installed successfully. (Path: $(command -v "$cmd"))"
  fi
}

# Install system packages for Full mode (exclude LNFinal libs)
install_full_packages() {
  echo "---- Installing Full system packages ----"
  apt update -y && apt upgrade -y
  apt install -y \
    python3 python3-pip git curl wget vim htop net-tools unzip build-essential software-properties-common ca-certificates
  apt clean
}

# Install Python packages for LNFinal
install_lnfinal_packages() {
  echo "---- Installing LNFinal (SSM) Python packages ----"
  
  # --break-system-packages is required on Ubuntu 23.04+ (PEP 668 enforcement) 
  # to allow global pip installations. We use this flag intentionally to keep 
  # SSM and system tools globally available without relying on virtual environments.
  pip3 install --upgrade pip --break-system-packages
  pip3 install psutil rich keyboard speedtest-cli --break-system-packages
}

# Install extra Python packages for Ext mode
install_ext_only_packages() {
  echo "---- Installing extra Python packages for Ext mode ----"
  pip3 install requests numpy pandas matplotlib flask beautifulsoup4 --break-system-packages
}

# Menu prompt
echo
echo "Select setup mode:"
echo "  [1] LNFinal (SSM Setup)  - Minimal Python libs + speedtest-cli"
echo "  [2] Full Setup           - Essential dev tools only"
echo "  [3] Ext. Setup           - Full Setup + LNFinal + extra little greebly libraries = Extended Setup!"
echo "  [4] Verify SSM Install   - Check if SSM and its dependencies are correctly installed"
echo
read -p "Enter your choice (1, 2, 3, or 4): " CHOICE
echo

case "$CHOICE" in
  1)
    echo "---- [LNFinal (SSM Setup)] ----"
    apt update -y
    apt install -y python3-pip || { echo "[ERROR] Failed to install python3-pip."; exit 11; }
    install_lnfinal_packages

    check_install "Python 3" python3
    check_install "pip3" pip3
    python3 -c "import psutil, rich, keyboard, speedtest" 2>/dev/null || { echo "[ERROR] Python packages failed to import."; exit 14; }

    echo "---- [LNFinal (SSM Setup)] Completed ----"
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

  4)
    echo "---- [Verify SSM Installation] ----"
    VERIFY_FAIL=0

    # Confirm Python 3 exists
    if command -v python3 &>/dev/null; then
      echo "[OK] Python 3 is installed."
    else
      echo "[ERROR] Python 3 is not installed."
      VERIFY_FAIL=1
    fi

    # Confirm pip3 exists
    if command -v pip3 &>/dev/null; then
      echo "[OK] pip3 is installed."
    else
      echo "[ERROR] pip3 is not installed."
      VERIFY_FAIL=1
    fi

    # Confirm required Python packages import successfully
    echo "Checking Python package imports..."
    if python3 -c "import psutil, rich, keyboard, speedtest" 2>/dev/null; then
      echo "[OK] Required Python packages (psutil, rich, keyboard, speedtest) imported successfully."
    else
      echo "[ERROR] One or more required Python packages failed to import."
      VERIFY_FAIL=1
    fi

    # Confirm the SSM executable/script exists and is executable
    if [ -x "/usr/local/bin/ssm" ]; then
      echo "[OK] SSM executable found and is executable at /usr/local/bin/ssm."
    else
      echo "[ERROR] SSM executable not found or lacks execute permissions at /usr/local/bin/ssm."
      VERIFY_FAIL=1
    fi

    echo
    if [ "$VERIFY_FAIL" -eq 0 ]; then
      echo "==== [Verify SSM Installation] SUCCESS: All checks passed! ===="
    else
      echo "==== [Verify SSM Installation] FAILURE: One or more checks failed. ===="
      exit 15
    fi
    ;;

  *)
    echo "[ERROR] Invalid selection. Enter 1, 2, 3, or 4."
    exit 2
    ;;
esac

echo
echo "==== [UBAutoSetup] All tasks completed successfully! ===="
