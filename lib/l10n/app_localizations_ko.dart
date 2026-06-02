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

  @override
  String get navCalendar => '캘린더';

  @override
  String get navAdd => '기록';

  @override
  String get navStats => '통계';

  @override
  String get homeAppTitle => '오늘의 코디';

  @override
  String homeDateLabel(String weekday, int month, int day) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      '1': '월',
      '2': '화',
      '3': '수',
      '4': '목',
      '5': '금',
      '6': '토',
      '7': '일',
      'other': '',
    });
    return '$_temp0요일 · $month월 $day일';
  }

  @override
  String get filterAll => '전체';

  @override
  String get filterCommute => '출퇴근';

  @override
  String get filterDate => '데이트';

  @override
  String get filterRainy => '비 오는 날';

  @override
  String get filterCasual => '캐주얼';

  @override
  String get addOutfitTitle => '코디 추가';

  @override
  String get addOutfitHeroEyebrow => '오늘의 코디';

  @override
  String get addOutfitHeroText => '나만의 스타일을 기록하세요';

  @override
  String get addOutfitPhotosSection => '사진';

  @override
  String get addOutfitDragHint => '드래그하여 순서 변경';

  @override
  String get addOutfitAddPhotoBtn => '사진 추가';

  @override
  String get addOutfitFromGallery => '갤러리에서 선택';

  @override
  String get addOutfitTakePhotoOption => '사진 촬영';

  @override
  String get addOutfitTagsSection => '태그';

  @override
  String get addOutfitNoTagsHint => '태그가 없습니다';

  @override
  String get addOutfitSelectedTagsLabel => '선택한 태그';

  @override
  String get addOutfitNewTagSection => '새 태그';

  @override
  String get addOutfitTagInputHint => '태그 이름 입력';

  @override
  String get addOutfitAddTagBtn => '추가';

  @override
  String get addOutfitDescSection => '메모';

  @override
  String get addOutfitDescHint => '오늘의 코디를 설명해 주세요...';

  @override
  String get addOutfitSaveBtn => '코디 저장';

  @override
  String get addOutfitSaveEditBtn => '변경 저장';

  @override
  String get warnTagAlreadyExists => '이미 존재하는 태그입니다';

  @override
  String get warnSelectAtLeastOneImage => '사진을 한 장 이상 선택해 주세요';

  @override
  String get warnEnterDescription => '설명을 입력해 주세요';

  @override
  String warnImageLimit(int maxImages) {
    return '사진은 최대 $maxImages장까지';
  }

  @override
  String warnImageLimitExceeded(int maxImages, int remainingSlots) {
    return '최대 $maxImages장, $remainingSlots장 더 추가 가능';
  }

  @override
  String get successOutfitSaved => '코디가 저장되었습니다';

  @override
  String errLoadData(String error) {
    return '로드 실패：$error';
  }

  @override
  String errLoadTags(String error) {
    return '태그 로드 실패：$error';
  }

  @override
  String errSelectImage(String error) {
    return '사진 선택 실패：$error';
  }

  @override
  String errTakePhoto(String error) {
    return '촬영 실패：$error';
  }

  @override
  String errSaveOutfit(String error) {
    return '저장 실패：$error';
  }

  @override
  String get calendarWardrobeReview => '옷장 리뷰';

  @override
  String calendarMonthTitle(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': '1월',
      '2': '2월',
      '3': '3월',
      '4': '4월',
      '5': '5월',
      '6': '6월',
      '7': '7월',
      '8': '8월',
      '9': '9월',
      '10': '10월',
      '11': '11월',
      '12': '12월',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String calendarMonthName(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': '1월',
      '2': '2월',
      '3': '3월',
      '4': '4월',
      '5': '5월',
      '6': '6월',
      '7': '7월',
      '8': '8월',
      '9': '9월',
      '10': '10월',
      '11': '11월',
      '12': '12월',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get calendarRecordedDays => '기록한 날수';

  @override
  String get calendarUniqueTags => '태그 종류';

  @override
  String get calendarTopOutfits => '인기 코디';

  @override
  String calendarTagUsedCount(int count) {
    return '$count회 사용';
  }

  @override
  String calendarDaySheetTitle(int month, int day) {
    return '$month월 $day일';
  }

  @override
  String get calendarNoDayOutfits => '이 날의 코디 기록이 없습니다';

  @override
  String get statsPageTitle => '통계';

  @override
  String get statsMonthly => '이번 달';

  @override
  String get statsRecordedDaysLabel => '기록 일수';

  @override
  String get statsLast7Days => '최근 7일';

  @override
  String get statsTotal => '누계';

  @override
  String get statsTagFrequency => '태그 빈도';

  @override
  String get statsInspirationTitle => '스타일 영감';

  @override
  String get editOutfitTooltip => '편집';

  @override
  String get appearanceTitle => '외관';

  @override
  String get appearanceDisplayMode => '표시 모드';

  @override
  String get appearanceColorPalette => '색상 테마';

  @override
  String get presetDescSoftWardrobe => '소프트 워드로브';

  @override
  String get presetDescMatcha => '말차';

  @override
  String get presetDescCityBlue => '시티 블루';

  @override
  String get presetDescRose => '로즈';

  @override
  String get presetDescNightGallery => '나이트 갤러리';

  @override
  String get themeModeLight => '라이트';

  @override
  String get themeModeAuto => '자동';

  @override
  String get themeModeDark => '다크';
}
