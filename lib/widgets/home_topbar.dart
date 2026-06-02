import 'package:flutter/material.dart';
import '../theme/app_text_style.dart';
import '../theme/app_theme_tokens.dart';

/// 首页顶部标题栏：日期眉题 + 主标题 + 新增按钮
class HomeTopBar extends StatelessWidget {
  final VoidCallback? onAdd;

  const HomeTopBar({super.key, this.onAdd});

  String _weekdayLabel(DateTime date) {
    const days = ['一', '二', '三', '四', '五', '六', '日'];
    return '週${days[date.weekday - 1]}，${date.month}月${date.day}日';
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final ink = tt.ink;
    final surface = tt.surface;
    final line = tt.line;

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
                  _weekdayLabel(DateTime.now()),
                  style: AppTextStyle.eyebrow.copyWith(color: tt.muted),
                ),
                const SizedBox(height: 3),
                Text(
                  '今日穿什麼',
                  style: AppTextStyle.displayTitle.copyWith(color: ink),
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
                color: surface,
                shape: BoxShape.circle,
                border: Border.all(color: line),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14554230),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(Icons.add, size: 20, color: ink),
            ),
          ),
        ],
      ),
    );
  }
}

/// 首页标签筛选栏（视觉效果，暂不过滤数据）
class HomeFilterChips extends StatefulWidget {
  const HomeFilterChips({super.key});

  @override
  State<HomeFilterChips> createState() => _HomeFilterChipsState();
}

class _HomeFilterChipsState extends State<HomeFilterChips> {
  String _active = '全部';

  static const _labels = ['全部', '通勤', '約會', '雨天', '休閒'];

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final ink = tt.ink;
    final surface = tt.surface;
    final line = tt.line;
    final muted = tt.muted;

    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: _labels.map((label) {
            final isActive = label == _active;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _active = label),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? ink : surface,
                    borderRadius: BorderRadius.circular(999),
                    border: isActive ? null : Border.all(color: line),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive ? const Color(0xFFFFFAF4) : muted,
                    ),
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
