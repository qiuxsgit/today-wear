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
  String get profile => '프로필';

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
  String get appVersion => '0.0.1';

  @override
  String get privacyPolicy => '개인정보 보호정책';

  @override
  String get termsOfService => '이용약관';

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
  String get tagAdd => '태그 추가';

  @override
  String get tagDeleteConfirm => '이 태그를 삭제하시겠습니까?';

  @override
  String get verConflictTitle => '데이터 충돌';

  @override
  String get verConflictMessage =>
      '이 기록이 다른 기기에서 업데이트되어 이 기기의 동기화되지 않은 변경 사항과 충돌합니다. 어느 버전을 유지하시겠습니까?';

  @override
  String get verKeepLocal => '이 기기 유지';

  @override
  String get verUseCloud => '클라우드 사용';

  @override
  String get verRemoteDeletedTitle => '클라우드에서 삭제됨';

  @override
  String get verRemoteDeletedMessage => '이 기록은 다른 기기에서 삭제되었습니다.';

  @override
  String get verRestore => '복원';

  @override
  String get verAcceptDelete => '삭제 수락';

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
  String get selectBirthday => '생일 선택';

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
  String get addOutfitTitle => '코디 추가';

  @override
  String get editOutfitTitle => '코디 편집';

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

  @override
  String get weatherPlaceholderLocation => '서울 · 맑음';

  @override
  String get weatherPlaceholderAdvice => '가벼운 재킷이 딱 좋아요';

  @override
  String get weatherPermissionDenied => '위치 서비스를 켜고 날씨를 확인하세요';

  @override
  String get weatherFetchFailed => '날씨를 가져오지 못했습니다. 탭하여 다시 시도';

  @override
  String get reminderTitle => '매일 알림';

  @override
  String reminderEnabledCount(Object count) {
    return '$count개 켜짐';
  }

  @override
  String get reminderEmptyMessage => '알림을 설정하여 매일의 코디를 잊지 않고 기록하세요';

  @override
  String get reminderAddBtn => '알림 추가';

  @override
  String get reminderTimeLabel => '시간';

  @override
  String get reminderWeekdaysLabel => '반복 요일';

  @override
  String get reminderWeekdaysEveryday => '매일';

  @override
  String get reminderSkipLabel => '오늘 이미 기록했으면 건너뛰기';

  @override
  String get reminderSkipHint => '오늘 이미 코디를 기록한 경우 알림이 전송되지 않습니다';

  @override
  String get reminderAddTitle => '새 알림';

  @override
  String get reminderEditTitle => '알림 편집';

  @override
  String get reminderDelete => '알림 삭제';

  @override
  String get reminderDeleteConfirm => '이 알림을 삭제하시겠습니까?';

  @override
  String get reminderSave => '저장';

  @override
  String get reminderDayMon => '월';

  @override
  String get reminderDayTue => '화';

  @override
  String get reminderDayWed => '수';

  @override
  String get reminderDayThu => '목';

  @override
  String get reminderDayFri => '금';

  @override
  String get reminderDaySat => '토';

  @override
  String get reminderDaySun => '일';

  @override
  String get reminderNotificationTitle => '오늘의 코디';

  @override
  String get reminderNotificationBody => '오늘의 코디를 기록하는 것을 잊지 마세요~';

  @override
  String get authLoginTitle => '로그인';

  @override
  String get authRegisterTitle => '계정 만들기';

  @override
  String get authLoginHeadline => '로그인하고 코디를 동기화하세요';

  @override
  String get authRegisterHeadline => '계정을 만들어 클라우드 동기화를 시작하세요';

  @override
  String get authOfflineNote =>
      '클라우드 동기화는 선택 기능입니다. 로그인하지 않아도 모든 기록 기능을 오프라인으로 사용할 수 있어요.';

  @override
  String get authEmailLabel => '이메일';

  @override
  String get authPasswordLabel => '비밀번호';

  @override
  String get authPasswordHint => '8자 이상';

  @override
  String get authEmailInvalid => '올바른 이메일 주소를 입력해 주세요';

  @override
  String get authPasswordTooShort => '비밀번호는 8자 이상이어야 합니다';

  @override
  String get authLoginSuccess => '로그인 완료';

  @override
  String get authRegisterSuccess => '가입 완료';

  @override
  String get authRegisterBtn => '가입하기';

  @override
  String get authSwitchToLogin => '이미 계정이 있나요? 로그인';

  @override
  String get authSwitchToRegister => '계정이 없나요? 가입하기';

  @override
  String get accountSyncTitle => '계정 및 클라우드 동기화';

  @override
  String get accountNotLoggedIn => '로그인 안 함';

  @override
  String get accountCloudOff => '클라우드 동기화가 꺼져 있어요';

  @override
  String get accountCloudIntro =>
      '로그인하면 코디·태그·프로필을 클라우드에 동기화하고 기기를 바꿔도 복원할 수 있어요.\n로그인하지 않아도 모든 로컬 기능을 사용할 수 있습니다.';

  @override
  String get accountRegisterNewBtn => '새 계정 만들기';

  @override
  String get accountLoggedIn => '로그인됨';

  @override
  String get accountDeviceManagement => '로그인 기기 관리';

  @override
  String get accountLogout => '로그아웃';

  @override
  String get accountLogoutDialogContent =>
      '로그아웃하면 클라우드 동기화가 중지되며 로컬 데이터는 유지됩니다. 로그아웃할까요?';

  @override
  String get accountLogoutConfirm => '로그아웃';

  @override
  String get accountLoggedOutToast => '로그아웃되었습니다';

  @override
  String get accountCloudSyncLabel => '클라우드 동기화';

  @override
  String get syncStatusSyncing => '동기화 중…';

  @override
  String get syncStatusNever => '아직 동기화하지 않았어요';

  @override
  String syncStatusLast(String time) {
    return '마지막 동기화 $time';
  }

  @override
  String get syncNowBtn => '지금 동기화';

  @override
  String get syncErrPremiumRequired => '클라우드 동기화는 프리미엄 구독이 필요합니다';

  @override
  String get syncErrGeneric => '동기화에 실패했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get deviceSessionsTitle => '로그인 기기';

  @override
  String get deviceSessionsEmpty => '활성 세션이 없습니다';

  @override
  String get deviceRemoved => '기기를 제거했습니다';

  @override
  String get deviceRemoveTooltip => '기기 제거';

  @override
  String get deviceCurrentBadge => '현재 기기';

  @override
  String get retry => '다시 시도';

  @override
  String get errNetwork => '네트워크 연결에 실패했습니다. 네트워크를 확인한 후 다시 시도해 주세요';

  @override
  String get errRequestTimeout => '요청 시간이 초과되었습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get errSessionExpired => '로그인이 만료되었습니다. 다시 로그인해 주세요';

  @override
  String get errPremiumRequired => '이 기능은 프리미엄이 필요합니다';

  @override
  String get errGeneric => '작업에 실패했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get errLoadFailed => '불러오기에 실패했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get errUploadFailed => '이미지 업로드에 실패했습니다. 네트워크를 확인해 주세요';

  @override
  String get proTitle => '오늘의 코디 Pro';

  @override
  String get proIntro => '클라우드 동기화 해제: 코디·태그·프로필을 여러 기기에 백업하세요.';

  @override
  String get proSubscribeBtn => 'Pro 업그레이드';

  @override
  String get proRestoreBtn => '구매 복원';

  @override
  String get proActiveBadge => '활성';

  @override
  String proExpiresAt(String date) {
    return '$date 만료';
  }

  @override
  String get proLifetime => '평생 이용권';

  @override
  String get proManageBtn => '구독 관리';

  @override
  String get proPurchaseSuccess => 'Pro가 활성화되었습니다';

  @override
  String get proRestoreSuccess => '구매를 복원했습니다';

  @override
  String get proNothingToRestore => '복원할 구매가 없습니다';

  @override
  String get proPurchaseFailed => '구매에 실패했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get proAlreadyActive => '이미 Pro 회원입니다';

  @override
  String get proSyncPending => '구매 완료, 적용 중…';

  @override
  String get proUnsupportedPlatform => 'iPhone 또는 Android 기기에서 구매해 주세요';

  @override
  String get proLoginFirst => 'Pro 구매는 로그인이 필요합니다';

  @override
  String get proMonthlyLabel => '월간 구독';

  @override
  String get proYearlyLabel => '연간 구독';

  @override
  String get proLifetimeLabel => '평생 소장';

  @override
  String get proPaywallLoadFailed => '상품을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get proPaymentPending => '결제 확인 중입니다. 완료되면 자동으로 적용됩니다';

  @override
  String get proSubscriptionNote =>
      '구독은 자동 갱신되며 스토어의 구독 설정에서 언제든지 해지할 수 있습니다. 평생 소장은 1회 결제입니다.';

  @override
  String get proPurchaseCta => '계속하기';

  @override
  String get logUpload => '로그 업로드';

  @override
  String get logUploadEmpty => '로그 파일이 없습니다';

  @override
  String get logUploadConfirmTitle => '로그 업로드';

  @override
  String get logUploadConfirmMessage => '문제 해결을 위해 이 로그 파일을 업로드합니다';

  @override
  String get logUploadRemarkHint => '겪은 문제를 설명해 주세요 (선택)';

  @override
  String get logUploadAction => '업로드';

  @override
  String get logUploadSuccess => '로그를 업로드했습니다';

  @override
  String get logUploadFailed => '로그 업로드에 실패했습니다';

  @override
  String get logUploadLoginRequired => '로그를 업로드하려면 먼저 로그인하세요';

  @override
  String get accountDelete => '계정 삭제';

  @override
  String get accountDeleteDialogTitle => '계정을 영구 삭제할까요?';

  @override
  String get accountDeleteDialogContent =>
      '클라우드 데이터(코디, 태그, 프로필, 이미지)가 영구 삭제됩니다. 이 기기의 로컬 데이터는 유지되며 앱은 계속 사용할 수 있습니다. 구독은 자동으로 해지되지 않으니 App Store / Google Play에서 관리해 주세요. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get accountDeletePasswordHint => '확인을 위해 비밀번호 입력';

  @override
  String get accountDeletePasswordRequired => '비밀번호를 입력해 주세요';

  @override
  String get accountDeleteConfirm => '영구 삭제';

  @override
  String get accountDeleteSuccess => '계정이 삭제되었습니다';

  @override
  String get alreadyLatestVersion => '이미 최신 버전입니다';

  @override
  String get newVersionFound => '새 버전이 있습니다';

  @override
  String get updateNow => '지금 업데이트';

  @override
  String get updateLater => '나중에';

  @override
  String get forceUpdateNotice => '현재 버전이 너무 오래되어 업데이트해야 계속 사용할 수 있습니다';

  @override
  String get updateDownloading => '업데이트 다운로드 중…';

  @override
  String get updateDownloadFailed => '다운로드에 실패했습니다. 나중에 다시 시도해 주세요';

  @override
  String get updateCheckFailed => '업데이트 확인에 실패했습니다. 나중에 다시 시도해 주세요';
}
