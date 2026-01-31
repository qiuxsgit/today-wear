/// 用户资料模型
///
/// 所有字段均为可选，用于个人资料维护与展示
class UserProfile {
  const UserProfile({
    this.avatarPath,
    this.nickname,
    this.birthday,
    this.gender,
    this.personality,
  });

  /// 头像图片相对路径（如 profile/avatar.jpg），为空时使用默认占位
  final String? avatarPath;

  /// 昵称
  final String? nickname;

  /// 生日
  final DateTime? birthday;

  /// 性别：male / female / none（暂不选择）
  final String? gender;

  /// 性格描述（长文本）
  final String? personality;

  UserProfile copyWith({
    String? avatarPath,
    String? nickname,
    DateTime? birthday,
    String? gender,
    String? personality,
  }) {
    return UserProfile(
      avatarPath: avatarPath ?? this.avatarPath,
      nickname: nickname ?? this.nickname,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      personality: personality ?? this.personality,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatarPath': avatarPath,
      'nickname': nickname,
      'birthday': birthday?.toIso8601String(),
      'gender': gender,
      'personality': personality,
    };
  }

  static UserProfile fromJson(Map<String, dynamic> json) {
    DateTime? birthday;
    final birthdayStr = json['birthday'] as String?;
    if (birthdayStr != null) {
      birthday = DateTime.tryParse(birthdayStr);
    }
    return UserProfile(
      avatarPath: json['avatarPath'] as String?,
      nickname: json['nickname'] as String?,
      birthday: birthday,
      gender: json['gender'] as String?,
      personality: json['personality'] as String?,
    );
  }
}
