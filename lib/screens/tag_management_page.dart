import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'package:today_wear/database/database.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';
import '../widgets/tag_edit_modal.dart';

/// 标签管理页面
///
/// 小卡片平铺展示标签列表，点击打开编辑 Modal（修改名称或删除）
class TagManagementPage extends StatefulWidget {
  const TagManagementPage({super.key});

  @override
  State<TagManagementPage> createState() => _TagManagementPageState();
}

class _TagManagementPageState extends State<TagManagementPage> {
  List<TagData> _tags = [];
  bool _loading = true;
  late final _tagDao = AppDatabase().tagDao;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    setState(() => _loading = true);
    final list = await _tagDao.getAllTags();
    if (mounted) {
      setState(() {
        _tags = list;
        _loading = false;
      });
    }
  }

  Future<void> _openEditModal(TagData tag) async {
    final refresh = await TagEditModal.show(context, tag);
    if (refresh == true && mounted) {
      _loadTags();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(l10n.tagManagement, style: AppTextStyle.title),
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tags.isEmpty
              ? Center(
                  child: Text(
                    l10n.tagNoTags,
                    style: AppTextStyle.body.copyWith(
                      color: AppColors.textPlaceholder,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _tags.map((tag) {
                      return InkWell(
                        onTap: () => _openEditModal(tag),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.bgTertiary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tag.name,
                            style: AppTextStyle.body.copyWith(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
