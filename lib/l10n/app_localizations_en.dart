// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Today Wear';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get dayBeforeYesterday => 'Day Before Yesterday';

  @override
  String dateFormat(int month, int day) {
    return '$month/$day';
  }

  @override
  String get simplifiedChinese => 'Simplified Chinese';

  @override
  String get traditionalChinese => 'Traditional Chinese';

  @override
  String get english => 'English';

  @override
  String get japanese => 'Japanese';

  @override
  String get korean => 'Korean';

  @override
  String get nickname => 'User';

  @override
  String get version => 'Version';

  @override
  String get appVersion => '1.0.0';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get contact => 'Contact';

  @override
  String get about => 'About';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteOutfitConfirm =>
      'Are you sure you want to delete this outfit? This cannot be undone.';

  @override
  String get tagManagement => 'Tag Management';

  @override
  String get tagName => 'Tag Name';

  @override
  String get tagColor => 'Tag Color';

  @override
  String get tagEdit => 'Edit Tag';

  @override
  String get tagDeleteConfirm => 'Are you sure you want to delete this tag?';

  @override
  String tagDeleteConfirmInUse(int count) {
    return 'This tag is used by $count outfit(s). Deleting will remove it from those outfits. Continue?';
  }

  @override
  String get tagNameEmpty => 'Please enter a tag name';

  @override
  String get tagNameDuplicate => 'This tag name already exists';

  @override
  String get tagSaved => 'Saved';

  @override
  String get tagNoTags => 'No tags yet';

  @override
  String tagManagementWithCount(int count) {
    return 'Tag Management ($count total)';
  }

  @override
  String get homeEmptyMessage =>
      'No outfit records yet.\nAdd your first outfit to start recording your daily looks.';

  @override
  String get homeAddFirstOutfit => 'Add First Outfit';

  @override
  String get contactQQ => 'QQ';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactEmailCopyHint =>
      'Cannot open email app. Please copy the email address manually.';

  @override
  String get copiedToClipboard => 'Copied';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get birthday => 'Birthday';

  @override
  String get gender => 'Gender';

  @override
  String get personality => 'Personality';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get genderNotSpecified => 'Prefer not to say';

  @override
  String get profileSaved => 'Saved';

  @override
  String get hintNickname => 'Enter nickname';

  @override
  String get hintPersonality => 'Tell us about your personality～';

  @override
  String get selectBirthday => 'Select birthday';

  @override
  String get nicknameField => 'Nickname';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navAdd => 'Record';

  @override
  String get navStats => 'Stats';

  @override
  String get homeAppTitle => 'Today Wear';

  @override
  String homeDateLabel(String weekday, int month, int day) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      '1': 'Mon',
      '2': 'Tue',
      '3': 'Wed',
      '4': 'Thu',
      '5': 'Fri',
      '6': 'Sat',
      '7': 'Sun',
      'other': '',
    });
    return '$_temp0 · $month/$day';
  }

  @override
  String get filterAll => 'All';

  @override
  String get addOutfitTitle => 'New Outfit';

  @override
  String get editOutfitTitle => 'Edit Outfit';

  @override
  String get addOutfitHeroEyebrow => 'Today\'s Look';

  @override
  String get addOutfitHeroText => 'Record your outfit';

  @override
  String get addOutfitPhotosSection => 'Photos';

  @override
  String get addOutfitDragHint => 'Drag to reorder';

  @override
  String get addOutfitAddPhotoBtn => 'Add Photo';

  @override
  String get addOutfitFromGallery => 'Choose from Gallery';

  @override
  String get addOutfitTakePhotoOption => 'Take Photo';

  @override
  String get addOutfitTagsSection => 'Tags';

  @override
  String get addOutfitNoTagsHint => 'No tags yet';

  @override
  String get addOutfitSelectedTagsLabel => 'Selected Tags';

  @override
  String get addOutfitNewTagSection => 'New Tag';

  @override
  String get addOutfitTagInputHint => 'Enter tag name';

  @override
  String get addOutfitAddTagBtn => 'Add';

  @override
  String get addOutfitDescSection => 'Notes';

  @override
  String get addOutfitDescHint => 'Describe today\'s outfit...';

  @override
  String get addOutfitSaveBtn => 'Save Outfit';

  @override
  String get addOutfitSaveEditBtn => 'Save Changes';

  @override
  String get warnTagAlreadyExists => 'Tag already exists';

  @override
  String get warnSelectAtLeastOneImage => 'Please add at least one photo';

  @override
  String get warnEnterDescription => 'Please enter a description';

  @override
  String warnImageLimit(int maxImages) {
    return 'Maximum $maxImages photos allowed';
  }

  @override
  String warnImageLimitExceeded(int maxImages, int remainingSlots) {
    return 'Max $maxImages photos, $remainingSlots remaining';
  }

  @override
  String get successOutfitSaved => 'Outfit saved';

  @override
  String errLoadData(String error) {
    return 'Failed to load: $error';
  }

  @override
  String errLoadTags(String error) {
    return 'Failed to load tags: $error';
  }

  @override
  String errSelectImage(String error) {
    return 'Failed to select photo: $error';
  }

  @override
  String errTakePhoto(String error) {
    return 'Failed to take photo: $error';
  }

  @override
  String errSaveOutfit(String error) {
    return 'Failed to save outfit: $error';
  }

  @override
  String get calendarWardrobeReview => 'Wardrobe Review';

  @override
  String calendarMonthTitle(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': 'January',
      '2': 'February',
      '3': 'March',
      '4': 'April',
      '5': 'May',
      '6': 'June',
      '7': 'July',
      '8': 'August',
      '9': 'September',
      '10': 'October',
      '11': 'November',
      '12': 'December',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String calendarMonthName(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': 'January',
      '2': 'February',
      '3': 'March',
      '4': 'April',
      '5': 'May',
      '6': 'June',
      '7': 'July',
      '8': 'August',
      '9': 'September',
      '10': 'October',
      '11': 'November',
      '12': 'December',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get calendarRecordedDays => 'Days Recorded';

  @override
  String get calendarUniqueTags => 'Unique Tags';

  @override
  String get calendarTopOutfits => 'Top Outfits';

  @override
  String calendarTagUsedCount(int count) {
    return 'Used $count times';
  }

  @override
  String calendarDaySheetTitle(int month, int day) {
    return '$month/$day';
  }

  @override
  String get calendarNoDayOutfits => 'No outfits on this day';

  @override
  String get statsPageTitle => 'Statistics';

  @override
  String get statsMonthly => 'This Month';

  @override
  String get statsRecordedDaysLabel => 'Days Recorded';

  @override
  String get statsLast7Days => 'Last 7 Days';

  @override
  String get statsTotal => 'All Time';

  @override
  String get statsTagFrequency => 'Tag Frequency';

  @override
  String get statsInspirationTitle => 'Style Inspiration';

  @override
  String get editOutfitTooltip => 'Edit';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceDisplayMode => 'Display Mode';

  @override
  String get appearanceColorPalette => 'Color Palette';

  @override
  String get presetDescSoftWardrobe => 'Soft Wardrobe';

  @override
  String get presetDescMatcha => 'Matcha';

  @override
  String get presetDescCityBlue => 'City Blue';

  @override
  String get presetDescRose => 'Rose';

  @override
  String get presetDescNightGallery => 'Night Gallery';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeAuto => 'Auto';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get weatherPlaceholderLocation => 'City · Sunny';

  @override
  String get weatherPlaceholderAdvice => 'A light jacket works great';

  @override
  String get reminderTitle => 'Daily Reminder';

  @override
  String reminderEnabledCount(Object count) {
    return '$count enabled';
  }

  @override
  String get reminderEmptyMessage =>
      'Set a reminder to never miss recording your outfit';

  @override
  String get reminderAddBtn => 'Add Reminder';

  @override
  String get reminderTimeLabel => 'Time';

  @override
  String get reminderWeekdaysLabel => 'Repeat Days';

  @override
  String get reminderWeekdaysEveryday => 'Everyday';

  @override
  String get reminderSkipLabel => 'Skip if already recorded today';

  @override
  String get reminderSkipHint => 'No notification if already recorded today';

  @override
  String get reminderAddTitle => 'New Reminder';

  @override
  String get reminderEditTitle => 'Edit Reminder';

  @override
  String get reminderDelete => 'Delete Reminder';

  @override
  String get reminderDeleteConfirm => 'Delete this reminder?';

  @override
  String get reminderSave => 'Save';

  @override
  String get reminderDayMon => 'Mon';

  @override
  String get reminderDayTue => 'Tue';

  @override
  String get reminderDayWed => 'Wed';

  @override
  String get reminderDayThu => 'Thu';

  @override
  String get reminderDayFri => 'Fri';

  @override
  String get reminderDaySat => 'Sat';

  @override
  String get reminderDaySun => 'Sun';

  @override
  String get reminderNotificationTitle => 'Today\'s Outfit';

  @override
  String get reminderNotificationBody =>
      'Don\'t forget to record your outfit today~';

  @override
  String get authLoginTitle => 'Log In';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authLoginHeadline => 'Log in to sync your outfits';

  @override
  String get authRegisterHeadline => 'Create an account to enable cloud sync';

  @override
  String get authOfflineNote =>
      'Cloud sync is optional — all recording features work offline without an account.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'At least 8 characters';

  @override
  String get authEmailInvalid => 'Please enter a valid email address';

  @override
  String get authPasswordTooShort => 'Password must be at least 8 characters';

  @override
  String get authLoginSuccess => 'Logged in';

  @override
  String get authRegisterSuccess => 'Account created';

  @override
  String get authRegisterBtn => 'Sign Up';

  @override
  String get authSwitchToLogin => 'Already have an account? Log in';

  @override
  String get authSwitchToRegister => 'No account yet? Sign up';

  @override
  String get accountSyncTitle => 'Account & Cloud Sync';

  @override
  String get accountNotLoggedIn => 'Not logged in';

  @override
  String get accountCloudOff => 'Cloud sync is off';

  @override
  String get accountCloudIntro =>
      'Log in to sync outfits, tags and profile to the cloud, and restore them on a new device.\nEverything still works locally without an account.';

  @override
  String get accountRegisterNewBtn => 'Create New Account';

  @override
  String get accountLoggedIn => 'Logged in';

  @override
  String get accountDeviceManagement => 'Manage Devices';

  @override
  String get accountLogout => 'Log Out';

  @override
  String get accountLogoutDialogContent =>
      'Cloud sync will stop after logging out; local data is kept. Log out?';

  @override
  String get accountLogoutConfirm => 'Log Out';

  @override
  String get accountLoggedOutToast => 'Logged out';

  @override
  String get accountCloudSyncLabel => 'Cloud Sync';

  @override
  String get syncStatusSyncing => 'Syncing…';

  @override
  String get syncStatusNever => 'Not synced yet';

  @override
  String syncStatusLast(String time) {
    return 'Last synced $time';
  }

  @override
  String get syncNowBtn => 'Sync Now';

  @override
  String get syncErrPremiumRequired =>
      'Cloud sync requires a premium subscription';

  @override
  String get syncErrGeneric => 'Sync failed, please try again later';

  @override
  String get deviceSessionsTitle => 'Devices';

  @override
  String get deviceSessionsEmpty => 'No active sessions';

  @override
  String get deviceRemoved => 'Device removed';

  @override
  String get deviceRemoveTooltip => 'Remove this device';

  @override
  String get deviceCurrentBadge => 'This device';

  @override
  String get retry => 'Retry';

  @override
  String get errNetwork =>
      'Network error, please check your connection and try again';

  @override
  String get errRequestTimeout => 'Request timed out, please try again later';

  @override
  String get errSessionExpired => 'Session expired, please log in again';

  @override
  String get errPremiumRequired => 'This feature requires premium';

  @override
  String get errGeneric => 'Operation failed, please try again later';

  @override
  String get errLoadFailed => 'Failed to load, please try again later';

  @override
  String get errUploadFailed =>
      'Image upload failed, please check your network';

  @override
  String get proTitle => 'Today Wear Pro';

  @override
  String get proIntro =>
      'Unlock cloud sync: back up outfits, tags and profile across devices.';

  @override
  String get proSubscribeBtn => 'Upgrade to Pro';

  @override
  String get proRestoreBtn => 'Restore Purchases';

  @override
  String get proActiveBadge => 'Active';

  @override
  String proExpiresAt(String date) {
    return 'Expires $date';
  }

  @override
  String get proLifetime => 'Lifetime';

  @override
  String get proManageBtn => 'Manage Subscription';

  @override
  String get proPurchaseSuccess => 'Pro activated';

  @override
  String get proRestoreSuccess => 'Purchases restored';

  @override
  String get proNothingToRestore => 'No purchases to restore';

  @override
  String get proPurchaseFailed => 'Purchase failed, please try again later';

  @override
  String get proAlreadyActive => 'You already have Pro';

  @override
  String get proSyncPending => 'Purchased — activating…';

  @override
  String get proUnsupportedPlatform =>
      'Please purchase on your iPhone or Android device';

  @override
  String get proLoginFirst => 'Please log in before upgrading to Pro';

  @override
  String get proMonthlyLabel => 'Monthly';

  @override
  String get proYearlyLabel => 'Yearly';

  @override
  String get proLifetimeLabel => 'Lifetime';

  @override
  String get proPaywallLoadFailed =>
      'Couldn\'t load products, please try again later';

  @override
  String get proPaymentPending =>
      'Payment pending — Pro activates once it completes';

  @override
  String get proSubscriptionNote =>
      'Subscriptions auto-renew and can be cancelled anytime in your store\'s subscription settings; Lifetime is a one-time purchase.';

  @override
  String get proPurchaseCta => 'Continue';

  @override
  String get logUpload => 'Log Upload';

  @override
  String get logUploadEmpty => 'No log files yet';

  @override
  String get logUploadConfirmTitle => 'Upload Log';

  @override
  String get logUploadConfirmMessage =>
      'This log file will be uploaded for troubleshooting';

  @override
  String get logUploadRemarkHint => 'Describe the problem (optional)';

  @override
  String get logUploadAction => 'Upload';

  @override
  String get logUploadSuccess => 'Log uploaded';

  @override
  String get logUploadFailed => 'Log upload failed';

  @override
  String get logUploadLoginRequired => 'Please sign in before uploading logs';

  @override
  String get accountDelete => 'Delete Account';

  @override
  String get accountDeleteDialogTitle => 'Delete account permanently?';

  @override
  String get accountDeleteDialogContent =>
      'All cloud data (outfits, tags, profile, images) will be permanently deleted. Local data on this device is kept and the app remains fully usable. Subscriptions are not cancelled automatically — manage them in the App Store / Google Play. This cannot be undone.';

  @override
  String get accountDeletePasswordHint => 'Enter password to confirm';

  @override
  String get accountDeletePasswordRequired => 'Please enter your password';

  @override
  String get accountDeleteConfirm => 'Delete Permanently';

  @override
  String get accountDeleteSuccess => 'Account deleted';

  @override
  String get checkUpdate => 'Check for Updates';

  @override
  String get alreadyLatestVersion => 'You\'re on the latest version';

  @override
  String get newVersionFound => 'New Version Available';

  @override
  String get updateNow => 'Update Now';

  @override
  String get updateLater => 'Not Now';

  @override
  String get forceUpdateNotice =>
      'This version is too old. Please update to continue.';

  @override
  String get updateDownloading => 'Downloading update…';

  @override
  String get updateDownloadFailed => 'Download failed. Please try again later.';

  @override
  String get updateCheckFailed =>
      'Update check failed. Please try again later.';
}
