import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// 账号删除确认对话框
///
/// 提示风险文案并要求用户输入密码，确认后返回密码字符串；取消返回 null。
///
/// 用法：
/// ```dart
/// final password = await DeleteAccountDialog.show(context);
/// if (password == null) return; // 取消
/// ```
class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  /// 弹出对话框并等待用户操作。
  /// 返回用户输入的密码字符串，取消返回 null。
  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (ctx) => const DeleteAccountDialog(),
    );
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.accountDeleteDialogTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.accountDeleteDialogContent),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(hintText: l10n.accountDeletePasswordHint),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(l10n.accountDeleteConfirm),
        ),
      ],
    );
  }
}
