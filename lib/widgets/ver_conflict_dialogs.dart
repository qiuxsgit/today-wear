import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// 双端冲突弹框。返回 true=保留本机，false=用云端，null=外部关闭（不动作，按降级处理）。
Future<bool?> showVerConflictDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.verConflictTitle),
      content: Text(l10n.verConflictMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.verUseCloud),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.verKeepLocal),
        ),
      ],
    ),
  );
}

/// 云端已删除弹框。返回 true=恢复，false=接受删除。
Future<bool?> showRemoteDeletedDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.verRemoteDeletedTitle),
      content: Text(l10n.verRemoteDeletedMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.verAcceptDelete),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.verRestore),
        ),
      ],
    ),
  );
}
