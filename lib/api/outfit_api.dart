import 'api_client.dart';

/// 远端标签（内嵌于 outfit）
class RemoteTag {
  final int id;
  final String name;
  final String color;
  const RemoteTag({required this.id, required this.name, required this.color});

  factory RemoteTag.fromJson(Map<String, dynamic> j) => RemoteTag(
        id: (j['id'] as num?)?.toInt() ?? 0,
        name: (j['name'] as String?) ?? '',
        color: (j['color'] as String?) ?? '#E8F5E9',
      );
}

/// 远端 outfit
class RemoteOutfit {
  final int id;
  final int date; // Unix ms
  final String description;
  final List<RemoteTag> tags;
  final List<int> imageIds;
  final List<String> imageUrls; // 与 imageIds 同序，可能为空
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  final int ver; // 服务端乐观锁版本号

  const RemoteOutfit({
    required this.id,
    required this.date,
    required this.description,
    required this.tags,
    required this.imageIds,
    required this.imageUrls,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.ver,
  });

  factory RemoteOutfit.fromJson(Map<String, dynamic> j) => RemoteOutfit(
        id: (j['id'] as num?)?.toInt() ?? 0,
        date: (j['date'] as num?)?.toInt() ?? 0,
        description: (j['description'] as String?) ?? '',
        tags: ((j['tags'] as List?) ?? const [])
            .map((e) => RemoteTag.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        imageIds: ((j['image_ids'] as List?) ?? const [])
            .map((e) => (e as num).toInt())
            .toList(),
        imageUrls: ((j['image_urls'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList(),
        isDeleted: (j['is_deleted'] as bool?) ?? false,
        createdAt: (j['created_at'] as num?)?.toInt() ?? 0,
        updatedAt: (j['updated_at'] as num?)?.toInt() ?? 0,
        ver: (j['ver'] as num?)?.toInt() ?? 0,
      );
}

/// 一页 outfit 列表
class OutfitPage {
  final List<RemoteOutfit> items;
  final String nextCursor;
  final bool hasMore;
  const OutfitPage({required this.items, required this.nextCursor, required this.hasMore});
}

/// 写入（创建/更新）结果，用于回填本地 id
class OutfitWriteResult {
  final int id;
  final Map<String, int> tagIds; // 标签名 → 服务端 id
  final List<int> imageIds;
  final int ver; // 写入后的新版本（创建 = 1）
  const OutfitWriteResult({
    required this.id,
    required this.tagIds,
    required this.imageIds,
    required this.ver,
  });

  factory OutfitWriteResult.fromJson(Map<String, dynamic> j) {
    final raw = (j['tag_ids'] as Map?)?.cast<String, dynamic>() ?? const {};
    return OutfitWriteResult(
      id: (j['id'] as num?)?.toInt() ?? 0,
      tagIds: raw.map((k, v) => MapEntry(k, (v as num).toInt())),
      imageIds: ((j['image_ids'] as List?) ?? const [])
          .map((e) => (e as num).toInt())
          .toList(),
      ver: (j['ver'] as num?)?.toInt() ?? 0,
    );
  }
}

/// 穿搭 API（需会员）
class OutfitApi {
  final ApiClient _client;
  OutfitApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  Future<OutfitPage> list({String? cursor, int? limit, int? since}) async {
    final data = await _client.get('/outfits', query: {
      'cursor': cursor,
      'limit': limit,
      'since': since,
    });
    final map = (data as Map).cast<String, dynamic>();
    return OutfitPage(
      items: ((map['items'] as List?) ?? const [])
          .map((e) => RemoteOutfit.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      nextCursor: (map['next_cursor'] as String?) ?? '',
      hasMore: (map['has_more'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> _body({
    required int date,
    required String description,
    required List<Map<String, String>> tags,
    required List<int> imageIds,
    required int createdAt,
    required int updatedAt,
  }) =>
      {
        'date': date,
        'description': description,
        'tags': tags,
        'image_ids': imageIds,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  Future<OutfitWriteResult> create({
    required int date,
    required String description,
    required List<Map<String, String>> tags,
    required List<int> imageIds,
    required int createdAt,
    required int updatedAt,
  }) async {
    final data = await _client.post('/outfits',
        body: _body(
          date: date,
          description: description,
          tags: tags,
          imageIds: imageIds,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ));
    return OutfitWriteResult.fromJson((data as Map).cast<String, dynamic>());
  }

  /// 更新（整体替换）。[ver] 为本地持有的 base 版本，服务端不一致时抛
  /// ConflictException(code=version_conflict)。
  Future<OutfitWriteResult> update(
    int serverId, {
    required int date,
    required String description,
    required List<Map<String, String>> tags,
    required List<int> imageIds,
    required int createdAt,
    required int updatedAt,
    required int ver,
  }) async {
    final data = await _client.put('/outfits/$serverId',
        body: _body(
          date: date,
          description: description,
          tags: tags,
          imageIds: imageIds,
          createdAt: createdAt,
          updatedAt: updatedAt,
        )..['ver'] = ver);
    return OutfitWriteResult.fromJson((data as Map).cast<String, dynamic>());
  }

  /// 软删除。[ver] 为 base 版本，写校验同 update。
  Future<void> delete(int serverId, {required int ver}) =>
      _client.delete('/outfits/$serverId?ver=$ver');

  /// 记录级读校验：服务端 ver > [ver] 时返回完整最新数据，否则 null。
  Future<RemoteOutfit?> checkVer(int serverId, int ver) async {
    final data = await _client.get('/outfits/$serverId/ver', query: {'ver': ver});
    if (data == null) return null;
    return RemoteOutfit.fromJson((data as Map).cast<String, dynamic>());
  }
}
