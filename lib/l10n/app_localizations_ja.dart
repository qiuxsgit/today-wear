// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '今日のコーデ';

  @override
  String get home => 'ホーム';

  @override
  String get add => '追加';

  @override
  String get profile => 'プロフィール';

  @override
  String get addOutfit => 'コーデを追加';

  @override
  String get addOutfitPage => 'コーデ追加ページ\n（実装予定）';

  @override
  String get profilePage => 'プロフィールページ\n（実装予定）';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get dayBeforeYesterday => '一昨日';

  @override
  String dateFormat(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get simplifiedChinese => '簡体字中国語';

  @override
  String get traditionalChinese => '繁体字中国語';

  @override
  String get english => '英語';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '韓国語';

  @override
  String get nickname => 'ユーザー';

  @override
  String get version => 'バージョン';

  @override
  String get appVersion => '1.0.0';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get openSourceLicense => 'オープンソースライセンス';

  @override
  String get contact => 'お問い合わせ';

  @override
  String get about => 'アプリについて';

  @override
  String get save => '保存';
}
