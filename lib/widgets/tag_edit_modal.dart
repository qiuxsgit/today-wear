import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'package:today_wear/database/database.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

/// 标签编辑 Modal
///
/// 支持修改标签名称并保存，或删除标签（若已被使用会提示并从穿搭中移除）
class TagEditModal extends StatefulWidget {
  final TagData tag;

  const TagEditModal({
    super.key,
    required this.tag,
  });

  /// 打开编辑 Modal（居中显示），操作完成后返回 true 表示需要刷新列表
  static Future<bool?> show(BuildContext context, TagData tag) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: AppColors.bgPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
          ),
          child: TagEditModal(tag: tag),
        ),
      ),
    );
  }

  @override
  State<TagEditModal> createState() => _TagEditModalState();
}

class _TagEditModalState extends State<TagEditModal> {
  late final TextEditingController _nameController;
  late final _tagDao = AppDatabase().tagDao;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tag.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tagNameEmpty)),
      );
      return;
    }
    final ok = await _tagDao.updateTagName(widget.tag.id, name);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tagSaved)),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tagNameDuplicate)),
      );
    }
  }

  Future<void> _onDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final usageCount = await _tagDao.getTagUsageCount(widget.tag.id);
    if (!mounted) return;

    final String message = usageCount > 0
        ? l10n.tagDeleteConfirmInUse(usageCount)
        : l10n.tagDeleteConfirm;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await _tagDao.deleteTagAndRemoveFromAllOutfits(widget.tag.id);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.tagEdit,
          style: AppTextStyle.title.copyWith(fontSize: 18),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.tagName,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
          ),
          textCapitalization: TextCapitalization.none,
          autofocus: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _onDelete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: Text(l10n.delete),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: FilledButton(
                onPressed: _onSave,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
