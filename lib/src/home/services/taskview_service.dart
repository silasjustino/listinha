import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/shared/services/realm/models/task_view_model.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:realm/realm.dart';
import 'package:rx_notifier/rx_notifier.dart';

abstract class TaskViewService {
  void init();
}

class RealmTaskViewService implements TaskViewService, Disposable {
  final Realm realm;
  final AppStore appStore;
  late final RxDisposer disposer;

  RealmTaskViewService(this.realm, this.appStore);

  @override
  void init() {
    final model = _getConfiguration();
    appStore.taskViewMode.value = model.taskViewTypeName;

    disposer = rxObserver(() {
      final taskViewType = appStore.taskViewMode.value;

      _saveConfiguration(taskViewType);
    });
  }

  @override
  void dispose() {
    disposer();
  }

  TaskViewModel _getConfiguration() {
    return realm.all<TaskViewModel>().first;
  }

  void _saveConfiguration(String taskViewTypeName) {
    final model = _getConfiguration();
    realm.write(() {
      model.taskViewTypeName = taskViewTypeName;
    });
  }
}
