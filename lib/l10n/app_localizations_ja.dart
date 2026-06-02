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
  String get tagColor => 'タグの色';

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
  String tagManagementWithCount(int count) {
    return 'タグ管理（全 $count 件）';
  }

  @override
  String get homeEmptyMessage => 'まだコーデの記録がありません\n最初のコーデを追加して、毎日のコーデを記録しましょう';

  @override
  String get homeAddFirstOutfit => '最初のコーデを追加';

  @override
  String get contactQQ => 'QQ';

  @override
  String get contactEmail => 'メール';

  @override
  String get contactEmailCopyHint => 'メールアプリを開けません。メールアドレスを手動でコピーしてください。';

  @override
  String get copiedToClipboard => 'コピーしました';

  @override
  String get editProfile => 'プロフィールを編集';

  @override
  String get birthday => '誕生日';

  @override
  String get gender => '性別';

  @override
  String get personality => '性格';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get genderNotSpecified => '選択しない';

  @override
  String get profileSaved => '保存しました';

  @override
  String get hintNickname => 'ニックネームを入力';

  @override
  String get hintPersonality => 'あなたの性格を教えてください～';

  @override
  String get hintAvatarEmoji => 'アバター用の絵文字を選んでください';

  @override
  String get selectBirthday => '誕生日を選択';

  @override
  String get avatar => 'アバター';

  @override
  String get avatarSelectHint => 'タップして写真を選択';

  @override
  String get nicknameField => 'ニックネーム';

  @override
  String get navCalendar => 'カレンダー';

  @override
  String get navAdd => '記録';

  @override
  String get navStats => '統計';

  @override
  String get homeAppTitle => '今日のコーデ';

  @override
  String homeDateLabel(String weekday, int month, int day) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      '1': '月',
      '2': '火',
      '3': '水',
      '4': '木',
      '5': '金',
      '6': '土',
      '7': '日',
      'other': '',
    });
    return '$_temp0曜日 · $month月$day日';
  }

  @override
  String get filterAll => 'すべて';

  @override
  String get filterCommute => '通勤';

  @override
  String get filterDate => 'デート';

  @override
  String get filterRainy => '雨の日';

  @override
  String get filterCasual => 'カジュアル';

  @override
  String get addOutfitTitle => 'コーデを追加';

  @override
  String get addOutfitHeroEyebrow => '今日のコーデ';

  @override
  String get addOutfitHeroText => '着こなしを記録しよう';

  @override
  String get addOutfitPhotosSection => '写真';

  @override
  String get addOutfitDragHint => 'ドラッグして並べ替え';

  @override
  String get addOutfitAddPhotoBtn => '写真を追加';

  @override
  String get addOutfitFromGallery => 'フォトライブラリから';

  @override
  String get addOutfitTakePhotoOption => '写真を撮る';

  @override
  String get addOutfitTagsSection => 'タグ';

  @override
  String get addOutfitNoTagsHint => 'タグがありません';

  @override
  String get addOutfitSelectedTagsLabel => '選択中のタグ';

  @override
  String get addOutfitNewTagSection => '新しいタグ';

  @override
  String get addOutfitTagInputHint => 'タグ名を入力';

  @override
  String get addOutfitAddTagBtn => '追加';

  @override
  String get addOutfitDescSection => 'メモ';

  @override
  String get addOutfitDescHint => '今日のコーデを説明してください...';

  @override
  String get addOutfitSaveBtn => 'コーデを保存';

  @override
  String get addOutfitSaveEditBtn => '変更を保存';

  @override
  String get warnTagAlreadyExists => 'タグは既に存在します';

  @override
  String get warnSelectAtLeastOneImage => '1枚以上の写真を選んでください';

  @override
  String get warnEnterDescription => '説明を入力してください';

  @override
  String warnImageLimit(int maxImages) {
    return '写真は最大 $maxImages 枚まで';
  }

  @override
  String warnImageLimitExceeded(int maxImages, int remainingSlots) {
    return '最大 $maxImages 枚、あと $remainingSlots 枚追加できます';
  }

  @override
  String get successOutfitSaved => 'コーデを保存しました';

  @override
  String errLoadData(String error) {
    return '読み込みに失敗しました：$error';
  }

  @override
  String errLoadTags(String error) {
    return 'タグの読み込みに失敗しました：$error';
  }

  @override
  String errSelectImage(String error) {
    return '写真の選択に失敗しました：$error';
  }

  @override
  String errTakePhoto(String error) {
    return '撮影に失敗しました：$error';
  }

  @override
  String errSaveOutfit(String error) {
    return '保存に失敗しました：$error';
  }

  @override
  String get calendarWardrobeReview => 'クローゼットレビュー';

  @override
  String calendarMonthTitle(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': '1月',
      '2': '2月',
      '3': '3月',
      '4': '4月',
      '5': '5月',
      '6': '6月',
      '7': '7月',
      '8': '8月',
      '9': '9月',
      '10': '10月',
      '11': '11月',
      '12': '12月',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String calendarMonthName(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': '1月',
      '2': '2月',
      '3': '3月',
      '4': '4月',
      '5': '5月',
      '6': '6月',
      '7': '7月',
      '8': '8月',
      '9': '9月',
      '10': '10月',
      '11': '11月',
      '12': '12月',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get calendarRecordedDays => '記録した日数';

  @override
  String get calendarUniqueTags => 'タグの種類';

  @override
  String get calendarTopOutfits => '人気コーデ';

  @override
  String calendarTagUsedCount(int count) {
    return '$count回使用';
  }

  @override
  String calendarDaySheetTitle(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get calendarNoDayOutfits => 'この日はコーデの記録がありません';

  @override
  String get statsPageTitle => '統計';

  @override
  String get statsMonthly => '今月';

  @override
  String get statsRecordedDaysLabel => '記録日数';

  @override
  String get statsLast7Days => '直近7日';

  @override
  String get statsTotal => '累計';

  @override
  String get statsTagFrequency => 'タグ頻度';

  @override
  String get statsInspirationTitle => 'コーデインスピレーション';

  @override
  String get editOutfitTooltip => '編集';

  @override
  String get appearanceTitle => '外観';

  @override
  String get appearanceDisplayMode => '表示モード';

  @override
  String get appearanceColorPalette => 'カラーテーマ';

  @override
  String get presetDescSoftWardrobe => 'ソフトワードローブ';

  @override
  String get presetDescMatcha => '抹茶';

  @override
  String get presetDescCityBlue => 'シティブルー';

  @override
  String get presetDescRose => 'ローズ';

  @override
  String get presetDescNightGallery => 'ナイトギャラリー';

  @override
  String get themeModeLight => 'ライト';

  @override
  String get themeModeAuto => '自動';

  @override
  String get themeModeDark => 'ダーク';
}
