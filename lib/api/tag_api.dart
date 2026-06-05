import 'api_client.dart';

/// 远端标签（含使用计数，来自 GET /tags）
class RemoteTagFull {
  final int id;
  final String name;
  final String color;
  final int outfitCount;
  final int ver; // 服务端乐观锁版本号
  const RemoteTagFull({
    required this.id,
    required this.name,
    required this.color,
    required this.outfitCount,
    required this.ver,
  });

  factory RemoteTagFull.fromJson(Map<String, dynamic> j) => RemoteTagFull(
        id: (j['id'] as num?)?.toInt() ?? 0,
        name: (j['name'] as String?) ?? '',
        color: (j['color'] as String?) ?? '#E8F5E9',
        outfitCount: (j['outfit_count'] as num?)?.toInt() ?? 0,
        ver: (j['ver'] as num?)?.toInt() ?? 0,
      );
}

/// 标签 API（需会员）
class TagApi {
  final ApiClient _client;
  TagApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  Future<List<RemoteTagFull>> list() async {
    final data = await _client.get('/tags');
    return ((data as List?) ?? const [])
        .map((e) => RemoteTagFull.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  /// 返回服务端 id
  Future<int> create(String name, String color) async {
    final data = await _client.post('/tags', body: {'name': name, 'color': color});
    return ((data as Map)['id'] as num).toInt();
  }

  /// 更新。[ver] 为 base 版本（0 = 不校验），返回服务端递增后的新 ver。
  /// 版本不一致抛 ConflictException(code=version_conflict)。
  Future<int> update(int serverId, String name, String color,
      {required int ver}) async {
    final data = await _client.put('/tags/$serverId',
        body: {'name': name, 'color': color, 'ver': ver});
    return ((data as Map)['ver'] as num?)?.toInt() ?? 0;
  }

  /// 删除。[ver] 为 base 版本，写校验同 update。
  Future<void> delete(int serverId, {required int ver}) =>
      _client.delete('/tags/$serverId?ver=$ver');

  /// 标签读校验：服务端 ver > [ver] 返回最新数据，否则 null。
  /// 标签已删（硬删）时 404 抛 ApiException。
  Future<RemoteTagFull?> checkVer(int serverId, int ver) async {
    final data = await _client.get('/tags/$serverId/ver', query: {'ver': ver});
    if (data == null) return null;
    return RemoteTagFull.fromJson((data as Map).cast<String, dynamic>());
  }
}
