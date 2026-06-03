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
/// 响应携带 bigint 文件 id（= image_id）。不同部署的字段名可能不同，这里在
/// 常见键名中鲁棒查找；首次联调若解析失败，会把原始响应打到日志便于核对。
class GfsUploader {
  GfsUploader._();
  static final GfsUploader instance = GfsUploader._();

  final http.Client _http = http.Client();

  /// 候选的文件 id 字段名（按优先级）
  static const List<String> _idKeys = [
    'fileId', 'file_id', 'id', 'imageId', 'image_id', 'fid',
  ];

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
      throw const NetworkException(message: '图片上传超时');
    } on SocketException {
      throw const NetworkException(message: '图片上传失败，请检查网络');
    } on http.ClientException {
      throw const NetworkException(message: '图片上传失败');
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      if (kDebugMode) debugPrint('[GFS] upload ${res.statusCode}: ${res.body}');
      throw ApiException(
        status: res.statusCode,
        code: 'gfs_upload_failed',
        message: '图片上传失败 (${res.statusCode})',
      );
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(res.bodyBytes));
    } catch (_) {
      // 也许直接返回纯数字 id
      final asInt = int.tryParse(res.body.trim());
      if (asInt != null) return asInt;
    }

    final id = _findId(decoded);
    if (id != null) return id;

    if (kDebugMode) debugPrint('[GFS] 未能从响应解析 image id，原始响应: ${res.body}');
    throw ApiException(
      status: res.statusCode,
      code: 'gfs_upload_parse',
      message: '图片上传成功但未能解析图片 id',
    );
  }

  /// 递归在 JSON 中查找首个 id-like 整数
  int? _findId(dynamic node) {
    if (node is Map) {
      for (final key in _idKeys) {
        final v = node[key];
        final id = _asInt(v);
        if (id != null) return id;
      }
      for (final v in node.values) {
        final id = _findId(v);
        if (id != null) return id;
      }
    } else if (node is List) {
      for (final v in node) {
        final id = _findId(v);
        if (id != null) return id;
      }
    }
    return null;
  }

  int? _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}
