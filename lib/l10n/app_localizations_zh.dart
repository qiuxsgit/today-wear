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
  String get appVersion => '1.0.0';

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
  String get appVersion => '1.0.0';

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
  String get appVersion => '1.0.0';

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
}
