import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:drift/native.dart';
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

  /// 测试用构造（注入内存数据库等自定义执行器，不影响单例）
  @visibleForTesting
  AppDatabase.forTesting(super.e);

  /// 单例实例
  static AppDatabase? _instance;

  /// 获取数据库实例
  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // 创建索引
        await customStatement('CREATE INDEX IF NOT EXISTS idx_outfits_date ON outfits(date)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_outfits_is_deleted ON outfits(is_deleted)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_outfits_server_id ON outfits(server_id)');
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
        if (from < 3) {
          // 云同步元数据。存量行 dirty=1 → 首次同步全量推送
          await customStatement('ALTER TABLE outfits ADD COLUMN server_id INTEGER');
          await customStatement('ALTER TABLE outfits ADD COLUMN dirty INTEGER NOT NULL DEFAULT 1');
          await customStatement('ALTER TABLE tags ADD COLUMN server_id INTEGER');
          await customStatement('ALTER TABLE tags ADD COLUMN dirty INTEGER NOT NULL DEFAULT 1');
          await customStatement('ALTER TABLE outfit_images ADD COLUMN server_image_id INTEGER');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_outfits_server_id ON outfits(server_id)');
        }
        if (from < 4) {
          // image_path 改为可空（云端拉取的图片懒加载，下载前无本地路径）。
          // SQLite 不能直接改列约束，由 drift 重建表并迁移数据。
          // ignore: experimental_member_use
          await m.alterTable(TableMigration(outfitImages));
        }
        if (from < 5) {
          // 记录级乐观锁版本号。存量行 ver=0 < 服务端任何 ver → 首次读校验自动拉新回填
          await customStatement('ALTER TABLE outfits ADD COLUMN ver INTEGER NOT NULL DEFAULT 0');
          await customStatement('ALTER TABLE tags ADD COLUMN ver INTEGER NOT NULL DEFAULT 0');
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
