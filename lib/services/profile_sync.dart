import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/gfs_uploader.dart';
import '../api/media_api.dart';
import '../api/user_api.dart';
import '../models/user_profile.dart';
import 'image_service.dart';
import 'profile_service.dart';
import 'session_service.dart';

/// 个人资料云同步
///
/// - [push]：资料编辑保存后调用（已登录时），头像走 GFS 直传后整体替换远端资料。
/// - [pullToLocal]：登录成功后调用，把远端资料（含头像）拉回本地。
/// 平时的穿搭同步不会动资料，避免互相覆盖。
class ProfileSync {
  ProfileSync._();
  static final ProfileSync instance = ProfileSync._();

  static const String _kAvatarPath = 'profile_avatar_synced_path';
  static const String _kAvatarImageId = 'profile_avatar_image_id';

  final UserApi _userApi = UserApi();
  final MediaApi _mediaApi = MediaApi();
  final GfsUploader _uploader = GfsUploader.instance;
  final ImageService _images = ImageService.instance;
  final http.Client _http = http.Client();

  /// 推送本地资料到服务端。失败抛 ApiException，由调用方决定是否提示。
  Future<void> push(UserProfile profile) async {
    if (!SessionService.instance.isLoggedIn) return;

    int? avatarImageId;
    if (profile.avatarPath != null && profile.avatarPath!.isNotEmpty) {
      avatarImageId = await _ensureAvatarUploaded(profile.avatarPath!);
    }

    String? birthday;
    if (profile.birthday != null) {
      final d = profile.birthday!;
      birthday =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }

    await _userApi.updateProfile(
      nickname: profile.nickname,
      birthday: birthday,
      gender: profile.gender,
      personality: profile.personality,
      avatarImageId: avatarImageId,
    );
  }

  /// 登录后的资料调和：远端有资料则拉回本地；远端为空而本地有则推上去。
  Future<void> reconcileOnLogin() async {
    if (!SessionService.instance.isLoggedIn) return;
    final remote = await _userApi.getMe();
    final hasRemote = (remote.nickname?.isNotEmpty ?? false) ||
        remote.avatarImageId != null ||
        (remote.birthday?.isNotEmpty ?? false) ||
        (remote.gender?.isNotEmpty ?? false) ||
        (remote.personality?.isNotEmpty ?? false);

    if (hasRemote) {
      await pullToLocal(remote: remote);
      return;
    }
    final local = await ProfileService.load();
    final hasLocal = (local.nickname?.isNotEmpty ?? false) ||
        (local.avatarPath?.isNotEmpty ?? false) ||
        local.birthday != null ||
        (local.gender?.isNotEmpty ?? false) ||
        (local.personality?.isNotEmpty ?? false);
    if (hasLocal) await push(local);
  }

  /// 拉取远端资料覆盖本地（登录/换设备场景）。
  Future<void> pullToLocal({RemoteProfile? remote}) async {
    if (!SessionService.instance.isLoggedIn) return;
    remote ??= await _userApi.getMe();

    String? avatarPath;
    if (remote.avatarUrl != null && remote.avatarUrl!.isNotEmpty) {
      try {
        final res = await _http
            .get(Uri.parse(remote.avatarUrl!))
            .timeout(const Duration(seconds: 30));
        if (res.statusCode >= 200 && res.statusCode < 300) {
          avatarPath = await _images.saveProfileAvatarBytes(res.bodyBytes);
          if (remote.avatarImageId != null) {
            await _cacheAvatarId(avatarPath, remote.avatarImageId!);
          }
        }
      } catch (e) {
        debugPrint('ProfileSync avatar download failed: $e');
      }
    }

    DateTime? birthday;
    if (remote.birthday != null && remote.birthday!.isNotEmpty) {
      birthday = DateTime.tryParse(remote.birthday!);
    }

    await ProfileService.save(UserProfile(
      avatarPath: avatarPath,
      nickname: remote.nickname,
      birthday: birthday,
      gender: remote.gender,
      personality: remote.personality,
    ));
  }

  /// 头像上传去重：头像固定存于 profile/avatar.jpg（覆盖式），
  /// 故以「路径@文件修改时间」为键缓存已上传的 image id，内容变了才重传。
  Future<int?> _ensureAvatarUploaded(String avatarPath) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedKey = prefs.getString(_kAvatarPath);
    final cachedId = prefs.getInt(_kAvatarImageId);

    final file = await _images.getImageFile(avatarPath);
    if (file == null) return cachedId;

    final key = await _avatarKey(avatarPath);
    if (cachedKey == key && cachedId != null) return cachedId;

    final policy = await _mediaApi.uploadToken(usage: 'avatar');
    final id = await _uploader.upload(file, policy);
    await _cacheAvatarId(avatarPath, id);
    return id;
  }

  Future<String> _avatarKey(String path) async {
    int mtime = 0;
    try {
      final file = await _images.getImageFile(path);
      if (file != null) {
        mtime = (await file.lastModified()).millisecondsSinceEpoch;
      }
    } catch (_) {}
    return '$path@$mtime';
  }

  Future<void> _cacheAvatarId(String path, int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAvatarPath, await _avatarKey(path));
    await prefs.setInt(_kAvatarImageId, id);
  }
}
