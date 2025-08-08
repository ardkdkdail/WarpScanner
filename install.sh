#!/data/data/com.termux/files/usr/bin/bash

set -e

echo -e "\n🔰 [STEALTH SYSTEM] Starting Ultra Smart Auto Installer..."
sleep 1

# 📦 Step 1: Update & Upgrade Termux Packages
echo -e "\n📦 Updating and upgrading Termux packages..."
pkg update -y && pkg upgrade -y || { echo "❌ Failed to update/upgrade packages."; exit 1; }

# 📥 Step 2: Install Required Packages
echo -e "\n📥 Installing base packages (Python, Rust, Clang, libffi, OpenSSL, Git, wget, curl, tar, unzip)..."
pkg install -y python rust clang libffi openssl git wget curl tar unzip || { echo "❌ Failed to install required packages."; exit 1; }

# 🐍 Step 3: Install pip (if needed)
echo -e "\n🐍 Ensuring pip is available..."
if ! command -v pip >/dev/null; then
    echo "Installing pip manually..."
    curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py || { echo "❌ Failed to install pip."; exit 1; }
fi

# ⬆️ Step 4: Upgrade pip and build tools
echo -e "\n⬆️ Upgrading pip and essential build tools..."
pip install --upgrade pip setuptools wheel || { echo "❌ Failed to upgrade pip/build tools."; exit 1; }

# 🔐 Step 5: Install Python modules (from source to ensure compatibility)
echo -e "\n🔐 Installing Python modules: cryptography, requests, rich, retrying..."
pip install --no-cache-dir --no-binary :all: cryptography || { echo "❌ Failed to install 'cryptography' from source."; exit 1; }
pip install requests rich retrying || { echo "❌ Failed to install other Python modules."; exit 1; }

# 📁 Step 6: Check & Manage WarpScanner.py
WARP_FILE="WarpScanner.py"
WARP_URL="https://raw.githubusercontent.com/ardkdkdail/WarpScanner/main/WarpScanner.py"

echo -e "\n📁 Checking WarpScanner.py..."

download_warp() {
    echo "🌐 Downloading latest WarpScanner.py..."
    curl -fsSL -o "$WARP_FILE" "$WARP_URL" || { echo "❌ Failed to download WarpScanner.py."; exit 1; }
}

if [ -f "$WARP_FILE" ]; then
    FIRST_LINE=$(head -n 1 "$WARP_FILE")
    if [[ "$FIRST_LINE" == "import urllib.request" ]] || [[ "$FIRST_LINE" != "V=78" ]]; then
        echo "⚠️ Detected outdated or invalid WarpScanner.py. Replacing..."
        rm -f "$WARP_FILE"
        download_warp
    else
        echo "✅ WarpScanner.py is already up-to-date."
    fi
else
    echo "📄 WarpScanner.py not found. Downloading..."
    download_warp
fi

# 🚀 Step 7: Execute WarpScanner
echo -e "\n🚀 Launching WarpScanner.py..."
python "$WARP_FILE" || { echo "❌ Error while running WarpScanner.py."; exit 1; }

echo -e "\n✅ [STEALTH SYSTEM] Installation and execution completed successfully with zero errors."
