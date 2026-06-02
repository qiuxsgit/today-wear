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
  String get add => 'Add';

  @override
  String get profile => 'Profile';

  @override
  String get addOutfit => 'Add Outfit';

  @override
  String get addOutfitPage => 'Add Outfit Page\n(Coming Soon)';

  @override
  String get profilePage => 'Profile Page\n(Coming Soon)';

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
  String get openSourceLicense => 'Open Source License';

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
  String get hintAvatarEmoji => 'Choose an emoji for avatar';

  @override
  String get selectBirthday => 'Select birthday';

  @override
  String get avatar => 'Avatar';

  @override
  String get avatarSelectHint => 'Tap to select photo';

  @override
  String get nicknameField => 'Nickname';

  @override String get navCalendar => 'Calendar';
  @override String get navAdd => 'Add';
  @override String get navStats => 'Stats';

  @override String get homeAppTitle => "Today's Outfit";
  @override String homeDateLabel(int weekday, int month, int day) {
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${days[weekday - 1]}, ${months[month - 1]} $day';
  }
  @override String get filterAll => 'All';
  @override String get filterCommute => 'Commute';
  @override String get filterDate => 'Date';
  @override String get filterRainy => 'Rainy';
  @override String get filterCasual => 'Casual';

  @override String calendarMonthName(int month) {
    const names = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return names[month - 1];
  }
  @override String get calendarWardrobeReview => 'Wardrobe review';
  @override String calendarMonthTitle(int month) => '${calendarMonthName(month)} Review';
  @override String get calendarRecordedDays => 'Recorded Days';
  @override String get calendarUniqueTags => 'Tags Used';
  @override String get calendarTopOutfits => 'Most Worn';
  @override String calendarTagUsedCount(int count) => 'Worn $count time${count == 1 ? '' : 's'}';
  @override String calendarDaySheetTitle(int month, int day) => '$month/$day Outfits';
  @override String get calendarNoDayOutfits => 'No outfits recorded for this day';

  @override String get addOutfitTitle => 'New Outfit';
  @override String get addOutfitHeroEyebrow => "Today's look";
  @override String get addOutfitHeroText => 'Photos first,\nthen add some notes';
  @override String get addOutfitPhotosSection => 'Photos';
  @override String get addOutfitDragHint => 'Long press to reorder';
  @override String get addOutfitAddPhotoBtn => 'Add Photo';
  @override String get addOutfitTagsSection => 'Tags';
  @override String get addOutfitNoTagsHint => 'No tags available';
  @override String get addOutfitSelectedTagsLabel => 'Selected Tags';
  @override String get addOutfitNewTagSection => 'New Tag';
  @override String get addOutfitTagInputHint => 'Tag name';
  @override String get addOutfitAddTagBtn => 'Add';
  @override String get addOutfitDescSection => 'Notes';
  @override String get addOutfitDescHint => 'Describe your outfit...';
  @override String get addOutfitSaveBtn => "Save Today's Outfit";
  @override String get addOutfitSaveEditBtn => 'Save Changes';
  @override String get addOutfitFromGallery => 'From Gallery';
  @override String get addOutfitTakePhotoOption => 'Take Photo';
  @override String errLoadData(String e) => 'Failed to load data: $e';
  @override String errLoadTags(String e) => 'Failed to load tags: $e';
  @override String warnImageLimit(int max) => 'Max $max photos allowed';
  @override String warnImageLimitExceeded(int max, int kept) => 'Max $max photos, kept first $kept';
  @override String errSelectImage(String e) => 'Failed to select image: $e';
  @override String errTakePhoto(String e) => 'Failed to take photo: $e';
  @override String get warnTagAlreadyExists => 'Tag already exists';
  @override String get warnSelectAtLeastOneImage => 'Please select at least one photo';
  @override String get warnEnterDescription => 'Please enter a description';
  @override String get successOutfitSaved => 'Saved successfully';
  @override String errSaveOutfit(String e) => 'Failed to save: $e';

  @override String get statsPageTitle => 'Stats';
  @override String get statsRefreshTooltip => 'Refresh';
  @override String get statsTotal => 'Total';
  @override String get statsMonthly => 'This Month';
  @override String get statsWeekly => 'This Week';
  @override String get statsTip => 'Tip';
  @override String get statsKeepRecording => 'Keep it up!';
  @override String get statsTagFrequency => 'Tag Frequency';
  @override String get statsMonthlyTrend => 'Monthly Trend';
  @override String get statsNoTagData => 'No tag data';
  @override String get statsRecordedDaysLabel => 'Recorded Days';
  @override String get statsLast7Days => 'Last 7 Days';
  @override String get statsInspirationTitle => 'Monthly Inspiration';

  @override String get editOutfitTooltip => 'Edit';

  @override String get themeModeLight => 'Light';
  @override String get themeModeAuto => 'Auto';
  @override String get themeModeDark => 'Dark';
  @override String get appearanceTitle => 'Appearance';
  @override String get appearanceDisplayMode => 'Display Mode';
  @override String get appearanceColorPalette => 'Color Palette';
  @override String get presetDescSoftWardrobe => 'Soft & warm · Default';
  @override String get presetDescMatcha => 'Fresh & natural · Daily';
  @override String get presetDescCityBlue => 'Clean & modern · Urban';
  @override String get presetDescRose => 'Rose editorial · Elegant';
  @override String get presetDescNightGallery => 'Night gallery · Immersive';
  @override String get themeModeNameSystem => 'System';
  @override String get themeModeNameLight => 'Light Mode';
  @override String get themeModeNameDark => 'Dark Mode';
}
