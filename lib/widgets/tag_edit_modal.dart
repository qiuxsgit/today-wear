import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'package:today_wear/database/database.dart';
import '../api/tag_api.dart';
import '../services/session_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import '../theme/app_theme_tokens.dart';
import '../theme/tag_colors.dart';
import 'app_toast.dart';

/// 标签编辑 Modal
///
/// 编辑模式：修改标签名称/颜色并保存，或删除标签（若已被使用会提示并从穿搭中移除）；
/// `tag` 为 null 时是新增模式：输入名称、选颜色后创建标签
class TagEditModal extends StatefulWidget {
  final TagData? tag;

  const TagEditModal({
    super.key,
    this.tag,
  });

  /// 打开 Modal（居中显示），不传 tag 为新增模式，操作完成后返回 true 表示需要刷新列表
  static Future<bool?> show(BuildContext context, [TagData? tag]) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: context.tt.surface,
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
  late String _selectedColorHex;

  /// 是否为新增模式（未传入 tag）
  bool get _isCreate => widget.tag == null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tag?.name ?? '');
    final tagColor = widget.tag?.color ?? TagColors.defaultColorHex;
    _selectedColorHex = TagColors.presetHex.contains(tagColor)
        ? tagColor
        : TagColors.defaultColorHex;
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
      AppToast.warning(l10n.tagNameEmpty);
      return;
    }
    final ok = _isCreate
        ? await _tagDao.createTag(name, _selectedColorHex)
        : await _tagDao.updateTag(widget.tag!.id, name, _selectedColorHex);
    if (!mounted) return;
    if (ok) {
      AppToast.success(l10n.tagSaved);
      Navigator.pop(context, true);
    } else {
      AppToast.warning(l10n.tagNameDuplicate);
    }
  }

  Future<void> _onDelete() async {
    // 删除按钮仅在编辑模式渲染，此处 tag 必非空
    final tag = widget.tag!;
    final l10n = AppLocalizations.of(context)!;
    final usageCount = await _tagDao.getTagUsageCount(tag.id);
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
    final serverId = tag.serverId;
    await _tagDao.deleteTagAndRemoveFromAllOutfits(tag.id);
    // 已登录且该标签已上云时，同步删除服务端标签（避免下次拉取又复活）
    if (serverId != null && SessionService.instance.isLoggedIn) {
      TagApi().delete(serverId).catchError((e) {
        debugPrint('Tag delete sync failed: $e');
      });
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _isCreate ? l10n.tagAdd : l10n.tagEdit,
          style: AppTextStyle.title.copyWith(fontSize: 18, color: tt.ink),
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
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.tagColor,
          style: AppTextStyle.body.copyWith(
            color: tt.muted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: TagColors.presetHex.map((hex) {
            final isSelected = _selectedColorHex == hex;
            return GestureDetector(
              onTap: () => setState(() => _selectedColorHex = hex),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: TagColors.fromHex(hex),
                  shape: BoxShape.circle,
                  border: Border.all(
                    // 色样恒为浅色粉彩，未选中描边固定浅灰；选中描边用主题主色
                    color: isSelected ? tt.ink : AppColors.bgTertiary,
                    width: isSelected ? 2.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              // 新增模式无可删对象，左侧按钮换为取消
              child: _isCreate
                  ? OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: tt.muted,
                        side: BorderSide(color: tt.line),
                      ),
                      child: Text(l10n.cancel),
                    )
                  : OutlinedButton(
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
                  backgroundColor: tt.ink,
                  foregroundColor: tt.page,
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
