import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'package:today_wear/database/database.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_tokens.dart';
import '../services/ver_check_service.dart';
import '../theme/tag_colors.dart';
import '../widgets/tag_edit_modal.dart';
import '../widgets/ver_conflict_dialogs.dart';

/// 标签管理页面
///
/// 小卡片平铺展示标签列表，点击打开编辑 Modal（修改名称或删除）；
/// 导航栏右侧圆形按钮可弹窗新增标签
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
    // 编辑前记录级 ver 读校验（1.5s 超时降级），避免基于旧标签数据编辑
    final result = await VerCheckService.instance.checkTag(tag.id);
    if (!mounted) return;
    var current = tag;
    switch (result.status) {
      case VerCheckStatus.refreshed:
        current = (await _tagDao.getTagById(tag.id)) ?? tag;
        if (!mounted) return;
      case VerCheckStatus.conflict:
        final keepLocal = await showVerConflictDialog(context);
        if (!mounted) return;
        if (keepLocal == true) {
          await VerCheckService.instance.keepLocalTag(tag.id, result.remote!);
        } else if (keepLocal == false) {
          await VerCheckService.instance.useCloudTag(result.remote!);
          current = (await _tagDao.getTagById(tag.id)) ?? tag;
          if (!mounted) return;
          _loadTags();
        } else {
          return; // 外部关闭：不进入编辑
        }
      case VerCheckStatus.skipped:
      case VerCheckStatus.upToDate:
      case VerCheckStatus.remoteDeleted: // 标签硬删走 404→skipped，理论不达，降级进入编辑
        break;
    }
    if (!mounted) return;
    final refresh = await TagEditModal.show(context, current);
    if (refresh == true && mounted) {
      _loadTags();
    }
  }

  Future<void> _openCreateModal() async {
    final refresh = await TagEditModal.show(context);
    if (refresh == true && mounted) {
      _loadTags();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;

    return Scaffold(
      backgroundColor: tt.page,
      appBar: AppBar(
        backgroundColor: tt.page,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: _RoundBtn(
          icon: Icons.arrow_back_ios_new,
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _loading ? l10n.tagManagement : l10n.tagManagementWithCount(_tags.length),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: tt.ink),
        ),
        centerTitle: true,
        actions: [
          _RoundBtn(
            icon: Icons.add,
            onTap: _openCreateModal,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tags.isEmpty
              ? Center(
                  child: Text(
                    l10n.tagNoTags,
                    style: AppTextStyle.body.copyWith(
                      color: tt.muted,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _tags.map((tag) {
                      final tagColor = TagColors.fromHex(tag.color ?? TagColors.defaultColorHex);
                      return InkWell(
                        onTap: () => _openEditModal(tag),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              // 标签底色恒为浅色粉彩，描边/文字固定深浅保证对比度，不随主题切换
                              color: AppColors.bgTertiary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tag.name,
                            style: AppTextStyle.body.copyWith(
                              fontSize: 14,
                              color: AppColors.warmMuted,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    // AppBar 的 leading/actions 会施加紧约束把子组件撑满，
    // 外层包 Center 释放约束，保证 42×42 尺寸生效（与提醒列表页 _RoundBtn 一致）
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: tt.surface,
            shape: BoxShape.circle,
            border: Border.all(color: tt.line),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x14554230),
                  blurRadius: 18,
                  offset: Offset(0, 8)),
            ],
          ),
          child: Icon(icon, size: 18, color: tt.ink),
        ),
      ),
    );
  }
}
