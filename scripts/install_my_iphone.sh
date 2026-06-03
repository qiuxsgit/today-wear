#!/bin/bash

# ====== 配置区 ======

DEVICE_ID="00008101-001035DA3EE1001E"
BRANCH="main"
NO_BUILD=false

# ====== 参数解析 ======

for arg in "$@"; do
  case $arg in
    --no-build) NO_BUILD=true ;;
    *) echo "未知参数：$arg"; exit 1 ;;
  esac
done

START_TIME=$(date +%s)
if $NO_BUILD; then
  echo "🚀 开始安装 iOS App（仅安装模式，跳过构建）..."
else
  echo "🚀 开始更新 iOS App（build + install 模式）..."
fi
echo "   开始时间：$(date '+%Y-%m-%d %H:%M:%S')"

if ! $NO_BUILD; then

  # ====== 1. 拉代码 ======

  echo "📥 拉取最新代码..."
  git fetch origin

  git checkout $BRANCH 2>/dev/null
  git pull origin $BRANCH || {
    echo "❌ git pull 失败"
    exit 1
  }

  # ====== 2. Flutter 依赖 ======

  echo "📦 安装依赖..."
  flutter pub get || {
    echo "❌ pub get 失败"
    exit 1
  }

fi

# ====== 3. 检查设备 ======

echo "🔍 检查设备连接..."
if ! flutter devices | grep "$DEVICE_ID" > /dev/null; then
  echo "❌ 找不到设备：$DEVICE_ID"
  exit 1
fi

if ! $NO_BUILD; then

  # ====== 4. 构建 iOS App ======

  echo "🏗️ 构建 iOS App..."
  flutter build ios --release --build-number=$(date +%Y%m%d%H%M) || {
    echo "❌ 构建失败"
    exit 1
  }

fi

# ====== 5. 安装到设备 ======

APP_PATH="build/ios/iphoneos/Runner.app"

if [ ! -d "$APP_PATH" ]; then
  echo "❌ 找不到构建产物：$APP_PATH"
  $NO_BUILD && echo "   提示：请先执行一次完整构建（不加 --no-build）"
  exit 1
fi

echo "📱 安装到设备..."
ios-deploy --id $DEVICE_ID --bundle $APP_PATH --no-wifi || {
  echo "❌ 安装失败，请确保已安装 ios-deploy (brew install ios-deploy)"
  exit 1
}

ELAPSED=$(( $(date +%s) - START_TIME ))
echo "✅ 完成！App 已安装到你的 iPhone"
echo "   完成时间：$(date '+%Y-%m-%d %H:%M:%S')（耗时 ${ELAPSED}s）"
