#!/bin/bash

# Android 运行脚本：使用 JDK 17/21 启动，避免 Java 25 与 Gradle Kotlin 不兼容
# 用法: ./flutter_run_android.sh [flutter run 的其他参数...]

set -e

JAVA_17=$(/usr/libexec/java_home -v 17 2>/dev/null || true)
JAVA_21=$(/usr/libexec/java_home -v 21 2>/dev/null || true)

if [ -n "$JAVA_17" ]; then
  export JAVA_HOME="$JAVA_17"
  echo "使用 JDK 17: $JAVA_HOME"
elif [ -n "$JAVA_21" ]; then
  export JAVA_HOME="$JAVA_21"
  echo "使用 JDK 21: $JAVA_HOME"
else
  echo "错误: 未找到 JDK 17 或 21。Android 构建需要 JDK 17/21，请安装后再试。" >&2
  exit 1
fi

exec flutter run "$@"
