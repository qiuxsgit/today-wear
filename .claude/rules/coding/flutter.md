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
