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
  String get profile => 'プロフィール';

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
  String get selectBirthday => '誕生日を選択';

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
  String get addOutfitTitle => 'コーデを追加';

  @override
  String get editOutfitTitle => 'コーデを編集';

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

  @override
  String get weatherPlaceholderLocation => '東京 · 晴れ';

  @override
  String get weatherPlaceholderAdvice => '薄手のジャケットがちょうどいい';

  @override
  String get reminderTitle => '毎日リマインダー';

  @override
  String reminderEnabledCount(Object count) {
    return '$count 件オン';
  }

  @override
  String get reminderEmptyMessage => 'リマインダーを設定して、毎日のコーデを忘れずに記録しましょう';

  @override
  String get reminderAddBtn => 'リマインダーを追加';

  @override
  String get reminderTimeLabel => '時間';

  @override
  String get reminderWeekdaysLabel => '繰り返し曜日';

  @override
  String get reminderWeekdaysEveryday => '毎日';

  @override
  String get reminderSkipLabel => '本日記録済みの場合はスキップ';

  @override
  String get reminderSkipHint => '本日すでにコーディネートを記録している場合、通知は送信されません';

  @override
  String get reminderAddTitle => '新規リマインダー';

  @override
  String get reminderEditTitle => 'リマインダーを編集';

  @override
  String get reminderDelete => 'リマインダーを削除';

  @override
  String get reminderDeleteConfirm => 'このリマインダーを削除しますか？';

  @override
  String get reminderSave => '保存';

  @override
  String get reminderDayMon => '月';

  @override
  String get reminderDayTue => '火';

  @override
  String get reminderDayWed => '水';

  @override
  String get reminderDayThu => '木';

  @override
  String get reminderDayFri => '金';

  @override
  String get reminderDaySat => '土';

  @override
  String get reminderDaySun => '日';

  @override
  String get reminderNotificationTitle => '今日のコーデ';

  @override
  String get reminderNotificationBody => '今日のコーディネートを記録しましょう～';

  @override
  String get authLoginTitle => 'ログイン';

  @override
  String get authRegisterTitle => 'アカウント登録';

  @override
  String get authLoginHeadline => 'ログインしてコーデを同期';

  @override
  String get authRegisterHeadline => 'アカウントを作成してクラウド同期を開始';

  @override
  String get authOfflineNote =>
      'クラウド同期は任意の機能です。ログインしなくてもすべての記録機能をオフラインで利用できます。';

  @override
  String get authEmailLabel => 'メールアドレス';

  @override
  String get authPasswordLabel => 'パスワード';

  @override
  String get authPasswordHint => '8文字以上';

  @override
  String get authEmailInvalid => '有効なメールアドレスを入力してください';

  @override
  String get authPasswordTooShort => 'パスワードは8文字以上にしてください';

  @override
  String get authLoginSuccess => 'ログインしました';

  @override
  String get authRegisterSuccess => '登録しました';

  @override
  String get authRegisterBtn => '登録';

  @override
  String get authSwitchToLogin => 'アカウントをお持ちの方はログイン';

  @override
  String get authSwitchToRegister => 'アカウントがない方は登録';

  @override
  String get accountSyncTitle => 'アカウントとクラウド同期';

  @override
  String get accountNotLoggedIn => '未ログイン';

  @override
  String get accountCloudOff => 'クラウド同期はオフです';

  @override
  String get accountCloudIntro =>
      'ログインするとコーデ・タグ・プロフィールをクラウドに同期でき、機種変更後も復元できます。\nログインしなくてもローカル機能はすべて使えます。';

  @override
  String get accountRegisterNewBtn => '新規アカウント登録';

  @override
  String get accountLoggedIn => 'ログイン中';

  @override
  String get accountDeviceManagement => 'ログイン端末の管理';

  @override
  String get accountLogout => 'ログアウト';

  @override
  String get accountLogoutDialogContent =>
      'ログアウトするとクラウド同期は停止しますが、ローカルデータは保持されます。ログアウトしますか？';

  @override
  String get accountLogoutConfirm => 'ログアウト';

  @override
  String get accountLoggedOutToast => 'ログアウトしました';

  @override
  String get accountCloudSyncLabel => 'クラウド同期';

  @override
  String get syncStatusSyncing => '同期中…';

  @override
  String get syncStatusNever => 'まだ同期していません';

  @override
  String syncStatusLast(String time) {
    return '最終同期 $time';
  }

  @override
  String get syncNowBtn => '今すぐ同期';

  @override
  String get syncErrPremiumRequired => 'クラウド同期にはプレミアム会員が必要です';

  @override
  String get syncErrGeneric => '同期に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get deviceSessionsTitle => 'ログイン端末';

  @override
  String get deviceSessionsEmpty => 'アクティブなセッションはありません';

  @override
  String get deviceRemoved => 'この端末を削除しました';

  @override
  String get deviceRemoveTooltip => 'この端末を削除';

  @override
  String get deviceCurrentBadge => 'この端末';

  @override
  String get retry => '再試行';

  @override
  String get errNetwork => 'ネットワークに接続できません。接続を確認してもう一度お試しください';

  @override
  String get errRequestTimeout => 'リクエストがタイムアウトしました。しばらくしてからもう一度お試しください';

  @override
  String get errSessionExpired => 'ログインの有効期限が切れました。再度ログインしてください';

  @override
  String get errPremiumRequired => 'この機能にはプレミアム会員が必要です';

  @override
  String get errGeneric => '操作に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get errLoadFailed => '読み込みに失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get errUploadFailed => '画像のアップロードに失敗しました。ネットワークを確認してください';

  @override
  String get proTitle => '今日のコーデ Pro';

  @override
  String get proIntro => 'クラウド同期を解放：コーデ・タグ・プロフィールを複数端末にバックアップ。';

  @override
  String get proSubscribeBtn => 'Pro にアップグレード';

  @override
  String get proRestoreBtn => '購入を復元';

  @override
  String get proActiveBadge => '有効';

  @override
  String proExpiresAt(String date) {
    return '$date まで有効';
  }

  @override
  String get proLifetime => '永久ライセンス';

  @override
  String get proManageBtn => 'サブスクリプションを管理';

  @override
  String get proPurchaseSuccess => 'Pro が有効になりました';

  @override
  String get proRestoreSuccess => '購入を復元しました';

  @override
  String get proNothingToRestore => '復元できる購入はありません';

  @override
  String get proPurchaseFailed => '購入に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get proAlreadyActive => 'すでに Pro 会員です';

  @override
  String get proSyncPending => '購入済み、反映中です…';

  @override
  String get proUnsupportedPlatform => 'iPhone または Android 端末でご購入ください';

  @override
  String get proLoginFirst => 'Pro の購入にはログインが必要です';

  @override
  String get proMonthlyLabel => '月額プラン';

  @override
  String get proYearlyLabel => '年額プラン';

  @override
  String get proLifetimeLabel => '買い切り';

  @override
  String get proPaywallLoadFailed => '商品を読み込めませんでした。しばらくしてからもう一度お試しください';

  @override
  String get proPaymentPending => '支払い確認中です。完了後に自動で有効になります';

  @override
  String get proSubscriptionNote =>
      'サブスクリプションは自動更新されます。ストアのサブスクリプション設定からいつでも解約できます。買い切りは一回限りのお支払いです。';

  @override
  String get proPurchaseCta => '購入する';

  @override
  String get logUpload => 'ログアップロード';

  @override
  String get logUploadEmpty => 'ログファイルはまだありません';

  @override
  String get logUploadConfirmTitle => 'ログをアップロード';

  @override
  String get logUploadConfirmMessage => 'このログファイルを問題調査のためにアップロードします';

  @override
  String get logUploadRemarkHint => '問題の内容を入力（任意）';

  @override
  String get logUploadAction => 'アップロード';

  @override
  String get logUploadSuccess => 'ログをアップロードしました';

  @override
  String get logUploadFailed => 'ログのアップロードに失敗しました';

  @override
  String get logUploadLoginRequired => 'ログをアップロードするにはログインしてください';
}
