#!/bin/bash

# 在指定平台的模拟器/真机上以 debug 模式启动 Flutter 客户端（前台 flutter run，支持热重载）。
# 用法：
#   ./scripts/run_debug.sh                          # 默认 iOS
#   ./scripts/run_debug.sh --platform=android       # Android
#   ./scripts/run_debug.sh -- --dart-define=FOO=bar # -- 之后的参数原样透传给 flutter run

# ====== 定位到仓库根目录（today-wear/），允许从任意目录执行 ======

cd "$(dirname "${BASH_SOURCE[0]}")/.." || {
  echo "❌ 无法切换到仓库根目录"
  exit 1
}

# ====== 依赖检查 ======

command -v flutter > /dev/null || { echo "❌ 未找到 flutter 命令"; exit 1; }
command -v python3 > /dev/null || { echo "❌ 未找到 python3 命令"; exit 1; }

# ====== 参数解析 ======

PLATFORM="ios"
PASSTHROUGH=()

while [ $# -gt 0 ]; do
  case "$1" in
    --platform=ios|--platform=android)
      PLATFORM="${1#--platform=}"
      ;;
    --platform=*)
      echo "❌ 不支持的平台：${1#--platform=}（仅支持 ios / android）"
      exit 1
      ;;
    --)
      shift
      PASSTHROUGH=("$@")
      break
      ;;
    *)
      echo "❌ 未知参数：$1"
      echo "   用法：$0 [--platform={ios,android}] [-- <flutter run 参数...>]"
      exit 1
      ;;
  esac
  shift
done

echo "🚀 平台：${PLATFORM}（debug 模式）"

# TEMP: 任务 2 会替换为设备发现逻辑
echo "（参数解析完成，透传参数 ${#PASSTHROUGH[@]} 个）"
