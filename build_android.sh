#!/bin/bash

# Android 构建脚本 - 自动使用 Java 21

set -e

# 设置 Java 21
export JAVA_HOME=$(/usr/libexec/java_home -v 21)

echo "=========================================="
echo "Android 构建"
echo "=========================================="
echo "使用 Java: $JAVA_HOME"
java -version
echo ""

# 执行 Flutter 构建命令
if [ "$1" = "apk" ]; then
    echo "构建 APK..."
    flutter build apk
elif [ "$1" = "appbundle" ] || [ "$1" = "bundle" ]; then
    echo "构建 App Bundle..."
    flutter build appbundle
elif [ "$1" = "debug" ]; then
    echo "构建 Debug APK..."
    flutter build apk --debug
else
    echo "用法: $0 [apk|appbundle|debug]"
    echo "  apk        - 构建 Release APK"
    echo "  appbundle  - 构建 App Bundle"
    echo "  debug      - 构建 Debug APK"
    exit 1
fi
