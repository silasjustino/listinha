import 'package:listinha/src/shared/services/realm/models/task_model.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:realm/realm.dart';

abstract class TaskBoardService {
  void init();
  void saveTaskBoard(TaskBoard model);
  void renameTaskBoard(String title, TaskBoard model);
  void resetTaskBoard(TaskBoard model);
  void toggleTaskBoard({required bool enable, required TaskBoard model});
  void deleteTaskBoard(TaskBoard model);
  void saveTask(Task task, TaskBoard model);
  void deleteTask(Task task, TaskBoard model);
  void changeTaskStats(Task task);
  void renameTask(String description, Task task);
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
    store.taskboards.value.add(model);

    realm.write(() {
      realm.add(model);
    });
  }

  @override
  void deleteTaskBoard(TaskBoard model) {
    store.taskboards.value.removeWhere((board) => board.id == model.id);

    realm.write(() {
      realm.delete(model);
    });
  }

  @override
  void renameTaskBoard(String title, TaskBoard model) {
    realm.write(() {
      model.title = title;
    });
  }

  @override
  void resetTaskBoard(TaskBoard model) {
    final completedTasks = model.tasks.where((task) => task.completed).toList();

    realm.write(() {
      for (var i = 0; i < completedTasks.length; i++) {
        completedTasks[i].completed = false;
      }
    });
  }

  @override
  void toggleTaskBoard({required bool enable, required TaskBoard model}) {
    realm.write(() {
      model.enable = enable;
    });
  }

  @override
  void saveTask(Task task, TaskBoard model) {
    realm.write(() {
      model.tasks.add(task);
    });
  }

  @override
  void changeTaskStats(Task task) {
    realm.write(() {
      task.completed = !task.completed;
    });
  }

  @override
  void renameTask(String description, Task task) {
    realm.write(() {
      task.description = description;
    });
  }

  @override
  void deleteTask(Task task, TaskBoard model) {
    realm.write(() {
      model.tasks.removeWhere((t) => t.id == task.id);
    });
  }
}
