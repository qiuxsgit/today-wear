// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Today Wear';

  @override
  String get home => 'Home';

  @override
  String get add => 'Add';

  @override
  String get profile => 'Profile';

  @override
  String get addOutfit => 'Add Outfit';

  @override
  String get addOutfitPage => 'Add Outfit Page\n(Coming Soon)';

  @override
  String get profilePage => 'Profile Page\n(Coming Soon)';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get dayBeforeYesterday => 'Day Before Yesterday';

  @override
  String dateFormat(int month, int day) {
    return '$month/$day';
  }

  @override
  String get simplifiedChinese => 'Simplified Chinese';

  @override
  String get traditionalChinese => 'Traditional Chinese';

  @override
  String get english => 'English';

  @override
  String get japanese => 'Japanese';

  @override
  String get korean => 'Korean';

  @override
  String get nickname => 'User';

  @override
  String get version => 'Version';

  @override
  String get appVersion => '1.0.0';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get openSourceLicense => 'Open Source License';

  @override
  String get contact => 'Contact';

  @override
  String get about => 'About';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteOutfitConfirm =>
      'Are you sure you want to delete this outfit? This cannot be undone.';

  @override
  String get tagManagement => 'Tag Management';

  @override
  String get tagName => 'Tag Name';

  @override
  String get tagColor => 'Tag Color';

  @override
  String get tagEdit => 'Edit Tag';

  @override
  String get tagDeleteConfirm => 'Are you sure you want to delete this tag?';

  @override
  String tagDeleteConfirmInUse(int count) {
    return 'This tag is used by $count outfit(s). Deleting will remove it from those outfits. Continue?';
  }

  @override
  String get tagNameEmpty => 'Please enter a tag name';

  @override
  String get tagNameDuplicate => 'This tag name already exists';

  @override
  String get tagSaved => 'Saved';

  @override
  String get tagNoTags => 'No tags yet';

  @override
  String tagManagementWithCount(int count) {
    return 'Tag Management ($count total)';
  }

  @override
  String get homeEmptyMessage =>
      'No outfit records yet.\nAdd your first outfit to start recording your daily looks.';

  @override
  String get homeAddFirstOutfit => 'Add First Outfit';

  @override
  String get contactQQ => 'QQ';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactEmailCopyHint =>
      'Cannot open email app. Please copy the email address manually.';

  @override
  String get copiedToClipboard => 'Copied';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get birthday => 'Birthday';

  @override
  String get gender => 'Gender';

  @override
  String get personality => 'Personality';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get genderNotSpecified => 'Prefer not to say';

  @override
  String get profileSaved => 'Saved';

  @override
  String get hintNickname => 'Enter nickname';

  @override
  String get hintPersonality => 'Tell us about your personality～';

  @override
  String get hintAvatarEmoji => 'Choose an emoji for avatar';

  @override
  String get selectBirthday => 'Select birthday';

  @override
  String get avatar => 'Avatar';

  @override
  String get avatarSelectHint => 'Tap to select photo';

  @override
  String get nicknameField => 'Nickname';
}
