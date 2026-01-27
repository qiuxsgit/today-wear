// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '오늘의 코디';

  @override
  String get home => '홈';

  @override
  String get add => '추가';

  @override
  String get profile => '프로필';

  @override
  String get addOutfit => '코디 추가';

  @override
  String get addOutfitPage => '코디 추가 페이지\n(준비 중)';

  @override
  String get profilePage => '프로필 페이지\n(준비 중)';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get dayBeforeYesterday => '그저께';

  @override
  String dateFormat(int month, int day) {
    return '$month월 $day일';
  }

  @override
  String get simplifiedChinese => '간체 중국어';

  @override
  String get traditionalChinese => '번체 중국어';

  @override
  String get english => '영어';

  @override
  String get japanese => '일본어';

  @override
  String get korean => '한국어';

  @override
  String get nickname => '사용자';

  @override
  String get version => '버전';

  @override
  String get appVersion => '1.0.0';

  @override
  String get privacyPolicy => '개인정보 보호정책';

  @override
  String get termsOfService => '이용약관';

  @override
  String get openSourceLicense => '오픈소스 라이선스';

  @override
  String get contact => '연락처';

  @override
  String get about => '앱 정보';
}
