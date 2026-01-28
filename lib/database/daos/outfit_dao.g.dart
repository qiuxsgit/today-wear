// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit_dao.dart';

// ignore_for_file: type=lint
mixin _$OutfitDaoMixin on DatabaseAccessor<AppDatabase> {
  $OutfitsTable get outfits => attachedDatabase.outfits;
  $OutfitTagsTable get outfitTags => attachedDatabase.outfitTags;
  OutfitDaoManager get managers => OutfitDaoManager(this);
}

class OutfitDaoManager {
  final _$OutfitDaoMixin _db;
  OutfitDaoManager(this._db);
  $$OutfitsTableTableManager get outfits =>
      $$OutfitsTableTableManager(_db.attachedDatabase, _db.outfits);
  $$OutfitTagsTableTableManager get outfitTags =>
      $$OutfitTagsTableTableManager(_db.attachedDatabase, _db.outfitTags);
}
