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

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get cancel => '취소';

  @override
  String get deleteOutfitConfirm => '이 코디 기록을 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다.';

  @override
  String get tagManagement => '태그 관리';

  @override
  String get tagName => '태그 이름';

  @override
  String get tagColor => '태그 색상';

  @override
  String get tagEdit => '태그 편집';

  @override
  String get tagDeleteConfirm => '이 태그를 삭제하시겠습니까?';

  @override
  String tagDeleteConfirmInUse(int count) {
    return '이 태그는 $count개의 코디에서 사용 중입니다. 삭제하면 해당 코디에서 제거됩니다. 삭제하시겠습니까?';
  }

  @override
  String get tagNameEmpty => '태그 이름을 입력하세요';

  @override
  String get tagNameDuplicate => '이미 존재하는 태그 이름입니다';

  @override
  String get tagSaved => '저장됨';

  @override
  String get tagNoTags => '태그가 없습니다';

  @override
  String tagManagementWithCount(int count) {
    return '태그 관리 (총 $count개)';
  }

  @override
  String get homeEmptyMessage => '아직 코디 기록이 없어요.\n첫 코디를 추가하고 매일의 코디를 기록해 보세요.';

  @override
  String get homeAddFirstOutfit => '첫 코디 추가';

  @override
  String get contactQQ => 'QQ';

  @override
  String get contactEmail => '이메일';

  @override
  String get contactEmailCopyHint => '이메일 앱을 열 수 없습니다. 이메일 주소를 수동으로 복사해 주세요.';

  @override
  String get copiedToClipboard => '복사됨';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get birthday => '생일';

  @override
  String get gender => '성별';

  @override
  String get personality => '성격';

  @override
  String get male => '남성';

  @override
  String get female => '여성';

  @override
  String get genderNotSpecified => '선택 안 함';

  @override
  String get profileSaved => '저장됨';

  @override
  String get hintNickname => '닉네임을 입력하세요';

  @override
  String get hintPersonality => '당신의 성격을 소개해 주세요～';

  @override
  String get hintAvatarEmoji => '아바타용 이모지를 선택하세요';

  @override
  String get selectBirthday => '생일 선택';

  @override
  String get avatar => '아바타';

  @override
  String get avatarSelectHint => '탭하여 사진 선택';

  @override
  String get nicknameField => '닉네임';

  @override String get navCalendar => '달력';
  @override String get navAdd => '추가';
  @override String get navStats => '통계';

  @override String get homeAppTitle => '오늘의 코디';
  @override String homeDateLabel(int weekday, int month, int day) {
    const days = ['월','화','수','목','금','토','일'];
    return '${days[weekday - 1]}요일, $month/$day';
  }
  @override String get filterAll => '전체';
  @override String get filterCommute => '출퇴근';
  @override String get filterDate => '데이트';
  @override String get filterRainy => '우천';
  @override String get filterCasual => '캐주얼';

  @override String calendarMonthName(int month) => '$month월';
  @override String get calendarWardrobeReview => '옷장 기록';
  @override String calendarMonthTitle(int month) => '$month월 돌아보기';
  @override String get calendarRecordedDays => '기록한 일수';
  @override String get calendarUniqueTags => '사용 태그 수';
  @override String get calendarTopOutfits => '이번달 자주 입은';
  @override String calendarTagUsedCount(int count) => '$count회 착용';
  @override String calendarDaySheetTitle(int month, int day) => '$month/$day 코디';
  @override String get calendarNoDayOutfits => '이날 코디 기록 없음';

  @override String get addOutfitTitle => '새 코디';
  @override String get addOutfitHeroEyebrow => '오늘의 코디';
  @override String get addOutfitHeroText => '사진 먼저,\n느낌을 더해봐요';
  @override String get addOutfitPhotosSection => '사진';
  @override String get addOutfitDragHint => '꾹 눌러 순서 변경';
  @override String get addOutfitAddPhotoBtn => '사진 추가';
  @override String get addOutfitTagsSection => '태그';
  @override String get addOutfitNoTagsHint => '사용 가능한 태그 없음';
  @override String get addOutfitSelectedTagsLabel => '선택한 태그';
  @override String get addOutfitNewTagSection => '새 태그';
  @override String get addOutfitTagInputHint => '태그 이름';
  @override String get addOutfitAddTagBtn => '추가';
  @override String get addOutfitDescSection => '메모';
  @override String get addOutfitDescHint => '코디를 설명해봐요...';
  @override String get addOutfitSaveBtn => '오늘 코디 저장';
  @override String get addOutfitSaveEditBtn => '변경 저장';
  @override String get addOutfitFromGallery => '갤러리에서 선택';
  @override String get addOutfitTakePhotoOption => '사진 촬영';
  @override String errLoadData(String e) => '데이터 로드 실패: $e';
  @override String errLoadTags(String e) => '태그 로드 실패: $e';
  @override String warnImageLimit(int max) => '최대 $max장 선택 가능';
  @override String warnImageLimitExceeded(int max, int kept) => '최대 $max장, 처음 $kept장 유지';
  @override String errSelectImage(String e) => '이미지 선택 실패: $e';
  @override String errTakePhoto(String e) => '촬영 실패: $e';
  @override String get warnTagAlreadyExists => '태그가 이미 존재합니다';
  @override String get warnSelectAtLeastOneImage => '사진을 1장 이상 선택해주세요';
  @override String get warnEnterDescription => '설명을 입력해주세요';
  @override String get successOutfitSaved => '저장되었습니다';
  @override String errSaveOutfit(String e) => '저장 실패: $e';

  @override String get statsPageTitle => '통계';
  @override String get statsRefreshTooltip => '새로고침';
  @override String get statsTotal => '총계';
  @override String get statsMonthly => '이번달';
  @override String get statsWeekly => '이번주';
  @override String get statsTip => '팁';
  @override String get statsKeepRecording => '계속 기록해요';
  @override String get statsTagFrequency => '태그 사용 빈도';
  @override String get statsMonthlyTrend => '월별 트렌드';
  @override String get statsNoTagData => '태그 데이터 없음';
  @override String get statsRecordedDaysLabel => '기록된 날짜';
  @override String get statsLast7Days => '최근 7일';
  @override String get statsInspirationTitle => '이번 달 스타일';

  @override String get editOutfitTooltip => '수정';

  @override String get themeModeLight => '라이트';
  @override String get themeModeAuto => '자동';
  @override String get themeModeDark => '다크';
  @override String get appearanceTitle => '외관';
  @override String get appearanceDisplayMode => '디스플레이 모드';
  @override String get appearanceColorPalette => '색상 팔레트';
  @override String get presetDescSoftWardrobe => '부드럽고 따뜻한 · 기본';
  @override String get presetDescMatcha => '상쾌하고 자연스러운 · 일상';
  @override String get presetDescCityBlue => '세련된 현대적 · 도시';
  @override String get presetDescRose => '로즈 에디토리얼 · 우아한';
  @override String get presetDescNightGallery => '야간 갤러리 · 몰입';
  @override String get themeModeNameSystem => '시스템';
  @override String get themeModeNameLight => '라이트 모드';
  @override String get themeModeNameDark => '다크 모드';
}
