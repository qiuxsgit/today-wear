// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '今日穿什麼';

  @override
  String get home => '首页';

  @override
  String get profile => '个人';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get dayBeforeYesterday => '前天';

  @override
  String dateFormat(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁体中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get nickname => '用户';

  @override
  String get version => '版本';

  @override
  String get appVersion => '0.0.1';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '使用条款';

  @override
  String get contact => '联系方式';

  @override
  String get about => '关于应用';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get deleteOutfitConfirm => '确定要删除这条穿搭记录吗？删除后无法恢复。';

  @override
  String get tagManagement => '标签管理';

  @override
  String get tagName => '标签名称';

  @override
  String get tagColor => '标签颜色';

  @override
  String get tagEdit => '编辑标签';

  @override
  String get tagAdd => '新增标签';

  @override
  String get tagDeleteConfirm => '确定要删除该标签吗？';

  @override
  String tagDeleteConfirmInUse(int count) {
    return '该标签已被 $count 条穿搭使用，删除将从这些穿搭中移除该标签。确定删除吗？';
  }

  @override
  String get tagNameEmpty => '请输入标签名称';

  @override
  String get tagNameDuplicate => '该标签名称已存在';

  @override
  String get tagSaved => '已保存';

  @override
  String get tagNoTags => '暂无标签';

  @override
  String tagManagementWithCount(int count) {
    return '标签管理（共 $count 个）';
  }

  @override
  String get homeEmptyMessage => '还没有穿搭记录\n添加第一条穿搭，开始记录你的每日穿搭吧';

  @override
  String get homeAddFirstOutfit => '添加第一条穿搭';

  @override
  String get contactQQ => 'QQ';

  @override
  String get contactEmail => '邮箱';

  @override
  String get contactEmailCopyHint => '无法打开邮件应用，请手动复制邮箱地址';

  @override
  String get copiedToClipboard => '已复制';

  @override
  String get editProfile => '编辑资料';

  @override
  String get birthday => '生日';

  @override
  String get gender => '性别';

  @override
  String get personality => '性格';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get genderNotSpecified => '暂不选择';

  @override
  String get profileSaved => '已保存';

  @override
  String get hintNickname => '请输入昵称';

  @override
  String get hintPersonality => '介绍一下你的性格吧～';

  @override
  String get selectBirthday => '选择生日';

  @override
  String get nicknameField => '昵称';

  @override
  String get navCalendar => '日历';

  @override
  String get navAdd => '记录';

  @override
  String get navStats => '统计';

  @override
  String get homeAppTitle => '今日穿什么';

  @override
  String homeDateLabel(String weekday, int month, int day) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      '1': '周一',
      '2': '周二',
      '3': '周三',
      '4': '周四',
      '5': '周五',
      '6': '周六',
      '7': '周日',
      'other': '',
    });
    return '$_temp0 · $month月$day日';
  }

  @override
  String get filterAll => '全部';

  @override
  String get addOutfitTitle => '新增穿搭';

  @override
  String get editOutfitTitle => '编辑穿搭';

  @override
  String get addOutfitHeroEyebrow => '今日穿搭';

  @override
  String get addOutfitHeroText => '记录你的穿搭';

  @override
  String get addOutfitPhotosSection => '照片';

  @override
  String get addOutfitDragHint => '拖动可排序';

  @override
  String get addOutfitAddPhotoBtn => '添加照片';

  @override
  String get addOutfitFromGallery => '从相册选择';

  @override
  String get addOutfitTakePhotoOption => '拍照';

  @override
  String get addOutfitTagsSection => '标签';

  @override
  String get addOutfitNoTagsHint => '暂无标签';

  @override
  String get addOutfitSelectedTagsLabel => '已选标签';

  @override
  String get addOutfitNewTagSection => '新建标签';

  @override
  String get addOutfitTagInputHint => '输入标签名称';

  @override
  String get addOutfitAddTagBtn => '添加';

  @override
  String get addOutfitDescSection => '描述';

  @override
  String get addOutfitDescHint => '描述一下今天的穿搭...';

  @override
  String get addOutfitSaveBtn => '保存穿搭';

  @override
  String get addOutfitSaveEditBtn => '保存修改';

  @override
  String get warnTagAlreadyExists => '标签已存在';

  @override
  String get warnSelectAtLeastOneImage => '请至少选择一张图片';

  @override
  String get warnEnterDescription => '请填写描述';

  @override
  String warnImageLimit(int maxImages) {
    return '最多只能添加 $maxImages 张图片';
  }

  @override
  String warnImageLimitExceeded(int maxImages, int remainingSlots) {
    return '最多添加 $maxImages 张，还可添加 $remainingSlots 张';
  }

  @override
  String get successOutfitSaved => '穿搭已保存';

  @override
  String errLoadData(String error) {
    return '加载失败：$error';
  }

  @override
  String errLoadTags(String error) {
    return '加载标签失败：$error';
  }

  @override
  String errSelectImage(String error) {
    return '选择图片失败：$error';
  }

  @override
  String errTakePhoto(String error) {
    return '拍照失败：$error';
  }

  @override
  String errSaveOutfit(String error) {
    return '保存失败：$error';
  }

  @override
  String get calendarWardrobeReview => '衣橱回顾';

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
  String get calendarRecordedDays => '记录天数';

  @override
  String get calendarUniqueTags => '标签种类';

  @override
  String get calendarTopOutfits => '热门穿搭';

  @override
  String calendarTagUsedCount(int count) {
    return '使用 $count 次';
  }

  @override
  String calendarDaySheetTitle(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get calendarNoDayOutfits => '这天没有穿搭记录';

  @override
  String get statsPageTitle => '统计';

  @override
  String get statsMonthly => '本月';

  @override
  String get statsRecordedDaysLabel => '记录天数';

  @override
  String get statsLast7Days => '近7天';

  @override
  String get statsTotal => '累计';

  @override
  String get statsTagFrequency => '标签频率';

  @override
  String get statsInspirationTitle => '穿搭灵感';

  @override
  String get editOutfitTooltip => '编辑';

  @override
  String get appearanceTitle => '外观';

  @override
  String get appearanceDisplayMode => '显示模式';

  @override
  String get appearanceColorPalette => '色彩主题';

  @override
  String get presetDescSoftWardrobe => '柔美衣橱';

  @override
  String get presetDescMatcha => '抹茶日和';

  @override
  String get presetDescCityBlue => '城市蓝调';

  @override
  String get presetDescRose => '玫瑰编辑';

  @override
  String get presetDescNightGallery => '暗夜画廊';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeAuto => '跟随系统';

  @override
  String get themeModeDark => '深色';

  @override
  String get weatherPlaceholderLocation => '北京 · 晴天';

  @override
  String get weatherPlaceholderAdvice => '薄外套刚刚好';

  @override
  String get reminderTitle => '每日提醒';

  @override
  String reminderEnabledCount(Object count) {
    return '已开启 $count 个';
  }

  @override
  String get reminderEmptyMessage => '设置提醒，不再忘记记录穿搭';

  @override
  String get reminderAddBtn => '添加提醒';

  @override
  String get reminderTimeLabel => '提醒时间';

  @override
  String get reminderWeekdaysLabel => '重复日期';

  @override
  String get reminderWeekdaysEveryday => '每天';

  @override
  String get reminderSkipLabel => '当天已记录则跳过';

  @override
  String get reminderSkipHint => '如果今天已经记录过穿搭，将不会发送提醒';

  @override
  String get reminderAddTitle => '新增提醒';

  @override
  String get reminderEditTitle => '编辑提醒';

  @override
  String get reminderDelete => '删除提醒';

  @override
  String get reminderDeleteConfirm => '确定删除此提醒吗？';

  @override
  String get reminderSave => '保存';

  @override
  String get reminderDayMon => '周一';

  @override
  String get reminderDayTue => '周二';

  @override
  String get reminderDayWed => '周三';

  @override
  String get reminderDayThu => '周四';

  @override
  String get reminderDayFri => '周五';

  @override
  String get reminderDaySat => '周六';

  @override
  String get reminderDaySun => '周日';

  @override
  String get reminderNotificationTitle => '今日穿搭';

  @override
  String get reminderNotificationBody => '别忘了记录今天的穿搭哦～';

  @override
  String get authLoginTitle => '登录';

  @override
  String get authRegisterTitle => '注册账号';

  @override
  String get authLoginHeadline => '登录以同步你的穿搭';

  @override
  String get authRegisterHeadline => '创建账号以开启云同步';

  @override
  String get authOfflineNote => '云同步为可选功能，不登录也能离线使用全部记录功能。';

  @override
  String get authEmailLabel => '邮箱';

  @override
  String get authPasswordLabel => '密码';

  @override
  String get authPasswordHint => '至少 8 位';

  @override
  String get authEmailInvalid => '请输入有效的邮箱地址';

  @override
  String get authPasswordTooShort => '密码至少 8 位';

  @override
  String get authLoginSuccess => '登录成功';

  @override
  String get authRegisterSuccess => '注册成功';

  @override
  String get authRegisterBtn => '注册';

  @override
  String get authSwitchToLogin => '已有账号？去登录';

  @override
  String get authSwitchToRegister => '还没有账号？去注册';

  @override
  String get accountSyncTitle => '账户与云同步';

  @override
  String get accountNotLoggedIn => '未登录';

  @override
  String get accountCloudOff => '云同步未开启';

  @override
  String get accountCloudIntro => '登录后可将穿搭、标签与资料同步到云端，换设备也能找回。\n不登录不影响任何本地功能。';

  @override
  String get accountRegisterNewBtn => '注册新账号';

  @override
  String get accountLoggedIn => '已登录';

  @override
  String get accountDeviceManagement => '登录设备管理';

  @override
  String get accountLogout => '退出登录';

  @override
  String get accountLogoutDialogContent => '退出后云同步将停止，本地数据保留。确定退出吗？';

  @override
  String get accountLogoutConfirm => '退出';

  @override
  String get accountLoggedOutToast => '已退出登录';

  @override
  String get accountCloudSyncLabel => '云同步';

  @override
  String get syncStatusSyncing => '同步中…';

  @override
  String get syncStatusNever => '尚未同步';

  @override
  String syncStatusLast(String time) {
    return '上次同步 $time';
  }

  @override
  String get syncNowBtn => '立即同步';

  @override
  String get syncErrPremiumRequired => '云同步需要会员订阅';

  @override
  String get syncErrGeneric => '同步失败，请稍后重试';

  @override
  String get deviceSessionsTitle => '登录设备';

  @override
  String get deviceSessionsEmpty => '暂无活跃会话';

  @override
  String get deviceRemoved => '已移除该设备';

  @override
  String get deviceRemoveTooltip => '移除该设备';

  @override
  String get deviceCurrentBadge => '本机';

  @override
  String get retry => '重试';

  @override
  String get errNetwork => '网络连接失败，请检查网络后重试';

  @override
  String get errRequestTimeout => '请求超时，请稍后重试';

  @override
  String get errSessionExpired => '登录已失效，请重新登录';

  @override
  String get errPremiumRequired => '此功能需要会员';

  @override
  String get errGeneric => '操作失败，请稍后重试';

  @override
  String get errLoadFailed => '加载失败，请稍后重试';

  @override
  String get errUploadFailed => '图片上传失败，请检查网络';

  @override
  String get proTitle => '今天穿什么 Pro';

  @override
  String get proIntro => '解锁云同步：穿搭、标签与资料多设备备份，换机不丢。';

  @override
  String get proSubscribeBtn => '开通 Pro';

  @override
  String get proRestoreBtn => '恢复购买';

  @override
  String get proActiveBadge => '已开通';

  @override
  String proExpiresAt(String date) {
    return '$date 到期';
  }

  @override
  String get proLifetime => '永久有效';

  @override
  String get proManageBtn => '管理订阅';

  @override
  String get proPurchaseSuccess => 'Pro 已开通';

  @override
  String get proRestoreSuccess => '购买已恢复';

  @override
  String get proNothingToRestore => '没有可恢复的购买';

  @override
  String get proPurchaseFailed => '购买失败，请稍后重试';

  @override
  String get proAlreadyActive => '你已是 Pro 会员';

  @override
  String get proSyncPending => '已购买，正在生效…';

  @override
  String get proUnsupportedPlatform => '请在 iPhone 或 Android 手机上购买';

  @override
  String get proLoginFirst => '请先登录账号再开通 Pro';

  @override
  String get proMonthlyLabel => '月度订阅';

  @override
  String get proYearlyLabel => '年度订阅';

  @override
  String get proLifetimeLabel => '永久买断';

  @override
  String get proPaywallLoadFailed => '无法加载商品，请稍后重试';

  @override
  String get proPaymentPending => '支付待确认，完成后自动生效';

  @override
  String get proSubscriptionNote => '订阅自动续费，可随时在系统订阅管理中取消；买断为一次性付费。';

  @override
  String get proPurchaseCta => '立即开通';

  @override
  String get logUpload => '日誌上傳';

  @override
  String get logUploadEmpty => '暫無日誌檔案';

  @override
  String get logUploadConfirmTitle => '上傳日誌';

  @override
  String get logUploadConfirmMessage => '將上傳該日誌檔案用於問題排查';

  @override
  String get logUploadRemarkHint => '描述遇到的問題（可選）';

  @override
  String get logUploadAction => '上傳';

  @override
  String get logUploadSuccess => '日誌上傳成功';

  @override
  String get logUploadFailed => '日誌上傳失敗';

  @override
  String get logUploadLoginRequired => '請先登入後再上傳日誌';

  @override
  String get accountDelete => '删除账号';

  @override
  String get accountDeleteDialogTitle => '永久删除账号？';

  @override
  String get accountDeleteDialogContent =>
      '云端数据（穿搭、标签、资料、图片）将被永久删除。本机的本地数据会保留，App 仍可完整使用。订阅不会自动取消，请前往 App Store / Google Play 自行管理。此操作不可恢复。';

  @override
  String get accountDeletePasswordHint => '输入密码以确认';

  @override
  String get accountDeletePasswordRequired => '请输入密码';

  @override
  String get accountDeleteConfirm => '永久删除';

  @override
  String get accountDeleteSuccess => '账号已删除';

  @override
  String get alreadyLatestVersion => '已是最新版本';

  @override
  String get newVersionFound => '发现新版本';

  @override
  String get updateNow => '立即更新';

  @override
  String get updateLater => '暂不更新';

  @override
  String get forceUpdateNotice => '当前版本过旧，需更新后才能继续使用';

  @override
  String get updateDownloading => '正在下载更新…';

  @override
  String get updateDownloadFailed => '下载失败，请稍后再试';

  @override
  String get updateCheckFailed => '检查更新失败，请稍后再试';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get appTitle => '今日穿什麼';

  @override
  String get home => '首页';

  @override
  String get profile => '个人';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get dayBeforeYesterday => '前天';

  @override
  String dateFormat(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁体中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get nickname => '用户';

  @override
  String get version => '版本';

  @override
  String get appVersion => '0.0.1';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '使用条款';

  @override
  String get contact => '联系方式';

  @override
  String get about => '关于应用';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get deleteOutfitConfirm => '确定要删除这条穿搭记录吗？删除后无法恢复。';

  @override
  String get tagManagement => '标签管理';

  @override
  String get tagName => '标签名称';

  @override
  String get tagColor => '标签颜色';

  @override
  String get tagEdit => '编辑标签';

  @override
  String get tagAdd => '新增标签';

  @override
  String get tagDeleteConfirm => '确定要删除该标签吗？';

  @override
  String tagDeleteConfirmInUse(int count) {
    return '该标签已被 $count 条穿搭使用，删除将从这些穿搭中移除该标签。确定删除吗？';
  }

  @override
  String get tagNameEmpty => '请输入标签名称';

  @override
  String get tagNameDuplicate => '该标签名称已存在';

  @override
  String get tagSaved => '已保存';

  @override
  String get tagNoTags => '暂无标签';

  @override
  String tagManagementWithCount(int count) {
    return '标签管理（共 $count 个）';
  }

  @override
  String get homeEmptyMessage => '还没有穿搭记录\n添加第一条穿搭，开始记录你的每日穿搭吧';

  @override
  String get homeAddFirstOutfit => '添加第一条穿搭';

  @override
  String get contactQQ => 'QQ';

  @override
  String get contactEmail => '邮箱';

  @override
  String get contactEmailCopyHint => '无法打开邮件应用，请手动复制邮箱地址';

  @override
  String get copiedToClipboard => '已复制';

  @override
  String get editProfile => '编辑资料';

  @override
  String get birthday => '生日';

  @override
  String get gender => '性别';

  @override
  String get personality => '性格';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get genderNotSpecified => '暂不选择';

  @override
  String get profileSaved => '已保存';

  @override
  String get hintNickname => '请输入昵称';

  @override
  String get hintPersonality => '介绍一下你的性格吧～';

  @override
  String get selectBirthday => '选择生日';

  @override
  String get nicknameField => '昵称';

  @override
  String get navCalendar => '日历';

  @override
  String get navAdd => '记录';

  @override
  String get navStats => '统计';

  @override
  String get homeAppTitle => '今日穿什么';

  @override
  String homeDateLabel(String weekday, int month, int day) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      '1': '周一',
      '2': '周二',
      '3': '周三',
      '4': '周四',
      '5': '周五',
      '6': '周六',
      '7': '周日',
      'other': '',
    });
    return '$_temp0 · $month月$day日';
  }

  @override
  String get filterAll => '全部';

  @override
  String get addOutfitTitle => '新增穿搭';

  @override
  String get editOutfitTitle => '编辑穿搭';

  @override
  String get addOutfitHeroEyebrow => '今日穿搭';

  @override
  String get addOutfitHeroText => '记录你的穿搭';

  @override
  String get addOutfitPhotosSection => '照片';

  @override
  String get addOutfitDragHint => '拖动可排序';

  @override
  String get addOutfitAddPhotoBtn => '添加照片';

  @override
  String get addOutfitFromGallery => '从相册选择';

  @override
  String get addOutfitTakePhotoOption => '拍照';

  @override
  String get addOutfitTagsSection => '标签';

  @override
  String get addOutfitNoTagsHint => '暂无标签';

  @override
  String get addOutfitSelectedTagsLabel => '已选标签';

  @override
  String get addOutfitNewTagSection => '新建标签';

  @override
  String get addOutfitTagInputHint => '输入标签名称';

  @override
  String get addOutfitAddTagBtn => '添加';

  @override
  String get addOutfitDescSection => '描述';

  @override
  String get addOutfitDescHint => '描述一下今天的穿搭...';

  @override
  String get addOutfitSaveBtn => '保存穿搭';

  @override
  String get addOutfitSaveEditBtn => '保存修改';

  @override
  String get warnTagAlreadyExists => '标签已存在';

  @override
  String get warnSelectAtLeastOneImage => '请至少选择一张图片';

  @override
  String get warnEnterDescription => '请填写描述';

  @override
  String warnImageLimit(int maxImages) {
    return '最多只能添加 $maxImages 张图片';
  }

  @override
  String warnImageLimitExceeded(int maxImages, int remainingSlots) {
    return '最多添加 $maxImages 张，还可添加 $remainingSlots 张';
  }

  @override
  String get successOutfitSaved => '穿搭已保存';

  @override
  String errLoadData(String error) {
    return '加载失败：$error';
  }

  @override
  String errLoadTags(String error) {
    return '加载标签失败：$error';
  }

  @override
  String errSelectImage(String error) {
    return '选择图片失败：$error';
  }

  @override
  String errTakePhoto(String error) {
    return '拍照失败：$error';
  }

  @override
  String errSaveOutfit(String error) {
    return '保存失败：$error';
  }

  @override
  String get calendarWardrobeReview => '衣橱回顾';

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
  String get calendarRecordedDays => '记录天数';

  @override
  String get calendarUniqueTags => '标签种类';

  @override
  String get calendarTopOutfits => '热门穿搭';

  @override
  String calendarTagUsedCount(int count) {
    return '使用 $count 次';
  }

  @override
  String calendarDaySheetTitle(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get calendarNoDayOutfits => '这天没有穿搭记录';

  @override
  String get statsPageTitle => '统计';

  @override
  String get statsMonthly => '本月';

  @override
  String get statsRecordedDaysLabel => '记录天数';

  @override
  String get statsLast7Days => '近7天';

  @override
  String get statsTotal => '累计';

  @override
  String get statsTagFrequency => '标签频率';

  @override
  String get statsInspirationTitle => '穿搭灵感';

  @override
  String get editOutfitTooltip => '编辑';

  @override
  String get appearanceTitle => '外观';

  @override
  String get appearanceDisplayMode => '显示模式';

  @override
  String get appearanceColorPalette => '色彩主题';

  @override
  String get presetDescSoftWardrobe => '柔美衣橱';

  @override
  String get presetDescMatcha => '抹茶日和';

  @override
  String get presetDescCityBlue => '城市蓝调';

  @override
  String get presetDescRose => '玫瑰编辑';

  @override
  String get presetDescNightGallery => '暗夜画廊';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeAuto => '跟随系统';

  @override
  String get themeModeDark => '深色';

  @override
  String get weatherPlaceholderLocation => '北京 · 晴天';

  @override
  String get weatherPlaceholderAdvice => '薄外套刚刚好';

  @override
  String get reminderTitle => '每日提醒';

  @override
  String reminderEnabledCount(Object count) {
    return '已开启 $count 个';
  }

  @override
  String get reminderEmptyMessage => '设置提醒，不再忘记记录穿搭';

  @override
  String get reminderAddBtn => '添加提醒';

  @override
  String get reminderTimeLabel => '提醒时间';

  @override
  String get reminderWeekdaysLabel => '重复日期';

  @override
  String get reminderWeekdaysEveryday => '每天';

  @override
  String get reminderSkipLabel => '当天已记录则跳过';

  @override
  String get reminderSkipHint => '如果今天已经记录过穿搭，将不会发送提醒';

  @override
  String get reminderAddTitle => '新增提醒';

  @override
  String get reminderEditTitle => '编辑提醒';

  @override
  String get reminderDelete => '删除提醒';

  @override
  String get reminderDeleteConfirm => '确定删除此提醒吗？';

  @override
  String get reminderSave => '保存';

  @override
  String get reminderDayMon => '周一';

  @override
  String get reminderDayTue => '周二';

  @override
  String get reminderDayWed => '周三';

  @override
  String get reminderDayThu => '周四';

  @override
  String get reminderDayFri => '周五';

  @override
  String get reminderDaySat => '周六';

  @override
  String get reminderDaySun => '周日';

  @override
  String get reminderNotificationTitle => '今日穿搭';

  @override
  String get reminderNotificationBody => '别忘了记录今天的穿搭哦～';

  @override
  String get authLoginTitle => '登录';

  @override
  String get authRegisterTitle => '注册账号';

  @override
  String get authLoginHeadline => '登录以同步你的穿搭';

  @override
  String get authRegisterHeadline => '创建账号以开启云同步';

  @override
  String get authOfflineNote => '云同步为可选功能，不登录也能离线使用全部记录功能。';

  @override
  String get authEmailLabel => '邮箱';

  @override
  String get authPasswordLabel => '密码';

  @override
  String get authPasswordHint => '至少 8 位';

  @override
  String get authEmailInvalid => '请输入有效的邮箱地址';

  @override
  String get authPasswordTooShort => '密码至少 8 位';

  @override
  String get authLoginSuccess => '登录成功';

  @override
  String get authRegisterSuccess => '注册成功';

  @override
  String get authRegisterBtn => '注册';

  @override
  String get authSwitchToLogin => '已有账号？去登录';

  @override
  String get authSwitchToRegister => '还没有账号？去注册';

  @override
  String get accountSyncTitle => '账户与云同步';

  @override
  String get accountNotLoggedIn => '未登录';

  @override
  String get accountCloudOff => '云同步未开启';

  @override
  String get accountCloudIntro => '登录后可将穿搭、标签与资料同步到云端，换设备也能找回。\n不登录不影响任何本地功能。';

  @override
  String get accountRegisterNewBtn => '注册新账号';

  @override
  String get accountLoggedIn => '已登录';

  @override
  String get accountDeviceManagement => '登录设备管理';

  @override
  String get accountLogout => '退出登录';

  @override
  String get accountLogoutDialogContent => '退出后云同步将停止，本地数据保留。确定退出吗？';

  @override
  String get accountLogoutConfirm => '退出';

  @override
  String get accountLoggedOutToast => '已退出登录';

  @override
  String get accountCloudSyncLabel => '云同步';

  @override
  String get syncStatusSyncing => '同步中…';

  @override
  String get syncStatusNever => '尚未同步';

  @override
  String syncStatusLast(String time) {
    return '上次同步 $time';
  }

  @override
  String get syncNowBtn => '立即同步';

  @override
  String get syncErrPremiumRequired => '云同步需要会员订阅';

  @override
  String get syncErrGeneric => '同步失败，请稍后重试';

  @override
  String get deviceSessionsTitle => '登录设备';

  @override
  String get deviceSessionsEmpty => '暂无活跃会话';

  @override
  String get deviceRemoved => '已移除该设备';

  @override
  String get deviceRemoveTooltip => '移除该设备';

  @override
  String get deviceCurrentBadge => '本机';

  @override
  String get retry => '重试';

  @override
  String get errNetwork => '网络连接失败，请检查网络后重试';

  @override
  String get errRequestTimeout => '请求超时，请稍后重试';

  @override
  String get errSessionExpired => '登录已失效，请重新登录';

  @override
  String get errPremiumRequired => '此功能需要会员';

  @override
  String get errGeneric => '操作失败，请稍后重试';

  @override
  String get errLoadFailed => '加载失败，请稍后重试';

  @override
  String get errUploadFailed => '图片上传失败，请检查网络';

  @override
  String get proTitle => '今天穿什么 Pro';

  @override
  String get proIntro => '解锁云同步：穿搭、标签与资料多设备备份，换机不丢。';

  @override
  String get proSubscribeBtn => '开通 Pro';

  @override
  String get proRestoreBtn => '恢复购买';

  @override
  String get proActiveBadge => '已开通';

  @override
  String proExpiresAt(String date) {
    return '$date 到期';
  }

  @override
  String get proLifetime => '永久有效';

  @override
  String get proManageBtn => '管理订阅';

  @override
  String get proPurchaseSuccess => 'Pro 已开通';

  @override
  String get proRestoreSuccess => '购买已恢复';

  @override
  String get proNothingToRestore => '没有可恢复的购买';

  @override
  String get proPurchaseFailed => '购买失败，请稍后重试';

  @override
  String get proAlreadyActive => '你已是 Pro 会员';

  @override
  String get proSyncPending => '已购买，正在生效…';

  @override
  String get proUnsupportedPlatform => '请在 iPhone 或 Android 手机上购买';

  @override
  String get proLoginFirst => '请先登录账号再开通 Pro';

  @override
  String get proMonthlyLabel => '月度订阅';

  @override
  String get proYearlyLabel => '年度订阅';

  @override
  String get proLifetimeLabel => '永久买断';

  @override
  String get proPaywallLoadFailed => '无法加载商品，请稍后重试';

  @override
  String get proPaymentPending => '支付待确认，完成后自动生效';

  @override
  String get proSubscriptionNote => '订阅自动续费，可随时在系统订阅管理中取消；买断为一次性付费。';

  @override
  String get proPurchaseCta => '立即开通';

  @override
  String get logUpload => '日志上传';

  @override
  String get logUploadEmpty => '暂无日志文件';

  @override
  String get logUploadConfirmTitle => '上传日志';

  @override
  String get logUploadConfirmMessage => '将上传该日志文件用于问题排查';

  @override
  String get logUploadRemarkHint => '描述遇到的问题（可选）';

  @override
  String get logUploadAction => '上传';

  @override
  String get logUploadSuccess => '日志上传成功';

  @override
  String get logUploadFailed => '日志上传失败';

  @override
  String get logUploadLoginRequired => '请先登录后再上传日志';

  @override
  String get accountDelete => '删除账号';

  @override
  String get accountDeleteDialogTitle => '永久删除账号？';

  @override
  String get accountDeleteDialogContent =>
      '云端数据（穿搭、标签、资料、图片）将被永久删除。本机的本地数据会保留，App 仍可完整使用。订阅不会自动取消，请前往 App Store / Google Play 自行管理。此操作不可恢复。';

  @override
  String get accountDeletePasswordHint => '输入密码以确认';

  @override
  String get accountDeletePasswordRequired => '请输入密码';

  @override
  String get accountDeleteConfirm => '永久删除';

  @override
  String get accountDeleteSuccess => '账号已删除';

  @override
  String get alreadyLatestVersion => '已是最新版本';

  @override
  String get newVersionFound => '发现新版本';

  @override
  String get updateNow => '立即更新';

  @override
  String get updateLater => '暂不更新';

  @override
  String get forceUpdateNotice => '当前版本过旧，需更新后才能继续使用';

  @override
  String get updateDownloading => '正在下载更新…';

  @override
  String get updateDownloadFailed => '下载失败，请稍后再试';

  @override
  String get updateCheckFailed => '检查更新失败，请稍后再试';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '今日穿什麼';

  @override
  String get home => '首頁';

  @override
  String get profile => '個人';

  @override
  String get settings => '設定';

  @override
  String get language => '語言';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get dayBeforeYesterday => '前天';

  @override
  String dateFormat(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get simplifiedChinese => '簡體中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get nickname => '用戶';

  @override
  String get version => '版本';

  @override
  String get appVersion => '0.0.1';

  @override
  String get privacyPolicy => '隱私政策';

  @override
  String get termsOfService => '使用條款';

  @override
  String get contact => '聯絡方式';

  @override
  String get about => '關於應用';

  @override
  String get save => '保存';

  @override
  String get delete => '刪除';

  @override
  String get cancel => '取消';

  @override
  String get deleteOutfitConfirm => '確定要刪除這條穿搭記錄嗎？刪除後無法恢復。';

  @override
  String get tagManagement => '標籤管理';

  @override
  String get tagName => '標籤名稱';

  @override
  String get tagColor => '標籤顏色';

  @override
  String get tagEdit => '編輯標籤';

  @override
  String get tagAdd => '新增標籤';

  @override
  String get tagDeleteConfirm => '確定要刪除該標籤嗎？';

  @override
  String tagDeleteConfirmInUse(int count) {
    return '該標籤已被 $count 條穿搭使用，刪除將從這些穿搭中移除該標籤。確定刪除嗎？';
  }

  @override
  String get tagNameEmpty => '請輸入標籤名稱';

  @override
  String get tagNameDuplicate => '該標籤名稱已存在';

  @override
  String get tagSaved => '已保存';

  @override
  String get tagNoTags => '暫無標籤';

  @override
  String tagManagementWithCount(int count) {
    return '標籤管理（共 $count 個）';
  }

  @override
  String get homeEmptyMessage => '還沒有穿搭記錄\n添加第一條穿搭，開始記錄你的每日穿搭吧';

  @override
  String get homeAddFirstOutfit => '添加第一條穿搭';

  @override
  String get contactQQ => 'QQ';

  @override
  String get contactEmail => '郵箱';

  @override
  String get contactEmailCopyHint => '無法打開郵件應用，請手動複製郵箱地址';

  @override
  String get copiedToClipboard => '已複製';

  @override
  String get editProfile => '編輯資料';

  @override
  String get birthday => '生日';

  @override
  String get gender => '性別';

  @override
  String get personality => '性格';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get genderNotSpecified => '暫不選擇';

  @override
  String get profileSaved => '已保存';

  @override
  String get hintNickname => '請輸入暱稱';

  @override
  String get hintPersonality => '介紹一下你的性格吧～';

  @override
  String get selectBirthday => '選擇生日';

  @override
  String get nicknameField => '暱稱';

  @override
  String get navCalendar => '日曆';

  @override
  String get navAdd => '記錄';

  @override
  String get navStats => '統計';

  @override
  String get homeAppTitle => '今日穿什麼';

  @override
  String homeDateLabel(String weekday, int month, int day) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      '1': '週一',
      '2': '週二',
      '3': '週三',
      '4': '週四',
      '5': '週五',
      '6': '週六',
      '7': '週日',
      'other': '',
    });
    return '$_temp0 · $month月$day日';
  }

  @override
  String get filterAll => '全部';

  @override
  String get addOutfitTitle => '新增穿搭';

  @override
  String get editOutfitTitle => '編輯穿搭';

  @override
  String get addOutfitHeroEyebrow => '今日穿搭';

  @override
  String get addOutfitHeroText => '記錄你的穿搭';

  @override
  String get addOutfitPhotosSection => '照片';

  @override
  String get addOutfitDragHint => '拖動可排序';

  @override
  String get addOutfitAddPhotoBtn => '新增照片';

  @override
  String get addOutfitFromGallery => '從相簿選擇';

  @override
  String get addOutfitTakePhotoOption => '拍照';

  @override
  String get addOutfitTagsSection => '標籤';

  @override
  String get addOutfitNoTagsHint => '尚無標籤';

  @override
  String get addOutfitSelectedTagsLabel => '已選標籤';

  @override
  String get addOutfitNewTagSection => '新建標籤';

  @override
  String get addOutfitTagInputHint => '輸入標籤名稱';

  @override
  String get addOutfitAddTagBtn => '新增';

  @override
  String get addOutfitDescSection => '描述';

  @override
  String get addOutfitDescHint => '描述一下今天的穿搭...';

  @override
  String get addOutfitSaveBtn => '儲存穿搭';

  @override
  String get addOutfitSaveEditBtn => '儲存修改';

  @override
  String get warnTagAlreadyExists => '標籤已存在';

  @override
  String get warnSelectAtLeastOneImage => '請至少選擇一張照片';

  @override
  String get warnEnterDescription => '請填寫描述';

  @override
  String warnImageLimit(int maxImages) {
    return '最多只能新增 $maxImages 張照片';
  }

  @override
  String warnImageLimitExceeded(int maxImages, int remainingSlots) {
    return '最多新增 $maxImages 張，還可新增 $remainingSlots 張';
  }

  @override
  String get successOutfitSaved => '穿搭已儲存';

  @override
  String errLoadData(String error) {
    return '載入失敗：$error';
  }

  @override
  String errLoadTags(String error) {
    return '載入標籤失敗：$error';
  }

  @override
  String errSelectImage(String error) {
    return '選擇照片失敗：$error';
  }

  @override
  String errTakePhoto(String error) {
    return '拍照失敗：$error';
  }

  @override
  String errSaveOutfit(String error) {
    return '儲存失敗：$error';
  }

  @override
  String get calendarWardrobeReview => '衣櫃回顧';

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
  String get calendarRecordedDays => '記錄天數';

  @override
  String get calendarUniqueTags => '標籤種類';

  @override
  String get calendarTopOutfits => '熱門穿搭';

  @override
  String calendarTagUsedCount(int count) {
    return '使用 $count 次';
  }

  @override
  String calendarDaySheetTitle(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get calendarNoDayOutfits => '這天沒有穿搭記錄';

  @override
  String get statsPageTitle => '統計';

  @override
  String get statsMonthly => '本月';

  @override
  String get statsRecordedDaysLabel => '記錄天數';

  @override
  String get statsLast7Days => '近7天';

  @override
  String get statsTotal => '累計';

  @override
  String get statsTagFrequency => '標籤頻率';

  @override
  String get statsInspirationTitle => '穿搭靈感';

  @override
  String get editOutfitTooltip => '編輯';

  @override
  String get appearanceTitle => '外觀';

  @override
  String get appearanceDisplayMode => '顯示模式';

  @override
  String get appearanceColorPalette => '色彩主題';

  @override
  String get presetDescSoftWardrobe => '柔美衣橱';

  @override
  String get presetDescMatcha => '抹茶日和';

  @override
  String get presetDescCityBlue => '城市藍調';

  @override
  String get presetDescRose => '玫瑰編輯';

  @override
  String get presetDescNightGallery => '暗夜畫廊';

  @override
  String get themeModeLight => '淺色';

  @override
  String get themeModeAuto => '跟隨系統';

  @override
  String get themeModeDark => '深色';

  @override
  String get weatherPlaceholderLocation => '台北 · 晴天';

  @override
  String get weatherPlaceholderAdvice => '薄外套剛剛好';

  @override
  String get reminderTitle => '每日提醒';

  @override
  String reminderEnabledCount(Object count) {
    return '已開啟 $count 個';
  }

  @override
  String get reminderEmptyMessage => '設定提醒，不再忘記記錄穿搭';

  @override
  String get reminderAddBtn => '新增提醒';

  @override
  String get reminderTimeLabel => '提醒時間';

  @override
  String get reminderWeekdaysLabel => '重複日期';

  @override
  String get reminderWeekdaysEveryday => '每天';

  @override
  String get reminderSkipLabel => '當天已記錄則跳過';

  @override
  String get reminderSkipHint => '如果今天已經記錄過穿搭，將不會發送提醒';

  @override
  String get reminderAddTitle => '新增提醒';

  @override
  String get reminderEditTitle => '編輯提醒';

  @override
  String get reminderDelete => '刪除提醒';

  @override
  String get reminderDeleteConfirm => '確定刪除此提醒嗎？';

  @override
  String get reminderSave => '儲存';

  @override
  String get reminderDayMon => '週一';

  @override
  String get reminderDayTue => '週二';

  @override
  String get reminderDayWed => '週三';

  @override
  String get reminderDayThu => '週四';

  @override
  String get reminderDayFri => '週五';

  @override
  String get reminderDaySat => '週六';

  @override
  String get reminderDaySun => '週日';

  @override
  String get reminderNotificationTitle => '今日穿搭';

  @override
  String get reminderNotificationBody => '別忘了記錄今天的穿搭哦～';

  @override
  String get authLoginTitle => '登入';

  @override
  String get authRegisterTitle => '註冊帳號';

  @override
  String get authLoginHeadline => '登入以同步你的穿搭';

  @override
  String get authRegisterHeadline => '建立帳號以開啟雲端同步';

  @override
  String get authOfflineNote => '雲端同步為可選功能，不登入也能離線使用全部記錄功能。';

  @override
  String get authEmailLabel => '電子郵件';

  @override
  String get authPasswordLabel => '密碼';

  @override
  String get authPasswordHint => '至少 8 位';

  @override
  String get authEmailInvalid => '請輸入有效的電子郵件地址';

  @override
  String get authPasswordTooShort => '密碼至少 8 位';

  @override
  String get authLoginSuccess => '登入成功';

  @override
  String get authRegisterSuccess => '註冊成功';

  @override
  String get authRegisterBtn => '註冊';

  @override
  String get authSwitchToLogin => '已有帳號？去登入';

  @override
  String get authSwitchToRegister => '還沒有帳號？去註冊';

  @override
  String get accountSyncTitle => '帳戶與雲端同步';

  @override
  String get accountNotLoggedIn => '未登入';

  @override
  String get accountCloudOff => '雲端同步未開啟';

  @override
  String get accountCloudIntro => '登入後可將穿搭、標籤與資料同步到雲端，換裝置也能找回。\n不登入不影響任何本地功能。';

  @override
  String get accountRegisterNewBtn => '註冊新帳號';

  @override
  String get accountLoggedIn => '已登入';

  @override
  String get accountDeviceManagement => '登入裝置管理';

  @override
  String get accountLogout => '登出';

  @override
  String get accountLogoutDialogContent => '登出後雲端同步將停止，本地資料保留。確定登出嗎？';

  @override
  String get accountLogoutConfirm => '登出';

  @override
  String get accountLoggedOutToast => '已登出';

  @override
  String get accountCloudSyncLabel => '雲端同步';

  @override
  String get syncStatusSyncing => '同步中…';

  @override
  String get syncStatusNever => '尚未同步';

  @override
  String syncStatusLast(String time) {
    return '上次同步 $time';
  }

  @override
  String get syncNowBtn => '立即同步';

  @override
  String get syncErrPremiumRequired => '雲端同步需要會員訂閱';

  @override
  String get syncErrGeneric => '同步失敗，請稍後再試';

  @override
  String get deviceSessionsTitle => '登入裝置';

  @override
  String get deviceSessionsEmpty => '暫無活躍工作階段';

  @override
  String get deviceRemoved => '已移除該裝置';

  @override
  String get deviceRemoveTooltip => '移除該裝置';

  @override
  String get deviceCurrentBadge => '本機';

  @override
  String get retry => '重試';

  @override
  String get errNetwork => '網路連線失敗，請檢查網路後再試';

  @override
  String get errRequestTimeout => '請求逾時，請稍後再試';

  @override
  String get errSessionExpired => '登入已失效，請重新登入';

  @override
  String get errPremiumRequired => '此功能需要會員';

  @override
  String get errGeneric => '操作失敗，請稍後再試';

  @override
  String get errLoadFailed => '載入失敗，請稍後再試';

  @override
  String get errUploadFailed => '圖片上傳失敗，請檢查網路';

  @override
  String get proTitle => '今天穿什麼 Pro';

  @override
  String get proIntro => '解鎖雲端同步：穿搭、標籤與資料多裝置備份，換機不丟。';

  @override
  String get proSubscribeBtn => '開通 Pro';

  @override
  String get proRestoreBtn => '恢復購買';

  @override
  String get proActiveBadge => '已開通';

  @override
  String proExpiresAt(String date) {
    return '$date 到期';
  }

  @override
  String get proLifetime => '永久有效';

  @override
  String get proManageBtn => '管理訂閱';

  @override
  String get proPurchaseSuccess => 'Pro 已開通';

  @override
  String get proRestoreSuccess => '購買已恢復';

  @override
  String get proNothingToRestore => '沒有可恢復的購買';

  @override
  String get proPurchaseFailed => '購買失敗，請稍後再試';

  @override
  String get proAlreadyActive => '你已是 Pro 會員';

  @override
  String get proSyncPending => '已購買，正在生效…';

  @override
  String get proUnsupportedPlatform => '請在 iPhone 或 Android 手機上購買';

  @override
  String get proLoginFirst => '請先登入帳號再開通 Pro';

  @override
  String get proMonthlyLabel => '月度訂閱';

  @override
  String get proYearlyLabel => '年度訂閱';

  @override
  String get proLifetimeLabel => '永久買斷';

  @override
  String get proPaywallLoadFailed => '無法載入商品，請稍後再試';

  @override
  String get proPaymentPending => '支付待確認，完成後自動生效';

  @override
  String get proSubscriptionNote => '訂閱自動續費，可隨時在系統訂閱管理中取消；買斷為一次性付費。';

  @override
  String get proPurchaseCta => '立即開通';

  @override
  String get logUpload => '日誌上傳';

  @override
  String get logUploadEmpty => '暫無日誌檔案';

  @override
  String get logUploadConfirmTitle => '上傳日誌';

  @override
  String get logUploadConfirmMessage => '將上傳該日誌檔案用於問題排查';

  @override
  String get logUploadRemarkHint => '描述遇到的問題（可選）';

  @override
  String get logUploadAction => '上傳';

  @override
  String get logUploadSuccess => '日誌上傳成功';

  @override
  String get logUploadFailed => '日誌上傳失敗';

  @override
  String get logUploadLoginRequired => '請先登入後再上傳日誌';

  @override
  String get accountDelete => '刪除帳號';

  @override
  String get accountDeleteDialogTitle => '永久刪除帳號？';

  @override
  String get accountDeleteDialogContent =>
      '雲端資料（穿搭、標籤、個人資料、圖片）將被永久刪除。本機的本地資料會保留，App 仍可完整使用。訂閱不會自動取消，請前往 App Store / Google Play 自行管理。此操作無法復原。';

  @override
  String get accountDeletePasswordHint => '輸入密碼以確認';

  @override
  String get accountDeletePasswordRequired => '請輸入密碼';

  @override
  String get accountDeleteConfirm => '永久刪除';

  @override
  String get accountDeleteSuccess => '帳號已刪除';

  @override
  String get alreadyLatestVersion => '已是最新版本';

  @override
  String get newVersionFound => '發現新版本';

  @override
  String get updateNow => '立即更新';

  @override
  String get updateLater => '暫不更新';

  @override
  String get forceUpdateNotice => '當前版本過舊，需更新後才能繼續使用';

  @override
  String get updateDownloading => '正在下載更新…';

  @override
  String get updateDownloadFailed => '下載失敗，請稍後再試';

  @override
  String get updateCheckFailed => '檢查更新失敗，請稍後再試';
}
