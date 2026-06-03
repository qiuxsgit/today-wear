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
}
