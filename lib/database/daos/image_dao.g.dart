// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_dao.dart';

// ignore_for_file: type=lint
mixin _$ImageDaoMixin on DatabaseAccessor<AppDatabase> {
  $OutfitImagesTable get outfitImages => attachedDatabase.outfitImages;
  ImageDaoManager get managers => ImageDaoManager(this);
}

class ImageDaoManager {
  final _$ImageDaoMixin _db;
  ImageDaoManager(this._db);
  $$OutfitImagesTableTableManager get outfitImages =>
      $$OutfitImagesTableTableManager(_db.attachedDatabase, _db.outfitImages);
}
