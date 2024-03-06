// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort_type_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class SortTypeModel extends _SortTypeModel
    with RealmEntity, RealmObjectBase, RealmObject {
  SortTypeModel(
    String sortBoardTypeName,
    String sortTaskTypeName,
  ) {
    RealmObjectBase.set(this, 'sortBoardTypeName', sortBoardTypeName);
    RealmObjectBase.set(this, 'sortTaskTypeName', sortTaskTypeName);
  }

  SortTypeModel._();

  @override
  String get sortBoardTypeName =>
      RealmObjectBase.get<String>(this, 'sortBoardTypeName') as String;
  @override
  set sortBoardTypeName(String value) =>
      RealmObjectBase.set(this, 'sortBoardTypeName', value);

  @override
  String get sortTaskTypeName =>
      RealmObjectBase.get<String>(this, 'sortTaskTypeName') as String;
  @override
  set sortTaskTypeName(String value) =>
      RealmObjectBase.set(this, 'sortTaskTypeName', value);

  @override
  Stream<RealmObjectChanges<SortTypeModel>> get changes =>
      RealmObjectBase.getChanges<SortTypeModel>(this);

  @override
  SortTypeModel freeze() => RealmObjectBase.freezeObject<SortTypeModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(SortTypeModel._);
    return const SchemaObject(
        ObjectType.realmObject, SortTypeModel, 'SortTypeModel', [
      SchemaProperty('sortBoardTypeName', RealmPropertyType.string),
      SchemaProperty('sortTaskTypeName', RealmPropertyType.string),
    ]);
  }
}
