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

# ====== 设备发现 ======

# 输出该平台候选设备（模拟器+真机），每行：id<TAB>名称<TAB>类型（模拟器/真机）
list_devices() {
  flutter devices --machine | python3 -c '
import json, sys

platform = sys.argv[1]
prefix = "ios" if platform == "ios" else "android-"
text = sys.stdin.read()
devices = json.loads(text[text.find("["):])
for d in devices:
    tp = d.get("targetPlatform", "")
    if not tp.startswith(prefix):
        continue
    kind = "模拟器" if d.get("emulator") else "真机"
    print(d["id"] + "\t" + d["name"] + "\t" + kind)
' "$PLATFORM"
}

# 把候选设备收集到数组 DEVICE_LINES（兼容 bash 3.2，不用 mapfile）
collect_devices() {
  DEVICE_LINES=()
  while IFS= read -r line; do
    [ -n "$line" ] && DEVICE_LINES+=("$line")
  done < <(list_devices)
}

# 从候选行中选一行（单行直接选中，多行编号选择），结果写入 SELECTED_LINE
select_line() {
  local prompt="$1"
  shift
  local lines=("$@")
  local count=${#lines[@]}

  if [ "$count" -eq 1 ]; then
    SELECTED_LINE="${lines[0]}"
    return
  fi

  echo "$prompt"
  local i=1
  local line name kind
  for line in "${lines[@]}"; do
    name=$(printf '%s' "$line" | cut -f2)
    kind=$(printf '%s' "$line" | cut -f3)
    if [ -n "$kind" ]; then
      echo "  $i) $name [$kind]"
    else
      echo "  $i) $name"
    fi
    i=$((i + 1))
  done

  local choice
  while true; do
    printf '请输入编号 (1-%s)：' "$count"
    read -r choice || { echo ""; echo "❌ 已取消（输入结束）"; exit 1; }
    if printf '%s' "$choice" | grep -qE '^[0-9]+$' \
       && [ "$choice" -ge 1 ] && [ "$choice" -le "$count" ]; then
      SELECTED_LINE="${lines[$((choice - 1))]}"
      return
    fi
    echo "❌ 无效输入，请重新输入"
  done
}

echo "🔍 检查 $PLATFORM 可用设备..."
collect_devices

# ====== 设备决策 + 运行 ======

if [ ${#DEVICE_LINES[@]} -eq 0 ]; then
  # TEMP: 任务 4 会替换为模拟器启动流程
  echo "❌ 没有检测到 $PLATFORM 可用设备"
  exit 1
fi

select_line "🔢 检测到 ${#DEVICE_LINES[@]} 台 $PLATFORM 设备，请选择：" "${DEVICE_LINES[@]}"
DEVICE_ID=$(printf '%s' "$SELECTED_LINE" | cut -f1)
DEVICE_NAME=$(printf '%s' "$SELECTED_LINE" | cut -f2)
DEVICE_KIND=$(printf '%s' "$SELECTED_LINE" | cut -f3)

echo "📱 启动 flutter run --debug（$DEVICE_NAME [$DEVICE_KIND]）..."
exec flutter run --debug -d "$DEVICE_ID" "${PASSTHROUGH[@]}"
