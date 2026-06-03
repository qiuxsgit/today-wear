import 'api_client.dart';

/// 远端标签（含使用计数，来自 GET /tags）
class RemoteTagFull {
  final int id;
  final String name;
  final String color;
  final int outfitCount;
  const RemoteTagFull({
    required this.id,
    required this.name,
    required this.color,
    required this.outfitCount,
  });

  factory RemoteTagFull.fromJson(Map<String, dynamic> j) => RemoteTagFull(
        id: (j['id'] as num?)?.toInt() ?? 0,
        name: (j['name'] as String?) ?? '',
        color: (j['color'] as String?) ?? '#E8F5E9',
        outfitCount: (j['outfit_count'] as num?)?.toInt() ?? 0,
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

  Future<void> update(int serverId, String name, String color) =>
      _client.put('/tags/$serverId', body: {'name': name, 'color': color});

  Future<void> delete(int serverId) => _client.delete('/tags/$serverId');
}
