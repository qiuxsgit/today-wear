#!/bin/bash

set -e

# 默认模式

BUILD_MODE="debug"

# 解析参数

for arg in "$@"
do
if [ "$arg" == "--release" ]; then
BUILD_MODE="release"
fi
done

# 设置 Java 21
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
echo "Using Java version: $JAVA_HOME"

echo "🚀 构建模式: $BUILD_MODE"

BUILD_NUMBER=$(date +%m%d%H%M)

if [ "$BUILD_MODE" == "release" ]; then
flutter build apk --release --build-number="$BUILD_NUMBER"
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
else
flutter build apk --debug --build-number="$BUILD_NUMBER"
APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
fi

# 检查结果

if [ -f "$APK_PATH" ]; then
echo "✅ 构建完成"
echo "📦 APK 路径: $APK_PATH"
else
echo "❌ 构建失败"
exit 1
fi

