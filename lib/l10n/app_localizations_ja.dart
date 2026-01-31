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

  @override
  String get delete => '削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String get deleteOutfitConfirm => 'このコーデ記録を削除しますか？削除すると元に戻せません。';

  @override
  String get tagManagement => 'タグ管理';

  @override
  String get tagName => 'タグ名';

  @override
  String get tagEdit => 'タグを編集';

  @override
  String get tagDeleteConfirm => 'このタグを削除しますか？';

  @override
  String tagDeleteConfirmInUse(int count) {
    return 'このタグは $count 件のコーデで使用されています。削除するとそれらから外れます。削除しますか？';
  }

  @override
  String get tagNameEmpty => 'タグ名を入力してください';

  @override
  String get tagNameDuplicate => 'このタグ名は既に存在します';

  @override
  String get tagSaved => '保存しました';

  @override
  String get tagNoTags => 'タグがありません';

  @override
  String get homeEmptyMessage => 'まだコーデの記録がありません\n最初のコーデを追加して、毎日のコーデを記録しましょう';

  @override
  String get homeAddFirstOutfit => '最初のコーデを追加';
}
