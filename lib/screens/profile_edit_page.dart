import 'dart:io';
import 'package:flutter/material.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../services/image_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../theme/app_spacing.dart';

/// 用户资料编辑页面
///
/// 支持头像（图片选择）、昵称、生日、性别、性格；编辑时点击空白处收起键盘
class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key, this.initialProfile});

  final UserProfile? initialProfile;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nicknameController;
  late TextEditingController _personalityController;

  String? _avatarPath;
  DateTime? _birthday;
  String? _gender; // male | female | none

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _nicknameController = TextEditingController(text: p?.nickname ?? '');
    _personalityController = TextEditingController(text: p?.personality ?? '');
    _avatarPath = p?.avatarPath;
    _birthday = p?.birthday;
    _gender = p?.gender;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _personalityController.dispose();
    super.dispose();
  }

  void _unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _pickAvatar() async {
    _unfocusKeyboard();
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (xFile == null || !mounted) return;
    try {
      final path = await ImageService.instance.saveProfileAvatar(File(xFile.path));
      if (mounted) setState(() => _avatarPath = path);
    } catch (_) {
      // 保存失败时仅不更新头像，不弹提示
    }
  }

  Future<void> _pickBirthday() async {
    _unfocusKeyboard();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Localizations.localeOf(context),
    );
    if (picked != null && mounted) {
      setState(() => _birthday = picked);
    }
  }

  Future<void> _save() async {
    _unfocusKeyboard();

    final nickname = _nicknameController.text.trim().isEmpty
        ? null
        : _nicknameController.text.trim();
    final personality = _personalityController.text.trim().isEmpty
        ? null
        : _personalityController.text.trim();

    final profile = UserProfile(
      avatarPath: _avatarPath,
      nickname: nickname,
      birthday: _birthday,
      gender: _gender,
      personality: personality,
    );

    await ProfileService.save(profile);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.profileSaved)),
    );
    Navigator.of(context).pop(profile);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: _unfocusKeyboard,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppBar(
          title: Text(l10n.editProfile, style: AppTextStyle.title),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          surfaceTintColor: Colors.transparent,
          elevation: 2,
          scrolledUnderElevation: 2,
          actions: [
            TextButton(
              onPressed: _save,
              child: Text(l10n.save, style: const TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAvatarSection(),
              const SizedBox(height: AppSpacing.sm),
              _buildNicknameBirthdayGenderSection(l10n),
              const SizedBox(height: AppSpacing.sm),
              _buildPersonalitySection(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: GestureDetector(
        onTap: _pickAvatar,
        child: _avatarPath != null
            ? FutureBuilder<File?>(
                future: ImageService.instance.getImageFile(_avatarPath!),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ClipOval(
                      child: Image.file(
                        snapshot.data!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return _buildAvatarPlaceholder();
                },
              )
            : _buildAvatarPlaceholder(),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.imagePlaceholder,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.add_a_photo_outlined, size: 26, color: AppColors.textSecondary),
    );
  }

  static final InputBorder _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.bgTertiary, width: 1),
  );

  Widget _buildNicknameBirthdayGenderSection(AppLocalizations l10n) {
    String dateText = '';
    if (_birthday != null) {
      dateText = '${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel(l10n.nicknameField),
          const SizedBox(height: 6),
          TextField(
            controller: _nicknameController,
            maxLength: 20,
            decoration: InputDecoration(
              hintText: l10n.hintNickname,
              hintStyle: AppTextStyle.hint.copyWith(fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: _inputBorder,
              enabledBorder: _inputBorder,
              focusedBorder: _inputBorder.copyWith(
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
            style: AppTextStyle.body.copyWith(fontSize: 14),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(height: 1, color: AppColors.bgTertiary),
          const SizedBox(height: AppSpacing.sm),
          _buildFieldLabel(l10n.birthday),
          const SizedBox(height: 6),
          InkWell(
            onTap: _pickBirthday,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.bgTertiary, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: dateText.isEmpty
                        ? AppColors.textPlaceholder
                        : AppColors.textPrimary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      dateText.isEmpty ? l10n.selectBirthday : dateText,
                      style: AppTextStyle.body.copyWith(
                        fontSize: 14,
                        color: dateText.isEmpty
                            ? AppColors.textPlaceholder
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(height: 1, color: AppColors.bgTertiary),
          const SizedBox(height: AppSpacing.sm),
          _buildFieldLabel(l10n.gender),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _genderChip(l10n.male, 'male'),
              _genderChip(l10n.female, 'female'),
              _genderChip(l10n.genderNotSpecified, 'none'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: AppTextStyle.body.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _genderChip(String label, String value) {
    final selected = _gender == value;
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 13)),
      selected: selected,
      onSelected: (_) {
        setState(() => _gender = value);
        _unfocusKeyboard();
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildPersonalitySection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel(l10n.personality),
          const SizedBox(height: 6),
          TextField(
            controller: _personalityController,
            maxLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: l10n.hintPersonality,
              hintStyle: AppTextStyle.hint.copyWith(fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.all(12),
              border: _inputBorder,
              enabledBorder: _inputBorder,
              focusedBorder: _inputBorder.copyWith(
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
            style: AppTextStyle.body.copyWith(fontSize: 14),
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }
}
