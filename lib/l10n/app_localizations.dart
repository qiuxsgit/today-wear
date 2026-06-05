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
  /// **'0.0.1'**
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

  /// No description provided for @tagAdd.
  ///
  /// In zh_CN, this message translates to:
  /// **'新增标签'**
  String get tagAdd;

  /// No description provided for @tagDeleteConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定要删除该标签吗？'**
  String get tagDeleteConfirm;

  /// No description provided for @verConflictTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'数据冲突'**
  String get verConflictTitle;

  /// No description provided for @verConflictMessage.
  ///
  /// In zh_CN, this message translates to:
  /// **'这条记录在其他设备上有更新，与本机未同步的修改冲突。保留哪个版本？'**
  String get verConflictMessage;

  /// No description provided for @verKeepLocal.
  ///
  /// In zh_CN, this message translates to:
  /// **'保留本机'**
  String get verKeepLocal;

  /// No description provided for @verUseCloud.
  ///
  /// In zh_CN, this message translates to:
  /// **'用云端'**
  String get verUseCloud;

  /// No description provided for @verRemoteDeletedTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'云端已删除'**
  String get verRemoteDeletedTitle;

  /// No description provided for @verRemoteDeletedMessage.
  ///
  /// In zh_CN, this message translates to:
  /// **'这条记录已在其他设备上删除。'**
  String get verRemoteDeletedMessage;

  /// No description provided for @verRestore.
  ///
  /// In zh_CN, this message translates to:
  /// **'恢复'**
  String get verRestore;

  /// No description provided for @verAcceptDelete.
  ///
  /// In zh_CN, this message translates to:
  /// **'接受删除'**
  String get verAcceptDelete;

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

  /// No description provided for @authLoginTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录'**
  String get authLoginTitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'注册账号'**
  String get authRegisterTitle;

  /// No description provided for @authLoginHeadline.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录以同步你的穿搭'**
  String get authLoginHeadline;

  /// No description provided for @authRegisterHeadline.
  ///
  /// In zh_CN, this message translates to:
  /// **'创建账号以开启云同步'**
  String get authRegisterHeadline;

  /// No description provided for @authOfflineNote.
  ///
  /// In zh_CN, this message translates to:
  /// **'云同步为可选功能，不登录也能离线使用全部记录功能。'**
  String get authOfflineNote;

  /// No description provided for @authEmailLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'邮箱'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'密码'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'至少 8 位'**
  String get authPasswordHint;

  /// No description provided for @authEmailInvalid.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入有效的邮箱地址'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In zh_CN, this message translates to:
  /// **'密码至少 8 位'**
  String get authPasswordTooShort;

  /// No description provided for @authLoginSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录成功'**
  String get authLoginSuccess;

  /// No description provided for @authRegisterSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'注册成功'**
  String get authRegisterSuccess;

  /// No description provided for @authRegisterBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'注册'**
  String get authRegisterBtn;

  /// No description provided for @authSwitchToLogin.
  ///
  /// In zh_CN, this message translates to:
  /// **'已有账号？去登录'**
  String get authSwitchToLogin;

  /// No description provided for @authSwitchToRegister.
  ///
  /// In zh_CN, this message translates to:
  /// **'还没有账号？去注册'**
  String get authSwitchToRegister;

  /// No description provided for @accountSyncTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'账户与云同步'**
  String get accountSyncTitle;

  /// No description provided for @accountNotLoggedIn.
  ///
  /// In zh_CN, this message translates to:
  /// **'未登录'**
  String get accountNotLoggedIn;

  /// No description provided for @accountCloudOff.
  ///
  /// In zh_CN, this message translates to:
  /// **'云同步未开启'**
  String get accountCloudOff;

  /// No description provided for @accountCloudIntro.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录后可将穿搭、标签与资料同步到云端，换设备也能找回。\n不登录不影响任何本地功能。'**
  String get accountCloudIntro;

  /// No description provided for @accountRegisterNewBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'注册新账号'**
  String get accountRegisterNewBtn;

  /// No description provided for @accountLoggedIn.
  ///
  /// In zh_CN, this message translates to:
  /// **'已登录'**
  String get accountLoggedIn;

  /// No description provided for @accountDeviceManagement.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录设备管理'**
  String get accountDeviceManagement;

  /// No description provided for @accountLogout.
  ///
  /// In zh_CN, this message translates to:
  /// **'退出登录'**
  String get accountLogout;

  /// No description provided for @accountLogoutDialogContent.
  ///
  /// In zh_CN, this message translates to:
  /// **'退出后云同步将停止，本地数据保留。确定退出吗？'**
  String get accountLogoutDialogContent;

  /// No description provided for @accountLogoutConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'退出'**
  String get accountLogoutConfirm;

  /// No description provided for @accountLoggedOutToast.
  ///
  /// In zh_CN, this message translates to:
  /// **'已退出登录'**
  String get accountLoggedOutToast;

  /// No description provided for @accountCloudSyncLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'云同步'**
  String get accountCloudSyncLabel;

  /// No description provided for @syncStatusSyncing.
  ///
  /// In zh_CN, this message translates to:
  /// **'同步中…'**
  String get syncStatusSyncing;

  /// No description provided for @syncStatusNever.
  ///
  /// In zh_CN, this message translates to:
  /// **'尚未同步'**
  String get syncStatusNever;

  /// No description provided for @syncStatusLast.
  ///
  /// In zh_CN, this message translates to:
  /// **'上次同步 {time}'**
  String syncStatusLast(String time);

  /// No description provided for @syncNowBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'立即同步'**
  String get syncNowBtn;

  /// No description provided for @syncErrPremiumRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'云同步需要会员订阅'**
  String get syncErrPremiumRequired;

  /// No description provided for @syncErrGeneric.
  ///
  /// In zh_CN, this message translates to:
  /// **'同步失败，请稍后重试'**
  String get syncErrGeneric;

  /// No description provided for @deviceSessionsTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录设备'**
  String get deviceSessionsTitle;

  /// No description provided for @deviceSessionsEmpty.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无活跃会话'**
  String get deviceSessionsEmpty;

  /// No description provided for @deviceRemoved.
  ///
  /// In zh_CN, this message translates to:
  /// **'已移除该设备'**
  String get deviceRemoved;

  /// No description provided for @deviceRemoveTooltip.
  ///
  /// In zh_CN, this message translates to:
  /// **'移除该设备'**
  String get deviceRemoveTooltip;

  /// No description provided for @deviceCurrentBadge.
  ///
  /// In zh_CN, this message translates to:
  /// **'本机'**
  String get deviceCurrentBadge;

  /// No description provided for @retry.
  ///
  /// In zh_CN, this message translates to:
  /// **'重试'**
  String get retry;

  /// No description provided for @errNetwork.
  ///
  /// In zh_CN, this message translates to:
  /// **'网络连接失败，请检查网络后重试'**
  String get errNetwork;

  /// No description provided for @errRequestTimeout.
  ///
  /// In zh_CN, this message translates to:
  /// **'请求超时，请稍后重试'**
  String get errRequestTimeout;

  /// No description provided for @errSessionExpired.
  ///
  /// In zh_CN, this message translates to:
  /// **'登录已失效，请重新登录'**
  String get errSessionExpired;

  /// No description provided for @errPremiumRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'此功能需要会员'**
  String get errPremiumRequired;

  /// No description provided for @errGeneric.
  ///
  /// In zh_CN, this message translates to:
  /// **'操作失败，请稍后重试'**
  String get errGeneric;

  /// No description provided for @errLoadFailed.
  ///
  /// In zh_CN, this message translates to:
  /// **'加载失败，请稍后重试'**
  String get errLoadFailed;

  /// No description provided for @errUploadFailed.
  ///
  /// In zh_CN, this message translates to:
  /// **'图片上传失败，请检查网络'**
  String get errUploadFailed;

  /// No description provided for @proTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'今天穿什么 Pro'**
  String get proTitle;

  /// No description provided for @proIntro.
  ///
  /// In zh_CN, this message translates to:
  /// **'解锁云同步：穿搭、标签与资料多设备备份，换机不丢。'**
  String get proIntro;

  /// No description provided for @proSubscribeBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'开通 Pro'**
  String get proSubscribeBtn;

  /// No description provided for @proRestoreBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'恢复购买'**
  String get proRestoreBtn;

  /// No description provided for @proActiveBadge.
  ///
  /// In zh_CN, this message translates to:
  /// **'已开通'**
  String get proActiveBadge;

  /// No description provided for @proExpiresAt.
  ///
  /// In zh_CN, this message translates to:
  /// **'{date} 到期'**
  String proExpiresAt(String date);

  /// No description provided for @proLifetime.
  ///
  /// In zh_CN, this message translates to:
  /// **'永久有效'**
  String get proLifetime;

  /// No description provided for @proManageBtn.
  ///
  /// In zh_CN, this message translates to:
  /// **'管理订阅'**
  String get proManageBtn;

  /// No description provided for @proPurchaseSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'Pro 已开通'**
  String get proPurchaseSuccess;

  /// No description provided for @proRestoreSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'购买已恢复'**
  String get proRestoreSuccess;

  /// No description provided for @proNothingToRestore.
  ///
  /// In zh_CN, this message translates to:
  /// **'没有可恢复的购买'**
  String get proNothingToRestore;

  /// No description provided for @proPurchaseFailed.
  ///
  /// In zh_CN, this message translates to:
  /// **'购买失败，请稍后重试'**
  String get proPurchaseFailed;

  /// No description provided for @proAlreadyActive.
  ///
  /// In zh_CN, this message translates to:
  /// **'你已是 Pro 会员'**
  String get proAlreadyActive;

  /// No description provided for @proSyncPending.
  ///
  /// In zh_CN, this message translates to:
  /// **'已购买，正在生效…'**
  String get proSyncPending;

  /// No description provided for @proUnsupportedPlatform.
  ///
  /// In zh_CN, this message translates to:
  /// **'请在 iPhone 或 Android 手机上购买'**
  String get proUnsupportedPlatform;

  /// No description provided for @proLoginFirst.
  ///
  /// In zh_CN, this message translates to:
  /// **'请先登录账号再开通 Pro'**
  String get proLoginFirst;

  /// No description provided for @proMonthlyLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'月度订阅'**
  String get proMonthlyLabel;

  /// No description provided for @proYearlyLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'年度订阅'**
  String get proYearlyLabel;

  /// No description provided for @proLifetimeLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'永久买断'**
  String get proLifetimeLabel;

  /// No description provided for @proPaywallLoadFailed.
  ///
  /// In zh_CN, this message translates to:
  /// **'无法加载商品，请稍后重试'**
  String get proPaywallLoadFailed;

  /// No description provided for @proPaymentPending.
  ///
  /// In zh_CN, this message translates to:
  /// **'支付待确认，完成后自动生效'**
  String get proPaymentPending;

  /// No description provided for @proSubscriptionNote.
  ///
  /// In zh_CN, this message translates to:
  /// **'订阅自动续费，可随时在系统订阅管理中取消；买断为一次性付费。'**
  String get proSubscriptionNote;

  /// No description provided for @proPurchaseCta.
  ///
  /// In zh_CN, this message translates to:
  /// **'立即开通'**
  String get proPurchaseCta;

  /// No description provided for @logUpload.
  ///
  /// In zh_CN, this message translates to:
  /// **'日志上传'**
  String get logUpload;

  /// No description provided for @logUploadEmpty.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无日志文件'**
  String get logUploadEmpty;

  /// No description provided for @logUploadConfirmTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'上传日志'**
  String get logUploadConfirmTitle;

  /// No description provided for @logUploadConfirmMessage.
  ///
  /// In zh_CN, this message translates to:
  /// **'将上传该日志文件用于问题排查'**
  String get logUploadConfirmMessage;

  /// No description provided for @logUploadRemarkHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'描述遇到的问题（可选）'**
  String get logUploadRemarkHint;

  /// No description provided for @logUploadAction.
  ///
  /// In zh_CN, this message translates to:
  /// **'上传'**
  String get logUploadAction;

  /// No description provided for @logUploadSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'日志上传成功'**
  String get logUploadSuccess;

  /// No description provided for @logUploadFailed.
  ///
  /// In zh_CN, this message translates to:
  /// **'日志上传失败'**
  String get logUploadFailed;

  /// No description provided for @logUploadLoginRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'请先登录后再上传日志'**
  String get logUploadLoginRequired;

  /// No description provided for @accountDelete.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除账号'**
  String get accountDelete;

  /// No description provided for @accountDeleteDialogTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'永久删除账号？'**
  String get accountDeleteDialogTitle;

  /// No description provided for @accountDeleteDialogContent.
  ///
  /// In zh_CN, this message translates to:
  /// **'云端数据（穿搭、标签、资料、图片）将被永久删除。本机的本地数据会保留，App 仍可完整使用。订阅不会自动取消，请前往 App Store / Google Play 自行管理。此操作不可恢复。'**
  String get accountDeleteDialogContent;

  /// No description provided for @accountDeletePasswordHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'输入密码以确认'**
  String get accountDeletePasswordHint;

  /// No description provided for @accountDeletePasswordRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入密码'**
  String get accountDeletePasswordRequired;

  /// No description provided for @accountDeleteConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'永久删除'**
  String get accountDeleteConfirm;

  /// No description provided for @accountDeleteSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'账号已删除'**
  String get accountDeleteSuccess;

  /// No description provided for @alreadyLatestVersion.
  ///
  /// In zh_CN, this message translates to:
  /// **'已是最新版本'**
  String get alreadyLatestVersion;

  /// No description provided for @newVersionFound.
  ///
  /// In zh_CN, this message translates to:
  /// **'发现新版本'**
  String get newVersionFound;

  /// No description provided for @updateNow.
  ///
  /// In zh_CN, this message translates to:
  /// **'立即更新'**
  String get updateNow;

  /// No description provided for @updateLater.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂不更新'**
  String get updateLater;

  /// No description provided for @forceUpdateNotice.
  ///
  /// In zh_CN, this message translates to:
  /// **'当前版本过旧，需更新后才能继续使用'**
  String get forceUpdateNotice;

  /// No description provided for @updateDownloading.
  ///
  /// In zh_CN, this message translates to:
  /// **'正在下载更新…'**
  String get updateDownloading;

  /// No description provided for @updateDownloadFailed.
  ///
  /// In zh_CN, this message translates to:
  /// **'下载失败，请稍后再试'**
  String get updateDownloadFailed;

  /// No description provided for @updateCheckFailed.
  ///
  /// In zh_CN, this message translates to:
  /// **'检查更新失败，请稍后再试'**
  String get updateCheckFailed;
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
