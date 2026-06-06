---
paths:
  - "**/scripts/**"
---

# Shell 脚本规范（scripts/）

## [重要] bash 3.2 兼容（macOS 自带 bash）

- 变量后紧跟全角字符（如 `（`）会被吞字节产生乱码，必须加大括号。
  - ✅ `echo "平台：${PLATFORM}（debug 模式）"`
  - ❌ `echo "平台：$PLATFORM（debug 模式）"`
- 不可用 bash 4+ 特性：`mapfile` / `readarray` / `local -n` / `${var,,}`。
  收集多行输出用 `while IFS= read -r line; do ...; done < <(cmd)`。

## 通用约定

- 脚本开头 cd 到仓库根，支持从任意目录执行：
  `cd "$(dirname "${BASH_SOURCE[0]}")/.." || { echo "❌ 无法切换到仓库根目录"; exit 1; }`
- 不用 `set -e`，关键命令显式错误处理：`cmd || { echo "❌ ..."; exit 1; }`
- 日志用 emoji 前缀：🚀 开始 / 🔍 检查 / 📱 设备 / ⏳ 等待 / ✅ 成功 / ❌ 失败 / ⚠️ 警告
- 交互式 `read` 必须处理 EOF，否则 stdin 关闭时死循环：
  `read -r choice || { echo "❌ 已取消"; exit 1; }`

## flutter CLI 实测限制

- `flutter emulators` 不支持 `--machine`（仅 `flutter devices --machine` 有 JSON 输出），
  需解析其 `Id • Name • Manufacturer • Platform` 表格。
- `flutter devices --machine` 的 JSON 前可能混入告警行，解析前先定位首个 `[`。
- Android 构建必须显式 `export JAVA_HOME=$(/usr/libexec/java_home -v 21)`，
  系统默认 Java 25 会失败（参见 build_android.sh / run_debug.sh）。
