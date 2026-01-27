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

  /// No description provided for @add.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加'**
  String get add;

  /// No description provided for @profile.
  ///
  /// In zh_CN, this message translates to:
  /// **'个人'**
  String get profile;

  /// No description provided for @addOutfit.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加穿搭'**
  String get addOutfit;

  /// No description provided for @addOutfitPage.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加穿搭页面\n（待实现）'**
  String get addOutfitPage;

  /// No description provided for @profilePage.
  ///
  /// In zh_CN, this message translates to:
  /// **'个人页面\n（待实现）'**
  String get profilePage;

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

  /// No description provided for @openSourceLicense.
  ///
  /// In zh_CN, this message translates to:
  /// **'开源许可'**
  String get openSourceLicense;

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
