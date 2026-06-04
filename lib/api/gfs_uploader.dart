import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';
import 'media_api.dart';

/// GFS 图片直传客户端
///
/// 契约：`POST {gfsHost}/v1/upload`，multipart/form-data：
///   file + appId/policy/signature/timestamp/nonce/expire（来自 [UploadPolicy]）。
/// 响应（2026-06 联调确认）：
///   { "code": 0, "msg": "操作成功",
///     "data": { "objectInfo": {...}, "val": 22856 } }
/// `data.val` 即文件 id（= image_id）；`code != 0` 表示失败，`msg` 为原因。
class GfsUploader {
  GfsUploader._();
  static final GfsUploader instance = GfsUploader._();

  final http.Client _http = http.Client();

  Future<int> upload(File file, UploadPolicy p) async {
    final uri = Uri.parse('${p.gfsHost}/v1/upload');
    final req = http.MultipartRequest('POST', uri)
      ..fields['appId'] = p.appId
      ..fields['policy'] = p.policy
      ..fields['signature'] = p.signature
      ..fields['timestamp'] = p.timestamp.toString()
      ..fields['nonce'] = p.nonce
      ..fields['expire'] = p.expire.toString()
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    http.Response res;
    try {
      final streamed = await _http.send(req).timeout(ApiConfig.timeout);
      res = await http.Response.fromStream(streamed);
    } on TimeoutException {
      throw const NetworkException(code: 'timeout');
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      if (kDebugMode) debugPrint('[GFS] upload ${res.statusCode}: ${res.body}');
      throw ApiException(status: res.statusCode, code: 'gfs_upload_failed');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(res.bodyBytes));
    } catch (_) {
      decoded = null;
    }

    if (decoded is Map) {
      // 业务失败：code != 0
      final code = decoded['code'];
      if (code is num && code.toInt() != 0) {
        if (kDebugMode) debugPrint('[GFS] upload 业务失败: ${res.body}');
        throw ApiException(status: res.statusCode, code: 'gfs_upload_failed');
      }
      // 文件 id 固定在 data.val
      final data = decoded['data'];
      if (data is Map) {
        final id = _asInt(data['val']);
        if (id != null) return id;
      }
    }

    if (kDebugMode) debugPrint('[GFS] 未能从响应解析 image id，原始响应: ${res.body}');
    throw ApiException(status: res.statusCode, code: 'gfs_upload_parse');
  }

  int? _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}
