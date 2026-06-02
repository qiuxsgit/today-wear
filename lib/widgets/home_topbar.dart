import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_text_style.dart';
import '../theme/app_theme_tokens.dart';

/// 首页顶部标题栏：日期眉题 + 主标题 + 新增按钮
class HomeTopBar extends StatelessWidget {
  final VoidCallback? onAdd;

  const HomeTopBar({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeDateLabel(now.weekday, now.month, now.day),
                  style: AppTextStyle.eyebrow.copyWith(color: tt.muted),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.homeAppTitle,
                  style: AppTextStyle.displayTitle.copyWith(color: tt.ink),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: tt.surface,
                shape: BoxShape.circle,
                border: Border.all(color: tt.line),
                boxShadow: const [
                  BoxShadow(color: Color(0x14554230), blurRadius: 18, offset: Offset(0, 8)),
                ],
              ),
              child: Icon(Icons.add, size: 20, color: tt.ink),
            ),
          ),
        ],
      ),
    );
  }
}

/// 首页标签筛选栏
class HomeFilterChips extends StatefulWidget {
  const HomeFilterChips({super.key});

  @override
  State<HomeFilterChips> createState() => _HomeFilterChipsState();
}

class _HomeFilterChipsState extends State<HomeFilterChips> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tt = context.tt;
    final labels = [
      l10n.filterAll,
      l10n.filterCommute,
      l10n.filterDate,
      l10n.filterRainy,
      l10n.filterCasual,
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: List.generate(labels.length, (i) {
            final isActive = i == _activeIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _activeIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? tt.ink : tt.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: isActive ? null : Border.all(color: tt.line),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive ? const Color(0xFFFFFAF4) : tt.muted,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
