#!/bin/bash

# Flutter Android 环境一键配置脚本
# 适用于通过 Homebrew 安装的 Android Command Line Tools，将组件链接到 SDK 目录并配置 Flutter

set -e

ANDROID_SDK="$HOME/Library/Android/sdk"
HOMEBREW_SDK="/opt/homebrew/share/android-commandlinetools"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "Flutter Android 环境配置"
echo "=========================================="
echo ""

# 1. 检查 Flutter
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter 未安装，请先安装 Flutter${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Flutter 已安装${NC}"

# 1.5. 配置 Java 21
echo ""
echo "配置 Java 21..."
if /usr/libexec/java_home -v 21 &> /dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 21)
    echo -e "${GREEN}✓ Java 21 已设置: $JAVA_HOME${NC}"
    java -version
else
    echo -e "${RED}❌ 未找到 Java 21，请先安装${NC}"
    echo "可以使用: brew install openjdk@21"
    exit 1
fi

# 2. 检查 Homebrew Android 组件
if [ ! -d "$HOMEBREW_SDK" ]; then
    echo -e "${YELLOW}⚠ 未找到 Homebrew 安装的 Android SDK${NC}"
    echo "请先执行: brew install --cask android-commandlinetools"
    echo ""
    echo "若已通过其他方式安装 SDK，请确保 ANDROID_HOME 指向正确路径，然后执行："
    echo "  flutter config --android-sdk \$ANDROID_HOME"
    echo "  flutter doctor --android-licenses"
    exit 1
fi
echo -e "${GREEN}✓ 找到 Android Command Line Tools${NC}"

# 3. 创建 SDK 目录并链接组件
mkdir -p "$ANDROID_SDK"/{platforms,build-tools,platform-tools,cmdline-tools}
echo ""
echo "配置 SDK 组件..."

# cmdline-tools（flutter doctor --android-licenses 依赖）
if [ -d "$HOMEBREW_SDK/cmdline-tools/latest" ]; then
    ln -sf "$HOMEBREW_SDK/cmdline-tools/latest" "$ANDROID_SDK/cmdline-tools/latest"
    [ -f "$ANDROID_SDK/cmdline-tools/latest/bin/sdkmanager" ] && echo -e "${GREEN}✓ cmdline-tools (sdkmanager)${NC}" || echo -e "${YELLOW}⚠ cmdline-tools 链接异常${NC}"
else
    echo -e "${YELLOW}⚠ 未找到 cmdline-tools/latest${NC}"
fi

# platform-tools（adb）
if [ -d "$HOMEBREW_SDK/platform-tools" ]; then
    rm -rf "$ANDROID_SDK/platform-tools" 2>/dev/null
    ln -sf "$HOMEBREW_SDK/platform-tools" "$ANDROID_SDK/platform-tools"
    [ -f "$ANDROID_SDK/platform-tools/adb" ] && echo -e "${GREEN}✓ platform-tools (adb)${NC}" || echo -e "${YELLOW}⚠ platform-tools 链接异常${NC}"
else
    echo -e "${YELLOW}⚠ 未找到 platform-tools${NC}"
fi

# Android 36 平台
if [ -d "$HOMEBREW_SDK/platforms/android-36" ]; then
    ln -sf "$HOMEBREW_SDK/platforms/android-36" "$ANDROID_SDK/platforms/android-36"
    echo -e "${GREEN}✓ Android 36 平台${NC}"
fi

# Android 34 平台（备用）
if [ -d "$HOMEBREW_SDK/platforms/android-34" ]; then
    ln -sf "$HOMEBREW_SDK/platforms/android-34" "$ANDROID_SDK/platforms/android-34"
    echo -e "${GREEN}✓ Android 34 平台（备用）${NC}"
fi

# build-tools 28.0.3
if [ -d "$HOMEBREW_SDK/build-tools/28.0.3" ]; then
    ln -sf "$HOMEBREW_SDK/build-tools/28.0.3" "$ANDROID_SDK/build-tools/28.0.3"
    echo -e "${GREEN}✓ build-tools 28.0.3${NC}"
fi

# 4. 配置 Flutter
echo ""
echo "配置 Flutter..."
flutter config --android-sdk "$ANDROID_SDK"
echo -e "${GREEN}✓ Flutter Android SDK 已设置${NC}"

# 5. 更新 local.properties
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_SDK=$(which flutter | sed 's|/bin/flutter||')
mkdir -p "$SCRIPT_DIR/android"
cat > "$SCRIPT_DIR/android/local.properties" << EOF
flutter.sdk=$FLUTTER_SDK
sdk.dir=$ANDROID_SDK
EOF
echo -e "${GREEN}✓ android/local.properties 已更新${NC}"

# 6. 环境变量写入 ~/.zshrc
if [ -f "$HOME/.zshrc" ]; then
    # 添加 Java 21 配置
    if ! grep -q "JAVA_HOME.*java_home.*21" "$HOME/.zshrc"; then
        cat >> "$HOME/.zshrc" << 'ENVEOF'

# Java 21 for Android builds
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
ENVEOF
        echo -e "${GREEN}✓ 已添加 Java 21 配置到 ~/.zshrc${NC}"
    fi
    
    # 添加 Android SDK 配置
    if ! grep -q "ANDROID_HOME" "$HOME/.zshrc"; then
        cat >> "$HOME/.zshrc" << 'ENVEOF'

# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
ENVEOF
        echo -e "${GREEN}✓ 已添加 ANDROID_HOME 到 ~/.zshrc${NC}"
    fi
fi

# 7. 接受 Android 许可证
echo ""
echo "接受 Android 许可证..."
export ANDROID_HOME="$ANDROID_SDK"
export PATH="$PATH:$ANDROID_SDK/platform-tools:$ANDROID_SDK/cmdline-tools/latest/bin"
# 确保使用 Java 21
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
yes | flutter doctor --android-licenses 2>/dev/null || {
    echo -e "${YELLOW}⚠ 请手动执行: flutter doctor --android-licenses${NC}"
}

# 8. 验证
echo ""
echo "=========================================="
echo "验证配置"
echo "=========================================="
flutter doctor -v | grep -A 14 "Android toolchain" || true

echo ""
echo -e "${GREEN}✅ 配置完成。${NC}"
echo ""
echo "重要提示："
echo "1. 若刚添加环境变量，请执行: source ~/.zshrc"
echo "2. 构建 Android 前，请确保使用 Java 21:"
echo "   export JAVA_HOME=\$(/usr/libexec/java_home -v 21)"
echo "3. 然后可运行: flutter run 或 flutter build apk"
