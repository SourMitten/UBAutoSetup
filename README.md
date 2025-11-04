# 🐧 UBAutoSetup

**UBAutoSetup** is an interactive Ubuntu setup script designed to automate common installation steps for new systems, VMs, and WSL environments.  
It helps you get started faster by providing two modes: **Full Setup** and **LNFinal Setup**.

---

## 🚀 Features

- Interactive menu (choose setup mode)
- Runs system updates and installs key packages
- Error handling with exit codes
- Verifies installations and Python imports
- Clean and minimal — perfect for fast provisioning

---

## ⚙️ Usage

Clone the repository and run the script:

```bash
git clone https://github.com/yourusername/UBAutoSetup.git
cd UBAutoSetup
sudo bash setup.sh
```
When prompted, Select setup mode:
```
  [1] Full Setup  - Installs all essential dev tools
  [2] LNFinal Setup - Installs pip, psutil, and rich only
```
🧩 Setup Modes
🔹 Full Setup (Option 1)
Performs a full environment setup:

Updates and upgrades the system

Installs:

python3, python3-pip

git, curl, wget

vim, htop, net-tools, unzip

build-essential, software-properties-common

Cleans up unnecessary packages

Verifies all tools are installed

🔹 LNFinal Setup (Option 2)
Lightweight setup for use with SSM (https://github.com/SourMitten/SSM):

Ensures python3-pip is installed

Installs required Python libraries:

psutil

rich

Verifies both packages import successfully

🧠 Error Codes
| Code | Description |
|------|--------------|
| `1`  | Script not run as root |
| `2`  | Invalid menu selection |
| `10` | General installation failure |
| `11` | Failed to install `python3-pip` |
| `12` | Failed to upgrade `pip` |
| `13` | Failed to install `psutil` or `rich` |
| `14` | Python packages failed import test |
| `20` | One or more core packages failed to install |


💡 Notes
Designed for Ubuntu 22.04+ (Python 3 comes preinstalled)

Easily customizable — edit the package list in setup.sh to fit your workflow

Can be used for VM bootstrapping, WSL setup, or lab environments

🧑‍💻
Created by SourMitten170
Made to make Ubuntu setup fast, clean, and painless.
