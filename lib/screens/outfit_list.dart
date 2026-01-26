import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

class OutfitListPage extends StatelessWidget {
  const OutfitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('今日穿什麼', style: AppTextStyle.title),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: ListTile(
                  leading: const Icon(Icons.checkroom),
                  title: const Text('2026-01-26', style: AppTextStyle.body),
                  subtitle: const Text('白色毛衣 + 牛仔裤', style: AppTextStyle.hint),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
