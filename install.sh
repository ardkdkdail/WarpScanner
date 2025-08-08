#!/data/data/com.termux/files/usr/bin/bash

set -e

echo -e "\n🔰 \e[1;36m[STEALTH SYSTEM]\e[0m Starting \e[1;35mUltra Smart Auto Installer\e[0m..."
sleep 1

# 🔍 Check & install package if not present
install_if_missing() {
    local cmd="$1"
    local pkg="$2"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo -e "📦 \e[1;33m$cmd not found. Installing $pkg...\e[0m"
        pkg install -y "$pkg" || { echo "❌ Failed to install $pkg"; exit 1; }
    else
        echo -e "✅ \e[1;32m$cmd is already installed.\e[0m"
    fi
}

echo -e "\n📦 \e[1;34mChecking & installing required packages...\e[0m"

install_if_missing python python
install_if_missing pip python
install_if_missing rust rust
install_if_missing clang clang
install_if_missing git git
install_if_missing wget wget
install_if_missing curl curl
install_if_missing tar tar
install_if_missing unzip unzip
install_if_missing openssl openssl-tool
install_if_missing pkg-config clang
install_if_missing cmake cmake
install_if_missing make make
install_if_missing libffi-dev libffi
install_if_missing wheel python

# 🐍 Check and upgrade pip
echo -e "\n🐍 \e[1;34mEnsuring pip is up-to-date...\e[0m"
pip install --upgrade pip setuptools wheel || { echo "❌ Failed to upgrade pip"; exit 1; }

# 🔐 Install Python modules if not already installed
ensure_pip_module() {
    local module="$1"
    local from_source="$2"
    if ! python -c "import $module" >/dev/null 2>&1; then
        echo -e "📥 Installing Python module: $module"
        if [ "$from_source" = true ]; then
            pip install --no-cache-dir --no-binary :all: "$module" || { echo "❌ Failed to install $module from source."; exit 1; }
        else
            pip install "$module" || { echo "❌ Failed to install $module."; exit 1; }
        fi
    else
        echo -e "✅ \e[1;32mPython module '$module' already installed.\e[0m"
    fi
}

echo -e "\n🔐 \e[1;34mChecking Python modules...\e[0m"

ensure_pip_module cryptography true
ensure_pip_module requests false
ensure_pip_module rich false
ensure_pip_module retrying false

# 📁 WarpScanner.py section
WARP_FILE="WarpScanner.py"
WARP_URL="https://raw.githubusercontent.com/ardkdkdail/WarpScanner/main/WarpScanner.py"

echo -e "\n📁 \e[1;34mChecking WarpScanner.py...\e[0m"

download_warp() {
    echo -e "🌐 Downloading latest WarpScanner.py..."
    curl -fsSL -o "$WARP_FILE" "$WARP_URL" || { echo "❌ Failed to download WarpScanner.py."; exit 1; }
}

if [ -f "$WARP_FILE" ]; then
    FIRST_LINE=$(head -n 1 "$WARP_FILE")
    if [[ "$FIRST_LINE" == "import urllib.request" ]] || [[ "$FIRST_LINE" != V=* ]]; then
        echo -e "⚠️ Detected outdated or invalid WarpScanner.py. Replacing..."
        rm -f "$WARP_FILE"
        download_warp
    else
        echo -e "✅ \e[1;32mWarpScanner.py is already up-to-date.\e[0m"
    fi
else
    echo -e "📄 WarpScanner.py not found. Downloading..."
    download_warp
fi

# 🚀 Execute WarpScanner
echo -e "\n🚀 \e[1;35mLaunching WarpScanner.py...\e[0m"
python "$WARP_FILE" || { echo "❌ Error while running WarpScanner.py."; exit 1; }

# ✅ Final success message
echo -e "\n✅ \e[1;36m[STEALTH SYSTEM]\e[0m All tasks completed \e[1;32msuccessfully\e[0m with \e[1;32mZERO errors\e[0m. 🎉"
