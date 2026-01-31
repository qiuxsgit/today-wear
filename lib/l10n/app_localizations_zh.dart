// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '今日穿什麼';

  @override
  String get home => '首页';

  @override
  String get add => '添加';

  @override
  String get profile => '个人';

  @override
  String get addOutfit => '添加穿搭';

  @override
  String get addOutfitPage => '添加穿搭页面\n（待实现）';

  @override
  String get profilePage => '个人页面\n（待实现）';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get dayBeforeYesterday => '前天';

  @override
  String dateFormat(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁体中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get nickname => '用户';

  @override
  String get version => '版本';

  @override
  String get appVersion => '1.0.0';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '使用条款';

  @override
  String get openSourceLicense => '开源许可';

  @override
  String get contact => '联系方式';

  @override
  String get about => '关于应用';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get deleteOutfitConfirm => '确定要删除这条穿搭记录吗？删除后无法恢复。';

  @override
  String get tagManagement => '标签管理';

  @override
  String get tagName => '标签名称';

  @override
  String get tagEdit => '编辑标签';

  @override
  String get tagDeleteConfirm => '确定要删除该标签吗？';

  @override
  String tagDeleteConfirmInUse(int count) {
    return '该标签已被 $count 条穿搭使用，删除将从这些穿搭中移除该标签。确定删除吗？';
  }

  @override
  String get tagNameEmpty => '请输入标签名称';

  @override
  String get tagNameDuplicate => '该标签名称已存在';

  @override
  String get tagSaved => '已保存';

  @override
  String get tagNoTags => '暂无标签';

  @override
  String get homeEmptyMessage => '还没有穿搭记录\n添加第一条穿搭，开始记录你的每日穿搭吧';

  @override
  String get homeAddFirstOutfit => '添加第一条穿搭';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get appTitle => '今日穿什麼';

  @override
  String get home => '首页';

  @override
  String get add => '添加';

  @override
  String get profile => '个人';

  @override
  String get addOutfit => '添加穿搭';

  @override
  String get addOutfitPage => '添加穿搭页面\n（待实现）';

  @override
  String get profilePage => '个人页面\n（待实现）';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get dayBeforeYesterday => '前天';

  @override
  String dateFormat(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁体中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get nickname => '用户';

  @override
  String get version => '版本';

  @override
  String get appVersion => '1.0.0';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '使用条款';

  @override
  String get openSourceLicense => '开源许可';

  @override
  String get contact => '联系方式';

  @override
  String get about => '关于应用';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get deleteOutfitConfirm => '确定要删除这条穿搭记录吗？删除后无法恢复。';

  @override
  String get tagManagement => '标签管理';

  @override
  String get tagName => '标签名称';

  @override
  String get tagEdit => '编辑标签';

  @override
  String get tagDeleteConfirm => '确定要删除该标签吗？';

  @override
  String tagDeleteConfirmInUse(int count) {
    return '该标签已被 $count 条穿搭使用，删除将从这些穿搭中移除该标签。确定删除吗？';
  }

  @override
  String get tagNameEmpty => '请输入标签名称';

  @override
  String get tagNameDuplicate => '该标签名称已存在';

  @override
  String get tagSaved => '已保存';

  @override
  String get tagNoTags => '暂无标签';

  @override
  String get homeEmptyMessage => '还没有穿搭记录\n添加第一条穿搭，开始记录你的每日穿搭吧';

  @override
  String get homeAddFirstOutfit => '添加第一条穿搭';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '今日穿什麼';

  @override
  String get home => '首頁';

  @override
  String get add => '添加';

  @override
  String get profile => '個人';

  @override
  String get addOutfit => '添加穿搭';

  @override
  String get addOutfitPage => '添加穿搭頁面\n（待實現）';

  @override
  String get profilePage => '個人頁面\n（待實現）';

  @override
  String get settings => '設定';

  @override
  String get language => '語言';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get dayBeforeYesterday => '前天';

  @override
  String dateFormat(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get simplifiedChinese => '簡體中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get nickname => '用戶';

  @override
  String get version => '版本';

  @override
  String get appVersion => '1.0.0';

  @override
  String get privacyPolicy => '隱私政策';

  @override
  String get termsOfService => '使用條款';

  @override
  String get openSourceLicense => '開源許可';

  @override
  String get contact => '聯絡方式';

  @override
  String get about => '關於應用';

  @override
  String get save => '保存';

  @override
  String get delete => '刪除';

  @override
  String get cancel => '取消';

  @override
  String get deleteOutfitConfirm => '確定要刪除這條穿搭記錄嗎？刪除後無法恢復。';

  @override
  String get tagManagement => '標籤管理';

  @override
  String get tagName => '標籤名稱';

  @override
  String get tagEdit => '編輯標籤';

  @override
  String get tagDeleteConfirm => '確定要刪除該標籤嗎？';

  @override
  String tagDeleteConfirmInUse(int count) {
    return '該標籤已被 $count 條穿搭使用，刪除將從這些穿搭中移除該標籤。確定刪除嗎？';
  }

  @override
  String get tagNameEmpty => '請輸入標籤名稱';

  @override
  String get tagNameDuplicate => '該標籤名稱已存在';

  @override
  String get tagSaved => '已保存';

  @override
  String get tagNoTags => '暫無標籤';

  @override
  String get homeEmptyMessage => '還沒有穿搭記錄\n添加第一條穿搭，開始記錄你的每日穿搭吧';

  @override
  String get homeAddFirstOutfit => '添加第一條穿搭';
}
