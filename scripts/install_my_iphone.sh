#!/bin/bash

# ====== 定位到仓库根目录（today-wear/），允许从任意目录执行 ======

cd "$(dirname "${BASH_SOURCE[0]}")/.." || {
  echo "❌ 无法切换到仓库根目录"
  exit 1
}

# ====== 配置区 ======

DEVICE_ID="00008101-001035DA3EE1001E"
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

START_TIME=$(date +%s)
if $NO_BUILD; then
  echo "🚀 开始安装 iOS App（仅安装模式，跳过构建）..."
elif $LOCAL; then
  echo "🚀 开始更新 iOS App（本地模式，跳过拉取代码）..."
else
  echo "🚀 开始更新 iOS App（build + install 模式）..."
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
if ! flutter devices | grep "$DEVICE_ID" > /dev/null; then
  echo "❌ 找不到设备：$DEVICE_ID"
  exit 1
fi

if ! $NO_BUILD; then

  # ====== 4. 构建 iOS App ======

  echo "🏗️ 构建 iOS App（支付通道已关闭：DISABLE_PURCHASES=true）..."
  # 个人真机测试包：显式关闭支付通道（内置 Test Store key 在 release 下会被
  # RevenueCat 原生层 fatal）。正式发版不走本脚本，不带此开关 → 误带测试 key
  # 会直接起不来，不会静默发出免费版。
  flutter build ios --release --dart-define=DISABLE_PURCHASES=true --build-number=$(date +%Y%m%d%H%M) || {
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
