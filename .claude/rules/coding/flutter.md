# Flutter 编码规范

## [重要] 代码质量门控

每次编写完代码后，必须执行：

```bash
flutter analyze
```

要求：
- ✅ 零 warnings、零 errors、零 hints
- ✅ 代码可正常编译运行
- ❌ 不允许任何导致编译失败的错误存在
- ❌ 不允许提交或报告"完成"前存在未解决的 analyzer 问题

## [重要] API 层 401 语义

`ApiClient` 收到 401 时仅在 `code != 'invalid_credentials'` 时触发 `onUnauthorized`
（清会话跳登录）。`invalid_credentials` 是业务校验失败（登录密码错、删除账号二次
确认密码错），**不得**清当前会话。改动 401 处理前先跑
`test/account_deletion_test.dart` 的守卫断言。

## Color 转 hex

Color 取 RGB 用 `toARGB32()`（Flutter 3.27+），`.value` 已废弃：

✅ `(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')`
❌ `c.value.toRadixString(16)`
