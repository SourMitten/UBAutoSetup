# 🐧 UBAutoSetup

**UBAutoSetup** is an interactive Ubuntu setup automation script designed to rapidly configure new systems, VMs, and WSL environments.  
It streamlines the provisioning process by offering targeted setup modes, from lightweight SSM (Sour CLI Sys Monitor) dependencies to full extended development environments.

---

## 🚀 Features

- **4 Interactive Setup Modes**: Choose exactly what you need (SSM, Full Dev, Extended, or Verification).
- **PEP 668 Compliant**: Safely handles global `pip` installations on Ubuntu 23.04+ using `--break-system-packages`.
- **Non-Interactive Upgrades**: Uses `DEBIAN_FRONTEND=noninteractive` to prevent apt from hanging on configuration prompts.
- **Robust Error Handling**: POSIX-compliant `command -v` checks and specific exit codes for easy debugging.
- **Built-in Verification**: Dedicated mode to verify SSM dependencies and executable permissions.

---

## ⚙️ Usage

Clone the repository and run the script with root privileges:

```bash
git clone https://github.com/SourMitten/UBAutoSetup.git
cd UBAutoSetup
sudo bash setup.sh
```

When prompted, select your desired setup mode:
```text
Select setup mode:
  [1] LNFinal (SSM Setup)  - Minimal Python libs + speedtest-cli
  [2] Full Setup           - Essential dev tools only
  [3] Ext. Setup           - Full Setup + LNFinal + extra little greebly libraries = Extended Setup!
  [4] Verify SSM Install   - Check if SSM and its dependencies are correctly installed
```

---

## 🧩 Setup Modes

### 🔹 [1] LNFinal (SSM Setup)
A lightweight, targeted setup specifically for running **SSM** (Sour CLI Sys Monitor).
- Ensures `python3-pip` is installed.
- Installs required Python libraries globally: `psutil`, `py-cpuinfo`, `pynvml`, `rich`, `keyboard`, `speedtest-cli`.
- Verifies that all core Python packages import successfully.

### 🔹 [2] Full Setup
A clean, essential development environment without SSM-specific Python libraries.
- Updates and upgrades the system (`apt update && apt upgrade`).
- Installs core tools: `python3`, `python3-pip`, `git`, `curl`, `wget`, `vim`, `htop`, `net-tools`, `unzip`, `build-essential`, `software-properties-common`, `ca-certificates`.
- Cleans up unnecessary cached packages (`apt clean`).
- Verifies all core tools are present in the system PATH.

### 🔹 [3] Ext. Setup (Extended)
The ultimate "kitchen sink" mode for heavy development, data science, and advanced CLI workflows.
- Executes **Full Setup** (Mode 2).
- Executes **LNFinal Setup** (Mode 1).
- Installs extra Python packages: `requests`, `numpy`, `pandas`, `matplotlib`, `flask`, `beautifulsoup4`.
- Installs extra CLI utilities: `tmux`, `tree`, `nmap`, `jq`.
- Verifies all system tools and Python imports.

### 🔹 [4] Verify SSM Install
A diagnostic mode to confirm an existing SSM installation is healthy.
- Checks for `python3` and `pip3` availability.
- Tests Python imports for `psutil`, `rich`, `keyboard`, and `speedtest`.
- Verifies that the SSM executable exists and has execute permissions at `/usr/local/bin/ssm`.

---

## 🧠 Error Codes

The script uses specific exit codes to help you quickly identify what went wrong:

| Code | Description |
|------|--------------|
| `1`  | Script not run as root (requires `sudo`) |
| `2`  | Invalid menu selection |
| `10` | General installation failure (command not found in PATH post-install) |
| `11` | Failed to install `python3-pip` (Mode 1) |
| `14` | Python packages failed the import verification test |
| `15` | Verify SSM Installation mode failed one or more checks |

---

## 💡 Notes

- **Compatibility**: Designed for Ubuntu 22.04 LTS and newer (including 23.04/24.04+ with PEP 668 enforcement).
- **Customization**: Easily adaptable — simply edit the package arrays in `setup.sh` to fit your specific workflow or organizational standards.
- **Use Cases**: Perfect for automated VM bootstrapping, fresh WSL2 setups, CI/CD runner preparation, or homelab environments.

---

## 🧑‍💻 Credits

**Created by SourMitten170**  
*Made to make Debian-based setups fast, clean, and painless.*
