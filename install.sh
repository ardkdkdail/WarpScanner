#!/data/data/com.termux/files/usr/bin/bash

set -e

echo -e "\n🔰 [STEALTH SYSTEM] Starting Ultra Smart Auto Installer..."
sleep 1

# =============================== ✅ Step 1: Update & Upgrade ===============================
echo -e "\n📦 Updating and upgrading Termux packages..."
pkg update -y && pkg upgrade -y || { echo "❌ Failed to update/upgrade packages."; exit 1; }

# =============================== ✅ Step 2: Install Base Packages If Missing ===============================
echo -e "\n📥 Checking and installing required packages if missing..."

REQUIRED_PKGS=("python" "rust" "clang" "libffi" "openssl" "git" "wget" "curl" "tar" "unzip")
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "$pkg" >/dev/null 2>&1 && ! [ -x "/data/data/com.termux/files/usr/bin/$pkg" ]; then
        echo "📦 Installing missing package: $pkg"
        pkg install -y "$pkg" || { echo "❌ Failed to install $pkg."; exit 1; }
    else
        echo "✅ Package already installed: $pkg"
    fi
done

# =============================== ✅ Step 3: Ensure pip Is Available ===============================
echo -e "\n🐍 Ensuring pip is available..."
if ! command -v pip >/dev/null && [ ! -f /data/data/com.termux/files/usr/bin/pip ]; then
    echo "📦 Installing pip manually..."
    curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py && rm -f get-pip.py || {
        echo "❌ Failed to install pip."; exit 1;
    }
else
    echo "✅ pip already installed."
fi

# =============================== ✅ Step 4: Upgrade pip and build tools ===============================
echo -e "\n⬆️ Upgrading pip and essential build tools..."
pip install --upgrade pip setuptools wheel || { echo "❌ Failed to upgrade pip/build tools."; exit 1; }

# =============================== ✅ Step 5: Install Python Modules ===============================
echo -e "\n🔐 Installing required Python modules only if not already installed..."

REQUIRED_MODULES=("cryptography" "requests" "rich" "retrying")

for module in "${REQUIRED_MODULES[@]}"; do
    if ! python -c "import $module" 2>/dev/null; then
        if [ "$module" == "cryptography" ]; then
            echo "📦 Installing $module from source..."
            pip install --no-cache-dir --no-binary :all: "$module" || { echo "❌ Failed to install $module."; exit 1; }
        else
            echo "📦 Installing $module..."
            pip install "$module" || { echo "❌ Failed to install $module."; exit 1; }
        fi
    else
        echo "✅ Python module already installed: $module"
    fi
done

# =============================== ✅ Step 6: Manage WarpScanner.py ===============================
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
        download_warp
    else
        echo "✅ WarpScanner.py is already up-to-date."
    fi
else
    echo "📄 WarpScanner.py not found. Downloading..."
    download_warp
fi

# =============================== ✅ Step 7: Execute WarpScanner ===============================
echo -e "\n🚀 Launching WarpScanner.py..."
python "$WARP_FILE" || { echo "❌ Error while running WarpScanner.py."; exit 1; }

# =============================== ✅ Done ===============================
echo -e "\n✅ [STEALTH SYSTEM] Installation and execution completed successfully with zero errors."
