---
name: harness-update
description: 将开发中发现的规范、错误模式或新约定沉淀到 harness 上下文文档中。当用户提到"记住这个规范"、"以后别再犯这个错"、"更新规则"、"加条规范"、"这个模式要记下来"、"更新 CLAUDE.md"、"加个 rule"时触发此 skill。
---

# Harness Update Skill

## 角色设定

你是 **AI DevOps 工程师**，负责将开发经验沉淀到 harness 上下文文档，确保 AI 在后续对话中能直接使用这些规范。

---

## 文件结构

```
CLAUDE.md                          # 项目级：结构、命令、核心约定（上限 120 行）
.claude/rules/
├── coding/                        # 编码规范（按需加载）
│   ├── flutter.md                 # Dart/Flutter 语法、命名、文件结构
│   ├── ui.md                      # Widget 写法、Theme、布局模式
│   └── database.md                # Drift 表定义、DAO、Migration
└── biz/                           # 业务规则（按需加载）
    └── domain.md                  # 穿搭、标签、图片的业务逻辑
```

Rules 文件不存在时按需创建，每个文件上限 80 行。

---

## 写入决策表

| 内容类型 | 目标文件 |
|---------|---------|
| 项目结构变更（新增目录/模块） | `CLAUDE.md` → Architecture 段落 |
| 构建/开发命令变更 | `CLAUDE.md` → Development Commands 段落 |
| 新增 pub 依赖说明 | `CLAUDE.md` → Key Dependencies 段落 |
| Dart 语法、命名、文件结构约定 | `.claude/rules/coding/flutter.md` |
| Widget 写法、Theme 使用、布局模式 | `.claude/rules/coding/ui.md` |
| Drift 表定义、DAO 写法、Migration | `.claude/rules/coding/database.md` |
| 穿搭/标签/图片的业务规则 | `.claude/rules/biz/domain.md` |
| AI 协作行为（提问时机、执行策略） | `.claude/rules/coding/flutter.md` 末尾 ## AI 协作 段落 |

**跨多类型**：写主导类型所在文件，其余在条目中注明 `See also: <file>`。

---

## 工作流

### 步骤一：理解内容

从用户描述中提取：
- 这是什么规范（编码约定？错误教训？业务规则？）
- 触发场景（什么时候 AI 需要用到它？）

用一句话确认理解是否正确。

### 步骤二：确定写入位置

按决策表选定目标文件，告知用户。

### 步骤三：读取目标文件

1. 读取目标文件（不存在则跳过）
2. 检查是否有重复或冲突条目：
   - 重复：提示用户，建议合并
   - 冲突：提示用户，让用户决定保留哪个
3. 确认插入位置（同类规范放在一起）

### 步骤四：生成条目

按目标文件既有格式撰写，要求：
- 简洁：单条规范不超过 5 行
- 具体：给出 ✅ 正确写法 和 ❌ 错误写法
- 可操作：AI 读了直接照做

**向用户展示即将写入的内容和位置，等待确认后再写入。**

### 步骤五：写入并验证

1. 写入条目
2. 检查文件行数：
   - `CLAUDE.md` 超 120 行：提示将扩展内容迁移到对应 rules 文件
   - `rules/*.md` 超 80 行：提示拆分为更细粒度的文件
3. 输出结果：

```
✅ 规范已写入
文件：.claude/rules/ui-patterns.md
位置：## AppColors 使用（新增段落）
```

---

## 特殊场景

### "AI 总是忘记 / 以后别再犯"

将该条目置于对应 rules 文件靠前位置，并加 **[重要]** 标记。

### 从 CLAUDE.md 拆分

当 CLAUDE.md 超长，且超出部分属于编码规范（非项目结构/命令），将其迁移到对应 rules 文件，在 CLAUDE.md 原位置替换为一行引用注释：
```
<!-- 详见 .claude/rules/flutter-coding.md -->
```

---

## 注意事项

- 等用户确认后再写入，不自作主张
- 不删除已有规范，除非用户明确要求替换
- 每次只改一个文件
- 不使用 git add / commit，提交由用户决定
