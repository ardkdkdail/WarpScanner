#!/data/data/com.termux/files/usr/bin/bash

set -e

# 🌟 STEALTH SYSTEM LAUNCH
echo -e "\n🔰 \e[1;36m[STEALTH SYSTEM]\e[0m Launching \e[1;35mNext-Gen Smart Installer\e[0m..."
sleep 1

# ✅ PATH CHECKER FUNCTION
check_installed_path() {
    local name="$1"
    local path="$2"
    if [ -x "$path" ]; then
        echo -e "✅ \e[1;32m$name is present:\e[0m $path"
        return 0
    else
        echo -e "❌ \e[1;33m$name not found. Installing...\e[0m"
        return 1
    fi
}

# 📦 INSTALL FUNCTION IF NOT PRESENT
install_if_needed() {
    local name="$1"
    local cmd="$2"
    local pkg="$3"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo -e "📦 \e[1;33m$name not found. Installing $pkg...\e[0m"
        pkg install -y "$pkg" || { echo "❌ Failed to install $pkg"; exit 1; }
    else
        echo -e "✅ \e[1;32m$name already installed.\e[0m"
    fi
}

# 🔍 CHECK AND INSTALL BINARIES
echo -e "\n📦 \e[1;36mChecking and installing dependencies...\e[0m"

check_installed_path "Python"   "/data/data/com.termux/files/usr/bin/python"   || install_if_needed "Python" python python
check_installed_path "Pip"      "/data/data/com.termux/files/usr/bin/pip"      || install_if_needed "Pip" pip python
check_installed_path "Git"      "/data/data/com.termux/files/usr/bin/git"      || install_if_needed "Git" git git
check_installed_path "Wget"     "/data/data/com.termux/files/usr/bin/wget"     || install_if_needed "Wget" wget wget
check_installed_path "Curl"     "/data/data/com.termux/files/usr/bin/curl"     || install_if_needed "Curl" curl curl
check_installed_path "Tar"      "/data/data/com.termux/files/usr/bin/tar"      || install_if_needed "Tar" tar tar
check_installed_path "Unzip"    "/data/data/com.termux/files/usr/bin/unzip"    || install_if_needed "Unzip" unzip unzip
check_installed_path "Clang"    "/data/data/com.termux/files/usr/bin/clang"    || install_if_needed "Clang" clang clang
check_installed_path "Rust"     "/data/data/com.termux/files/usr/bin/rustc"    || install_if_needed "Rust" rust rust
check_installed_path "CMake"    "/data/data/com.termux/files/usr/bin/cmake"    || install_if_needed "CMake" cmake cmake
check_installed_path "Make"     "/data/data/com.termux/files/usr/bin/make"     || install_if_needed "Make" make make
check_installed_path "openssl"  "/data/data/com.termux/files/usr/bin/openssl"  || install_if_needed "OpenSSL" openssl openssl-tool

# 🐍 PYTHON MODULES
echo -e "\n🐍 \e[1;34mEnsuring pip and modules are ready...\e[0m"
pip install --upgrade pip setuptools wheel || { echo "❌ Failed to upgrade pip"; exit 1; }

ensure_python_module() {
    local module="$1"
    if ! python -c "import $module" >/dev/null 2>&1; then
        echo -e "📥 Installing Python module: $module"
        pip install "$module" || { echo "❌ Failed to install $module"; exit 1; }
    else
        echo -e "✅ \e[1;32mPython module '$module' already installed.\e[0m"
    fi
}

ensure_python_module cryptography
ensure_python_module requests
ensure_python_module rich
ensure_python_module retrying

# 📁 WarpScanner Setup
WARP_FILE="WarpScanner.py"
WARP_URL="https://raw.githubusercontent.com/ardkdkdail/WarpScanner/main/WarpScanner.py"

echo -e "\n📁 \e[1;36mChecking WarpScanner.py...\e[0m"

download_warp() {
    echo -e "⬇️ Downloading WarpScanner.py..."
    curl -fsSL -o "$WARP_FILE" "$WARP_URL" || { echo "❌ Failed to download WarpScanner.py"; exit 1; }
}

if [ ! -f "$WARP_FILE" ]; then
    download_warp
else
    FIRST_LINE=$(head -n 1 "$WARP_FILE")
    if [[ "$FIRST_LINE" == "import urllib.request" ]] || [[ "$FIRST_LINE" != V=* ]]; then
        echo -e "⚠️ Outdated or invalid WarpScanner.py detected. Re-downloading..."
        download_warp
    else
        echo -e "✅ \e[1;32mWarpScanner.py is valid and up-to-date.\e[0m"
    fi
fi

# 🚀 EXECUTE
echo -e "\n🚀 \e[1;35mRunning WarpScanner.py...\e[0m"
python "$WARP_FILE" || { echo "❌ Error running WarpScanner.py"; exit 1; }

# 🎉 SUCCESS MESSAGE
echo -e "\n🎉 \e[1;36m[STEALTH SYSTEM]\e[0m All operations completed \e[1;32msuccessfully\e[0m with \e[1;32mZERO errors\e[0m."
