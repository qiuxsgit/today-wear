import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';
import 'daos/outfit_dao.dart';
import 'daos/tag_dao.dart';
import 'daos/image_dao.dart';

part 'database.g.dart';

/// 数据库类
@DriftDatabase(tables: [Outfits, Tags, OutfitTags, OutfitImages], daos: [OutfitDao, TagDao, ImageDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());
  
  /// 单例实例
  static AppDatabase? _instance;
  
  /// 获取数据库实例
  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // 创建索引
        await customStatement('CREATE INDEX IF NOT EXISTS idx_outfits_date ON outfits(date)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_outfits_is_deleted ON outfits(is_deleted)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_outfit_tags_outfit_id ON outfit_tags(outfit_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_outfit_tags_tag_id ON outfit_tags(tag_id)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_outfit_images_outfit_id ON outfit_images(outfit_id)');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await customStatement(
            "ALTER TABLE tags ADD COLUMN color TEXT DEFAULT '#E8F5E9'",
          );
        }
      },
    );
  }
}

/// 打开数据库连接
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'today_wear.db'));
    return NativeDatabase(file);
  });
}
