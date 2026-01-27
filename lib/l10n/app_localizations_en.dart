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
}
