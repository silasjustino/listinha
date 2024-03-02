// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_view_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class TaskViewModel extends _TaskViewModel
    with RealmEntity, RealmObjectBase, RealmObject {
  TaskViewModel(
    String taskViewTypeName,
  ) {
    RealmObjectBase.set(this, 'taskViewTypeName', taskViewTypeName);
  }

  TaskViewModel._();

  @override
  String get taskViewTypeName =>
      RealmObjectBase.get<String>(this, 'taskViewTypeName') as String;
  @override
  set taskViewTypeName(String value) =>
      RealmObjectBase.set(this, 'taskViewTypeName', value);

  @override
  Stream<RealmObjectChanges<TaskViewModel>> get changes =>
      RealmObjectBase.getChanges<TaskViewModel>(this);

  @override
  TaskViewModel freeze() => RealmObjectBase.freezeObject<TaskViewModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(TaskViewModel._);
    return const SchemaObject(
        ObjectType.realmObject, TaskViewModel, 'TaskViewModel', [
      SchemaProperty('taskViewTypeName', RealmPropertyType.string),
    ]);
  }
}
