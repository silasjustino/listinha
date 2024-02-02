import 'package:listinha/src/shared/services/realm/models/task_model.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:realm/realm.dart';

abstract class TaskBoardService {
  void init();
  void saveTaskBoard(TaskBoard model);
  void editTaskBoard(TaskBoard model);
  void deleteTaskBoard(TaskBoard model);
}

class RealmTaskBoardService implements TaskBoardService {
  final Realm realm;
  final AppStore store;

  RealmTaskBoardService(this.realm, this.store);

  @override
  void init() {
    final realmTaskBoards = _getTaskBoards();
    store.taskboards.value = realmTaskBoards;
  }

  List<TaskBoard> _getTaskBoards() {
    final realmTaskBoards = realm.all<TaskBoard>().toList();

    return realmTaskBoards;
  }

  @override
  void saveTaskBoard(TaskBoard model) {
    realm.write(() {
      realm.add(model);
    });
  }

  @override
  void deleteTaskBoard(TaskBoard model) {
    realm.write(() {
      realm.delete(model);
    });
  }

  @override
  void editTaskBoard(TaskBoard model) {
    realm.write(() {
      realm.add(model, update: true);
    });
  }
}
