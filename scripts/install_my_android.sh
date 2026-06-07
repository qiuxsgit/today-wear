#!/bin/bash

# ====== 定位到仓库根目录（today-wear/），允许从任意目录执行 ======

cd "$(dirname "${BASH_SOURCE[0]}")/.." || {
  echo "❌ 无法切换到仓库根目录"
  exit 1
}

# ====== 配置区 ======

NO_BUILD=false
LOCAL=false

# ====== 参数解析 ======

for arg in "$@"; do
  case $arg in
    --no-build) NO_BUILD=true ;;
    --local)    LOCAL=true ;;
    *) echo "未知参数：$arg"; exit 1 ;;
  esac
done

# ====== 设备列表 & 交互选择 ======

DEVICES=()
while IFS= read -r line; do
  DEVICES+=("$line")
done < <(adb devices | awk 'NR>1 && $2=="device" {print $1}')

if [ ${#DEVICES[@]} -eq 0 ]; then
  echo "❌ 未找到已连接的 Android 设备，请检查 USB 连接与调试授权"
  exit 1
fi

if [ ${#DEVICES[@]} -eq 1 ]; then
  DEVICE_ID="${DEVICES[0]}"
  echo "📱 检测到设备：${DEVICE_ID}"
else
  echo "📱 检测到多台设备，请选择："
  i=1
  for d in "${DEVICES[@]}"; do
    echo "   ${i}) ${d}"
    i=$(( i + 1 ))
  done
  printf "请输入编号 [1-%d]：" "${#DEVICES[@]}"
  read -r choice || { echo "❌ 已取消"; exit 1; }
  if ! echo "$choice" | grep -qE '^[0-9]+$' || \
     [ "$choice" -lt 1 ] || [ "$choice" -gt "${#DEVICES[@]}" ]; then
    echo "❌ 无效编号：${choice}"
    exit 1
  fi
  DEVICE_ID="${DEVICES[$(( choice - 1 ))]}"
  echo "📱 已选择设备：${DEVICE_ID}"
fi

START_TIME=$(date +%s)
if $NO_BUILD; then
  echo "🚀 开始安装 Android App（仅安装模式，跳过构建）..."
elif $LOCAL; then
  echo "🚀 开始更新 Android App（本地模式，跳过拉取代码）..."
else
  echo "🚀 开始更新 Android App（build + install 模式）..."
fi
echo "   开始时间：$(date '+%Y-%m-%d %H:%M:%S')"

if ! $NO_BUILD; then

  # ====== 1. 拉代码（--local 跳过） ======

  if $LOCAL; then
    echo "📥 本地模式：跳过拉取代码，使用当前工作区（分支：$(git branch --show-current)）"
  else
    BRANCH=$(git branch --show-current)
    if [ -z "$BRANCH" ]; then
      echo "❌ 当前处于 detached HEAD，无法确定分支；请先 checkout 到分支或使用 --local"
      exit 1
    fi
    echo "📥 拉取最新代码（当前分支：$BRANCH）..."
    git pull origin "$BRANCH" || {
      echo "❌ git pull 失败"
      exit 1
    }
  fi

  # ====== 2. Flutter 依赖 ======

  echo "📦 安装依赖..."
  flutter pub get || {
    echo "❌ pub get 失败"
    exit 1
  }

fi

# ====== 3. 检查设备 ======

echo "🔍 检查设备连接..."
if ! adb devices | grep -w "$DEVICE_ID" > /dev/null; then
  echo "❌ 找不到设备：${DEVICE_ID}"
  echo "   当前已连接设备："
  adb devices
  exit 1
fi

if ! $NO_BUILD; then

  # ====== 4. 构建 Android APK ======

  echo "🏗️ 构建 Android APK（flavor=apk，支付通道已关闭：DISABLE_PURCHASES=true）..."
  # 个人真机测试包：显式关闭支付通道（同 iOS 脚本逻辑）。
  # Android 构建需要 JDK 21，系统默认 Java 25 会失败。
  export JAVA_HOME=$(/usr/libexec/java_home -v 21)
  flutter build apk --release \
    --flavor apk \
    --dart-define=DIST_CHANNEL=apk \
    --dart-define=DISABLE_PURCHASES=true \
    --build-number=$(date +%y%j%H%M) || {
    echo "❌ 构建失败"
    exit 1
  }

fi

# ====== 5. 安装到设备 ======

APP_PATH="build/app/outputs/flutter-apk/app-apk-release.apk"

if [ ! -f "$APP_PATH" ]; then
  echo "❌ 找不到构建产物：$APP_PATH"
  $NO_BUILD && echo "   提示：请先执行一次完整构建（不加 --no-build）"
  exit 1
fi

echo "📱 安装到设备..."
adb -s "$DEVICE_ID" install -r "$APP_PATH" || {
  echo "❌ 安装失败，请确保 adb 已安装并设备已启用 USB 调试（brew install android-platform-tools）"
  exit 1
}

ELAPSED=$(( $(date +%s) - START_TIME ))
echo "✅ 完成！App 已安装到你的 Android 设备"
echo "   完成时间：$(date '+%Y-%m-%d %H:%M:%S')（耗时 ${ELAPSED}s）"
