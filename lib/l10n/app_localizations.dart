import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'今日穿什麼'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In zh_CN, this message translates to:
  /// **'首页'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In zh_CN, this message translates to:
  /// **'个人'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In zh_CN, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In zh_CN, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @today.
  ///
  /// In zh_CN, this message translates to:
  /// **'今天'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In zh_CN, this message translates to:
  /// **'昨天'**
  String get yesterday;

  /// No description provided for @dayBeforeYesterday.
  ///
  /// In zh_CN, this message translates to:
  /// **'前天'**
  String get dayBeforeYesterday;

  /// No description provided for @dateFormat.
  ///
  /// In zh_CN, this message translates to:
  /// **'{month}月{day}日'**
  String dateFormat(int month, int day);

  /// No description provided for @simplifiedChinese.
  ///
  /// In zh_CN, this message translates to:
  /// **'简体中文'**
  String get simplifiedChinese;

  /// No description provided for @traditionalChinese.
  ///
  /// In zh_CN, this message translates to:
  /// **'繁体中文'**
  String get traditionalChinese;

  /// No description provided for @english.
  ///
  /// In zh_CN, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In zh_CN, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @korean.
  ///
  /// In zh_CN, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @nickname.
  ///
  /// In zh_CN, this message translates to:
  /// **'用户'**
  String get nickname;

  /// No description provided for @version.
  ///
  /// In zh_CN, this message translates to:
  /// **'版本'**
  String get version;

  /// No description provided for @appVersion.
  ///
  /// In zh_CN, this message translates to:
  /// **'1.0.0'**
  String get appVersion;

  /// No description provided for @privacyPolicy.
  ///
  /// In zh_CN, this message translates to:
  /// **'隐私政策'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In zh_CN, this message translates to:
  /// **'使用条款'**
  String get termsOfService;

  /// No description provided for @contact.
  ///
  /// In zh_CN, this message translates to:
  /// **'联系方式'**
  String get contact;

  /// No description provided for @about.
  ///
  /// In zh_CN, this message translates to:
  /// **'关于应用'**
  String get about;

  /// No description provided for @save.
  ///
  /// In zh_CN, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In zh_CN, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @deleteOutfitConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定要删除这条穿搭记录吗？删除后无法恢复。'**
  String get deleteOutfitConfirm;

  /// No description provided for @tagManagement.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签管理'**
  String get tagManagement;

  /// No description provided for @tagName.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签名称'**
  String get tagName;

  /// No description provided for @tagColor.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签颜色'**
  String get tagColor;

  /// No description provided for @tagEdit.
  ///
  /// In zh_CN, this message translates to:
  /// **'编辑标签'**
  String get tagEdit;

  /// No description provided for @tagDeleteConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定要删除该标签吗？'**
  String get tagDeleteConfirm;

  /// No description provided for @tagDeleteConfirmInUse.
  ///
  /// In zh_CN, this message translates to:
  /// **'该标签已被 {count} 条穿搭使用，删除将从这些穿搭中移除该标签。确定删除吗？'**
  String tagDeleteConfirmInUse(int count);

  /// No description provided for @tagNameEmpty.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入标签名称'**
  String get tagNameEmpty;

  /// No description provided for @tagNameDuplicate.
  ///
  /// In zh_CN, this message translates to:
  /// **'该标签名称已存在'**
  String get tagNameDuplicate;

  /// No description provided for @tagSaved.
  ///
  /// In zh_CN, this message translates to:
  /// **'已保存'**
  String get tagSaved;

  /// No description provided for @tagNoTags.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无标签'**
  String get tagNoTags;

  /// No description provided for @tagManagementWithCount.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签管理（共 {count} 个）'**
  String tagManagementWithCount(int count);

  /// No description provided for @homeEmptyMessage.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有穿搭记录\n添加第一条穿搭，开始记录你的每日穿搭吧'**
  String get homeEmptyMessage;

  /// No description provided for @homeAddFirstOutfit.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加第一条穿搭'**
  String get homeAddFirstOutfit;

  /// No description provided for @contactQQ.
  ///
  /// In zh_CN, this message translates to:
  /// **'QQ'**
  String get contactQQ;

  /// No description provided for @contactEmail.
  ///
  /// In zh_CN, this message translates to:
  /// **'邮箱'**
  String get contactEmail;

  /// No description provided for @contactEmailCopyHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'无法打开邮件应用，请手动复制邮箱地址'**
  String get contactEmailCopyHint;

  /// No description provided for @copiedToClipboard.
  ///
  /// In zh_CN, this message translates to:
  /// **'已复制'**
  String get copiedToClipboard;

  /// No description provided for @editProfile.
  ///
  /// In zh_CN, this message translates to:
  /// **'编辑资料'**
  String get editProfile;

  /// No description provided for @birthday.
  ///
  /// In zh_CN, this message translates to:
  /// **'生日'**
  String get birthday;

  /// No description provided for @gender.
  ///
  /// In zh_CN, this message translates to:
  /// **'性别'**
  String get gender;

  /// No description provided for @personality.
  ///
  /// In zh_CN, this message translates to:
  /// **'性格'**
  String get personality;

  /// No description provided for @male.
  ///
  /// In zh_CN, this message translates to:
  /// **'男'**
  String get male;

  /// No description provided for @female.
  ///
  /// In zh_CN, this message translates to:
  /// **'女'**
  String get female;

  /// No description provided for @genderNotSpecified.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂不选择'**
  String get genderNotSpecified;

  /// No description provided for @profileSaved.
  ///
  /// In zh_CN, this message translates to:
  /// **'已保存'**
  String get profileSaved;

  /// No description provided for @hintNickname.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入昵称'**
  String get hintNickname;

  /// No description provided for @hintPersonality.
  ///
  /// In zh_CN, this message translates to:
  /// **'介绍一下你的性格吧～'**
  String get hintPersonality;

  /// No description provided for @selectBirthday.
  ///
  /// In zh_CN, this message translates to:
  /// **'选择生日'**
  String get selectBirthday;

  /// No description provided for @nicknameField.
  ///
  /// In zh_CN, this message translates to:
  /// **'昵称'**
  String get nicknameField;

  /// No description provided for @navCalendar.
  ///
  /// In zh_CN, this message translates to:
  /// **'日历'**
  String get navCalendar;

  /// No description provided for @navAdd.
  ///
  /// In zh_CN, this message translates to:
  /// **'记录'**
  String get navAdd;

  /// No description provided for @navStats.
  ///
  /// In zh_CN, this message translates to:
  /// **'统计'**
  String get navStats;

  /// No description provided for @homeAppTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'今日穿什么'**
  String get homeAppTitle;

  /// No description provided for @homeDateLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'{weekday, select, 1{周一} 2{周二} 3{周三} 4{周四} 5{周五} 6{周六} 7{周日} other{}} · {month}月{day}日'**
  String homeDateLabel(String weekday, int month, int day);

  /// No description provided for @filterAll.
  ///
  /// In zh_CN, this message translates to:
  /// **'全部'**
  String get filterAll;

  /// No description provided for @addOutfitTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'新增穿搭'**
  String get addOutfitTitle;

  /// No description provided for @editOutfitTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'编辑穿搭'**
  String get editOutfitTitle;

  /// No description provided for @addOutfitHeroEyebrow.
  ///
  /// In zh_CN, this message translates to:
  /// **'今日穿搭'**
  String get addOutfitHeroEyebrow;

  /// No description provided for @addOutfitHeroText.
  ///
  /// In zh_CN, this message translates to:
  /// **'记录你的穿搭'**
  String get addOutfitHeroText;

  /// No description provided for @addOutfitPhotosSection.
  ///
  /// In zh_CN, this message translates to:
  /// **'照片'**
  String get addOutfitPhotosSection;

  /// No description provided for @addOutfitDragHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'拖动可排序'**
  String get addOutfitDragHint;

  /// No description provided for @addOutfitAddPhotoBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加照片'**
  String get addOutfitAddPhotoBtn;

  /// No description provided for @addOutfitFromGallery.
  ///
  /// In zh_CN, this message translates to:
  /// **'从相册选择'**
  String get addOutfitFromGallery;

  /// No description provided for @addOutfitTakePhotoOption.
  ///
  /// In zh_CN, this message translates to:
  /// **'拍照'**
  String get addOutfitTakePhotoOption;

  /// No description provided for @addOutfitTagsSection.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签'**
  String get addOutfitTagsSection;

  /// No description provided for @addOutfitNoTagsHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无标签'**
  String get addOutfitNoTagsHint;

  /// No description provided for @addOutfitSelectedTagsLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'已选标签'**
  String get addOutfitSelectedTagsLabel;

  /// No description provided for @addOutfitNewTagSection.
  ///
  /// In zh_CN, this message translates to:
  /// **'新建标签'**
  String get addOutfitNewTagSection;

  /// No description provided for @addOutfitTagInputHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'输入标签名称'**
  String get addOutfitTagInputHint;

  /// No description provided for @addOutfitAddTagBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加'**
  String get addOutfitAddTagBtn;

  /// No description provided for @addOutfitDescSection.
  ///
  /// In zh_CN, this message translates to:
  /// **'描述'**
  String get addOutfitDescSection;

  /// No description provided for @addOutfitDescHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'描述一下今天的穿搭...'**
  String get addOutfitDescHint;

  /// No description provided for @addOutfitSaveBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'保存穿搭'**
  String get addOutfitSaveBtn;

  /// No description provided for @addOutfitSaveEditBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'保存修改'**
  String get addOutfitSaveEditBtn;

  /// No description provided for @warnTagAlreadyExists.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签已存在'**
  String get warnTagAlreadyExists;

  /// No description provided for @warnSelectAtLeastOneImage.
  ///
  /// In zh_CN, this message translates to:
  /// **'请至少选择一张图片'**
  String get warnSelectAtLeastOneImage;

  /// No description provided for @warnEnterDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'请填写描述'**
  String get warnEnterDescription;

  /// No description provided for @warnImageLimit.
  ///
  /// In zh_CN, this message translates to:
  /// **'最多只能添加 {maxImages} 张图片'**
  String warnImageLimit(int maxImages);

  /// No description provided for @warnImageLimitExceeded.
  ///
  /// In zh_CN, this message translates to:
  /// **'最多添加 {maxImages} 张，还可添加 {remainingSlots} 张'**
  String warnImageLimitExceeded(int maxImages, int remainingSlots);

  /// No description provided for @successOutfitSaved.
  ///
  /// In zh_CN, this message translates to:
  /// **'穿搭已保存'**
  String get successOutfitSaved;

  /// No description provided for @errLoadData.
  ///
  /// In zh_CN, this message translates to:
  /// **'加载失败：{error}'**
  String errLoadData(String error);

  /// No description provided for @errLoadTags.
  ///
  /// In zh_CN, this message translates to:
  /// **'加载标签失败：{error}'**
  String errLoadTags(String error);

  /// No description provided for @errSelectImage.
  ///
  /// In zh_CN, this message translates to:
  /// **'选择图片失败：{error}'**
  String errSelectImage(String error);

  /// No description provided for @errTakePhoto.
  ///
  /// In zh_CN, this message translates to:
  /// **'拍照失败：{error}'**
  String errTakePhoto(String error);

  /// No description provided for @errSaveOutfit.
  ///
  /// In zh_CN, this message translates to:
  /// **'保存失败：{error}'**
  String errSaveOutfit(String error);

  /// No description provided for @calendarWardrobeReview.
  ///
  /// In zh_CN, this message translates to:
  /// **'衣橱回顾'**
  String get calendarWardrobeReview;

  /// No description provided for @calendarMonthTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'{month, select, 1{1月} 2{2月} 3{3月} 4{4月} 5{5月} 6{6月} 7{7月} 8{8月} 9{9月} 10{10月} 11{11月} 12{12月} other{}}'**
  String calendarMonthTitle(String month);

  /// No description provided for @calendarMonthName.
  ///
  /// In zh_CN, this message translates to:
  /// **'{month, select, 1{1月} 2{2月} 3{3月} 4{4月} 5{5月} 6{6月} 7{7月} 8{8月} 9{9月} 10{10月} 11{11月} 12{12月} other{}}'**
  String calendarMonthName(String month);

  /// No description provided for @calendarRecordedDays.
  ///
  /// In zh_CN, this message translates to:
  /// **'记录天数'**
  String get calendarRecordedDays;

  /// No description provided for @calendarUniqueTags.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签种类'**
  String get calendarUniqueTags;

  /// No description provided for @calendarTopOutfits.
  ///
  /// In zh_CN, this message translates to:
  /// **'热门穿搭'**
  String get calendarTopOutfits;

  /// No description provided for @calendarTagUsedCount.
  ///
  /// In zh_CN, this message translates to:
  /// **'使用 {count} 次'**
  String calendarTagUsedCount(int count);

  /// No description provided for @calendarDaySheetTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'{month}月{day}日'**
  String calendarDaySheetTitle(int month, int day);

  /// No description provided for @calendarNoDayOutfits.
  ///
  /// In zh_CN, this message translates to:
  /// **'这天没有穿搭记录'**
  String get calendarNoDayOutfits;

  /// No description provided for @statsPageTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'统计'**
  String get statsPageTitle;

  /// No description provided for @statsMonthly.
  ///
  /// In zh_CN, this message translates to:
  /// **'本月'**
  String get statsMonthly;

  /// No description provided for @statsRecordedDaysLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'记录天数'**
  String get statsRecordedDaysLabel;

  /// No description provided for @statsLast7Days.
  ///
  /// In zh_CN, this message translates to:
  /// **'近7天'**
  String get statsLast7Days;

  /// No description provided for @statsTotal.
  ///
  /// In zh_CN, this message translates to:
  /// **'累计'**
  String get statsTotal;

  /// No description provided for @statsTagFrequency.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签频率'**
  String get statsTagFrequency;

  /// No description provided for @statsInspirationTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'穿搭灵感'**
  String get statsInspirationTitle;

  /// No description provided for @editOutfitTooltip.
  ///
  /// In zh_CN, this message translates to:
  /// **'编辑'**
  String get editOutfitTooltip;

  /// No description provided for @appearanceTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'外观'**
  String get appearanceTitle;

  /// No description provided for @appearanceDisplayMode.
  ///
  /// In zh_CN, this message translates to:
  /// **'显示模式'**
  String get appearanceDisplayMode;

  /// No description provided for @appearanceColorPalette.
  ///
  /// In zh_CN, this message translates to:
  /// **'色彩主题'**
  String get appearanceColorPalette;

  /// No description provided for @presetDescSoftWardrobe.
  ///
  /// In zh_CN, this message translates to:
  /// **'柔美衣橱'**
  String get presetDescSoftWardrobe;

  /// No description provided for @presetDescMatcha.
  ///
  /// In zh_CN, this message translates to:
  /// **'抹茶日和'**
  String get presetDescMatcha;

  /// No description provided for @presetDescCityBlue.
  ///
  /// In zh_CN, this message translates to:
  /// **'城市蓝调'**
  String get presetDescCityBlue;

  /// No description provided for @presetDescRose.
  ///
  /// In zh_CN, this message translates to:
  /// **'玫瑰编辑'**
  String get presetDescRose;

  /// No description provided for @presetDescNightGallery.
  ///
  /// In zh_CN, this message translates to:
  /// **'暗夜画廊'**
  String get presetDescNightGallery;

  /// No description provided for @themeModeLight.
  ///
  /// In zh_CN, this message translates to:
  /// **'浅色'**
  String get themeModeLight;

  /// No description provided for @themeModeAuto.
  ///
  /// In zh_CN, this message translates to:
  /// **'跟随系统'**
  String get themeModeAuto;

  /// No description provided for @themeModeDark.
  ///
  /// In zh_CN, this message translates to:
  /// **'深色'**
  String get themeModeDark;

  /// No description provided for @weatherPlaceholderLocation.
  ///
  /// In zh_CN, this message translates to:
  /// **'北京 · 晴天'**
  String get weatherPlaceholderLocation;

  /// No description provided for @weatherPlaceholderAdvice.
  ///
  /// In zh_CN, this message translates to:
  /// **'薄外套刚刚好'**
  String get weatherPlaceholderAdvice;

  /// No description provided for @reminderTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'每日提醒'**
  String get reminderTitle;

  /// No description provided for @reminderEnabledCount.
  ///
  /// In zh_CN, this message translates to:
  /// **'已开启 {count} 个'**
  String reminderEnabledCount(Object count);

  /// No description provided for @reminderEmptyMessage.
  ///
  /// In zh_CN, this message translates to:
  /// **'设置提醒，不再忘记记录穿搭'**
  String get reminderEmptyMessage;

  /// No description provided for @reminderAddBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加提醒'**
  String get reminderAddBtn;

  /// No description provided for @reminderTimeLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'提醒时间'**
  String get reminderTimeLabel;

  /// No description provided for @reminderWeekdaysLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'重复日期'**
  String get reminderWeekdaysLabel;

  /// No description provided for @reminderWeekdaysEveryday.
  ///
  /// In zh_CN, this message translates to:
  /// **'每天'**
  String get reminderWeekdaysEveryday;

  /// No description provided for @reminderSkipLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'当天已记录则跳过'**
  String get reminderSkipLabel;

  /// No description provided for @reminderSkipHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'如果今天已经记录过穿搭，将不会发送提醒'**
  String get reminderSkipHint;

  /// No description provided for @reminderAddTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'新增提醒'**
  String get reminderAddTitle;

  /// No description provided for @reminderEditTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'编辑提醒'**
  String get reminderEditTitle;

  /// No description provided for @reminderDelete.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除提醒'**
  String get reminderDelete;

  /// No description provided for @reminderDeleteConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定删除此提醒吗？'**
  String get reminderDeleteConfirm;

  /// No description provided for @reminderSave.
  ///
  /// In zh_CN, this message translates to:
  /// **'保存'**
  String get reminderSave;

  /// No description provided for @reminderDayMon.
  ///
  /// In zh_CN, this message translates to:
  /// **'周一'**
  String get reminderDayMon;

  /// No description provided for @reminderDayTue.
  ///
  /// In zh_CN, this message translates to:
  /// **'周二'**
  String get reminderDayTue;

  /// No description provided for @reminderDayWed.
  ///
  /// In zh_CN, this message translates to:
  /// **'周三'**
  String get reminderDayWed;

  /// No description provided for @reminderDayThu.
  ///
  /// In zh_CN, this message translates to:
  /// **'周四'**
  String get reminderDayThu;

  /// No description provided for @reminderDayFri.
  ///
  /// In zh_CN, this message translates to:
  /// **'周五'**
  String get reminderDayFri;

  /// No description provided for @reminderDaySat.
  ///
  /// In zh_CN, this message translates to:
  /// **'周六'**
  String get reminderDaySat;

  /// No description provided for @reminderDaySun.
  ///
  /// In zh_CN, this message translates to:
  /// **'周日'**
  String get reminderDaySun;

  /// No description provided for @reminderNotificationTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'今日穿搭'**
  String get reminderNotificationTitle;

  /// No description provided for @reminderNotificationBody.
  ///
  /// In zh_CN, this message translates to:
  /// **'别忘了记录今天的穿搭哦～'**
  String get reminderNotificationBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
