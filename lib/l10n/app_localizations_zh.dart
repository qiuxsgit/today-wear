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
  String get add => '添加';

  @override
  String get profile => '个人';

  @override
  String get addOutfit => '添加穿搭';

  @override
  String get addOutfitPage => '添加穿搭页面\n（待实现）';

  @override
  String get profilePage => '个人页面\n（待实现）';

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
  String get openSourceLicense => '开源许可';

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
  String get hintAvatarEmoji => '选一个 emoji 做头像';

  @override
  String get selectBirthday => '选择生日';

  @override
  String get avatar => '头像';

  @override
  String get avatarSelectHint => '点击选择图片';

  @override
  String get nicknameField => '昵称';

  @override String get navCalendar => '日历';
  @override String get navAdd => '新增';
  @override String get navStats => '统计';

  @override String get homeAppTitle => '今日穿什么';
  @override String homeDateLabel(int weekday, int month, int day) {
    const days = ['一','二','三','四','五','六','日'];
    return '周${days[weekday - 1]}，$month月$day日';
  }
  @override String get filterAll => '全部';
  @override String get filterCommute => '通勤';
  @override String get filterDate => '约会';
  @override String get filterRainy => '雨天';
  @override String get filterCasual => '休闲';

  @override String calendarMonthName(int month) {
    const names = ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'];
    return names[month - 1];
  }
  @override String get calendarWardrobeReview => '穿搭回顾';
  @override String calendarMonthTitle(int month) => '${calendarMonthName(month)}回顾';
  @override String get calendarRecordedDays => '已记录天数';
  @override String get calendarUniqueTags => '常用标签数';
  @override String get calendarTopOutfits => '本月最常穿';
  @override String calendarTagUsedCount(int count) => '搭配 $count 次';
  @override String calendarDaySheetTitle(int month, int day) => '$month月$day日穿搭';
  @override String get calendarNoDayOutfits => '这天还没有穿搭记录';

  @override String get addOutfitTitle => '新增穿搭';
  @override String get addOutfitHeroEyebrow => '今天的搭配';
  @override String get addOutfitHeroText => '先放照片，\n再补一点感觉';
  @override String get addOutfitPhotosSection => '选择图片';
  @override String get addOutfitDragHint => '长按拖拽排序';
  @override String get addOutfitAddPhotoBtn => '添加图片';
  @override String get addOutfitTagsSection => '选择标签';
  @override String get addOutfitNoTagsHint => '暂无可用标签';
  @override String get addOutfitSelectedTagsLabel => '已选标签';
  @override String get addOutfitNewTagSection => '添加新标签';
  @override String get addOutfitTagInputHint => '输入标签名称';
  @override String get addOutfitAddTagBtn => '添加';
  @override String get addOutfitDescSection => '备注';
  @override String get addOutfitDescHint => '输入穿搭描述...';
  @override String get addOutfitSaveBtn => '保存今日穿搭';
  @override String get addOutfitSaveEditBtn => '保存修改';
  @override String get addOutfitFromGallery => '从相册选择';
  @override String get addOutfitTakePhotoOption => '拍照';
  @override String errLoadData(String e) => '加载数据失败：$e';
  @override String errLoadTags(String e) => '加载标签失败：$e';
  @override String warnImageLimit(int max) => '最多只能选择 $max 张图片';
  @override String warnImageLimitExceeded(int max, int kept) => '最多只能选择 $max 张图片，已保留前 $kept 张';
  @override String errSelectImage(String e) => '选择图片失败：$e';
  @override String errTakePhoto(String e) => '拍照失败：$e';
  @override String get warnTagAlreadyExists => '标签已存在';
  @override String get warnSelectAtLeastOneImage => '请至少选择一张图片';
  @override String get warnEnterDescription => '请输入备注';
  @override String get successOutfitSaved => '保存成功';
  @override String errSaveOutfit(String e) => '保存失败：$e';

  @override String get statsPageTitle => '统计';
  @override String get statsRefreshTooltip => '刷新';
  @override String get statsTotal => '总计';
  @override String get statsMonthly => '本月';
  @override String get statsWeekly => '本周';
  @override String get statsTip => '小贴士';
  @override String get statsKeepRecording => '保持记录';
  @override String get statsTagFrequency => '标签使用频率';
  @override String get statsMonthlyTrend => '月度趋势';
  @override String get statsNoTagData => '暂无标签数据';
  @override String get statsRecordedDaysLabel => '已记录天数';
  @override String get statsLast7Days => '最近 7 天';
  @override String get statsInspirationTitle => '本月穿搭灵感';

  @override String get editOutfitTooltip => '编辑';

  @override String get themeModeLight => '浅色';
  @override String get themeModeAuto => '自动';
  @override String get themeModeDark => '深色';
  @override String get appearanceTitle => '外观主题';
  @override String get appearanceDisplayMode => '显示模式';
  @override String get appearanceColorPalette => '主题色盘';
  @override String get presetDescSoftWardrobe => '柔和衣橱 · 预设';
  @override String get presetDescMatcha => '清爽自然 · 日常通勤';
  @override String get presetDescCityBlue => '利落现代 · 统计日历';
  @override String get presetDescRose => '柔粉杂志 · 漂亮但克制';
  @override String get presetDescNightGallery => '夜间图库 · 沉浸浏览';
  @override String get themeModeNameSystem => '跟随系统';
  @override String get themeModeNameLight => '浅色模式';
  @override String get themeModeNameDark => '深色模式';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get appTitle => '今日穿什麼';

  @override
  String get home => '首页';

  @override
  String get add => '添加';

  @override
  String get profile => '个人';

  @override
  String get addOutfit => '添加穿搭';

  @override
  String get addOutfitPage => '添加穿搭页面\n（待实现）';

  @override
  String get profilePage => '个人页面\n（待实现）';

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
  String get openSourceLicense => '开源许可';

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
  String get hintAvatarEmoji => '选一个 emoji 做头像';

  @override
  String get selectBirthday => '选择生日';

  @override
  String get avatar => '头像';

  @override
  String get avatarSelectHint => '点击选择图片';

  @override
  String get nicknameField => '昵称';
  // zh_CN inherits all new keys from AppLocalizationsZh (Simplified Chinese)
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '今日穿什麼';

  @override
  String get home => '首頁';

  @override
  String get add => '添加';

  @override
  String get profile => '個人';

  @override
  String get addOutfit => '添加穿搭';

  @override
  String get addOutfitPage => '添加穿搭頁面\n（待實現）';

  @override
  String get profilePage => '個人頁面\n（待實現）';

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
  String get openSourceLicense => '開源許可';

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
  String get hintAvatarEmoji => '選一個 emoji 做頭像';

  @override
  String get selectBirthday => '選擇生日';

  @override
  String get avatar => '頭像';

  @override
  String get avatarSelectHint => '點擊選擇圖片';

  @override
  String get nicknameField => '暱稱';

  @override String get navCalendar => '日曆';
  @override String get navStats => '統計';
  @override String get homeAppTitle => '今日穿什麼';
  @override String homeDateLabel(int weekday, int month, int day) {
    const days = ['一','二','三','四','五','六','日'];
    return '週${days[weekday - 1]}，$month月$day日';
  }
  @override String get filterDate => '約會';
  @override String get filterCasual => '休閒';
  @override String calendarMonthName(int month) {
    const names = ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'];
    return names[month - 1];
  }
  @override String get calendarWardrobeReview => '穿搭回顧';
  @override String calendarMonthTitle(int month) => '${calendarMonthName(month)}回顧';
  @override String get calendarRecordedDays => '已記錄天數';
  @override String get calendarUniqueTags => '常用標籤數';
  @override String get calendarTopOutfits => '本月最常穿';
  @override String calendarTagUsedCount(int count) => '搭配 $count 次';
  @override String calendarDaySheetTitle(int month, int day) => '$month月$day日穿搭';
  @override String get calendarNoDayOutfits => '這天還沒有穿搭記錄';
  @override String get addOutfitTitle => '新增穿搭';
  @override String get addOutfitHeroEyebrow => '今天的搭配';
  @override String get addOutfitHeroText => '先放照片，\n再補一點感覺';
  @override String get addOutfitPhotosSection => '選擇圖片';
  @override String get addOutfitDragHint => '長按拖拽排序';
  @override String get addOutfitAddPhotoBtn => '添加圖片';
  @override String get addOutfitTagsSection => '選擇標籤';
  @override String get addOutfitNoTagsHint => '暫無可用標籤';
  @override String get addOutfitSelectedTagsLabel => '已選標籤';
  @override String get addOutfitNewTagSection => '添加新標籤';
  @override String get addOutfitTagInputHint => '輸入標籤名稱';
  @override String get addOutfitDescSection => '備註';
  @override String get addOutfitDescHint => '輸入穿搭描述...';
  @override String get addOutfitSaveBtn => '保存今日穿搭';
  @override String get addOutfitSaveEditBtn => '保存修改';
  @override String get addOutfitFromGallery => '從相冊選擇';
  @override String errLoadData(String e) => '加載數據失敗：$e';
  @override String errLoadTags(String e) => '加載標籤失敗：$e';
  @override String warnImageLimit(int max) => '最多只能選擇 $max 張圖片';
  @override String warnImageLimitExceeded(int max, int kept) => '最多只能選擇 $max 張圖片，已保留前 $kept 張';
  @override String errSelectImage(String e) => '選擇圖片失敗：$e';
  @override String errTakePhoto(String e) => '拍照失敗：$e';
  @override String get warnTagAlreadyExists => '標籤已存在';
  @override String get warnSelectAtLeastOneImage => '請至少選擇一張圖片';
  @override String get warnEnterDescription => '請輸入備註';
  @override String get successOutfitSaved => '保存成功';
  @override String errSaveOutfit(String e) => '保存失敗：$e';
  @override String get statsPageTitle => '統計';
  @override String get statsTotal => '總計';
  @override String get statsKeepRecording => '保持記錄';
  @override String get statsTagFrequency => '標籤使用頻率';
  @override String get statsMonthlyTrend => '月度趨勢';
  @override String get statsNoTagData => '暫無標籤數據';
  @override String get statsRecordedDaysLabel => '已記錄天數';
  @override String get statsLast7Days => '最近 7 天';
  @override String get statsInspirationTitle => '本月穿搭靈感';
  @override String get editOutfitTooltip => '編輯';
  @override String get themeModeLight => '淺色';
  @override String get themeModeDark => '深色';
  @override String get appearanceTitle => '外觀主題';
  @override String get appearanceDisplayMode => '顯示模式';
  @override String get appearanceColorPalette => '主題色盤';
  @override String get presetDescSoftWardrobe => '柔和衣橱 · 預設';
  @override String get presetDescMatcha => '清爽自然 · 日常通勤';
  @override String get presetDescCityBlue => '利落現代 · 統計日曆';
  @override String get presetDescRose => '柔粉雜誌 · 漂亮但克制';
  @override String get presetDescNightGallery => '夜間圖庫 · 沉浸瀏覽';
  @override String get themeModeNameSystem => '跟隨系統';
  @override String get themeModeNameLight => '淺色模式';
  @override String get themeModeNameDark => '深色模式';
}
