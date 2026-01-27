import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

/// 添加穿搭页面（占位）
/// 
/// 后续实现完整功能
class AddOutfitPage extends StatelessWidget {
  const AddOutfitPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(l10n.addOutfit, style: AppTextStyle.title),
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          l10n.addOutfitPage,
          textAlign: TextAlign.center,
          style: AppTextStyle.body,
        ),
      ),
    );
  }
}
