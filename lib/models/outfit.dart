/// Outfit 的一张图片
///
/// 本地新拍的图：有 [localPath] 无 [serverImageId]；
/// 云端拉取未下载的图：有 [serverImageId] 无 [localPath]；
/// 下载完成 / 上传完成后两者都有。
class OutfitPhoto {
  /// 本地相对路径（如 images/20260128/123_0.jpg），未下载时为 null
  final String? localPath;

  /// 云端 GFS 图片 id，未上传时为 null
  final int? serverImageId;

  const OutfitPhoto({this.localPath, this.serverImageId});
}

/// Outfit 数据模型
///
/// 表示一条穿搭记录
class Outfit {
  /// 唯一标识符（数据库自增 ID）
  final int id;

  /// 日期
  final DateTime date;

  /// 照片列表（按显示顺序）
  final List<OutfitPhoto> photos;

  /// 穿搭描述
  final String description;

  /// 标签列表（如：天气、场合等）
  final List<String> tags;

  /// 标签颜色列表（与 tags 一一对应，hex 如 #E8F5E9）
  final List<String> tagColors;

  const Outfit({
    required this.id,
    required this.date,
    this.photos = const [],
    required this.description,
    this.tags = const [],
    this.tagColors = const [],
  });

  /// 已下载到本地的图片相对路径（仅含 localPath 非空的图片，
  /// 供只能处理本地文件的场景使用，如编辑页）
  List<String> get photoPaths => [
        for (final p in photos)
          if (p.localPath != null) p.localPath!,
      ];
  
  /// 生成模拟数据（已废弃，请使用数据库）
  /// 
  /// 返回最近7天的穿搭数据，包含今天的数据
  @Deprecated('使用数据库存储，不再使用模拟数据')
  static List<Outfit> generateMockData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final outfits = <Outfit>[];
    int mockId = 1;
    
    // 今天（两条记录）
    outfits.add(Outfit(
      id: mockId++,
      date: today,
      description: '白色毛衣 + 牛仔裤 + 运动鞋',
      tags: ['晴天', '日常'],
    ));
    outfits.add(Outfit(
      id: mockId++,
      date: today,
      description: '米色风衣 + 黑色内搭 + 长靴',
      tags: ['晴天', '工作'],
    ));
    
    // 昨天（两条记录）
    final yesterday = today.subtract(const Duration(days: 1));
    outfits.add(Outfit(
      id: mockId++,
      date: yesterday,
      description: '黑色大衣 + 灰色长裤',
      tags: ['阴天', '工作'],
    ));
    outfits.add(Outfit(
      id: mockId++,
      date: yesterday,
      description: '粉色卫衣 + 黑色短裙 + 小白鞋',
      tags: ['阴天', '日常'],
    ));
    
    // 2天前
    final twoDaysAgo = today.subtract(const Duration(days: 2));
    outfits.add(Outfit(
      id: mockId++,
      date: twoDaysAgo,
      description: '粉色卫衣 + 白色短裙',
      tags: ['晴天', '日常'],
    ));
    
    // 3天前（两条记录）
    final threeDaysAgo = today.subtract(const Duration(days: 3));
    outfits.add(Outfit(
      id: mockId++,
      date: threeDaysAgo,
      description: '蓝色衬衫 + 卡其色长裤',
      tags: ['雨天', '工作'],
    ));
    outfits.add(Outfit(
      id: mockId++,
      date: threeDaysAgo,
      description: '灰色针织开衫 + 白色T恤 + 牛仔裤',
      tags: ['雨天', '日常'],
    ));
    
    // 4天前
    final fourDaysAgo = today.subtract(const Duration(days: 4));
    outfits.add(Outfit(
      id: mockId++,
      date: fourDaysAgo,
      description: '米色针织衫 + 黑色牛仔裤',
      tags: ['晴天', '日常'],
    ));
    
    // 5天前
    final fiveDaysAgo = today.subtract(const Duration(days: 5));
    outfits.add(Outfit(
      id: mockId++,
      date: fiveDaysAgo,
      description: '灰色西装 + 白色内搭',
      tags: ['阴天', '工作'],
    ));
    
    // 6天前
    final sixDaysAgo = today.subtract(const Duration(days: 6));
    outfits.add(Outfit(
      id: mockId++,
      date: sixDaysAgo,
      description: '绿色风衣 + 深色长裤',
      tags: ['雨天', '日常'],
    ));
    
    // 按日期倒序排列（最新的在前）
    outfits.sort((a, b) => b.date.compareTo(a.date));
    
    return outfits;
  }
}
