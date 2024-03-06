import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/shared/services/realm/models/sort_type_model.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:realm/realm.dart';
import 'package:rx_notifier/rx_notifier.dart';

abstract class SortTypeService {
  void init();
}

class RealmSortTypeService implements SortTypeService, Disposable {
  final Realm realm;
  final AppStore store;
  late final RxDisposer disposer;

  RealmSortTypeService(this.realm, this.store);

  @override
  void init() {
    final model = _getConfiguration();
    store.sortBoardTypeName.value = model.sortBoardTypeName;
    store.sortTaskTypeName.value = model.sortTaskTypeName;

    disposer = rxObserver(() {
      final sortBoardType = store.sortBoardTypeName.value;
      final sortTaskType = store.sortTaskTypeName.value;

      _saveSortType(sortBoardType, sortTaskType);
    });
  }

  @override
  void dispose() {
    disposer();
  }

  SortTypeModel _getConfiguration() {
    try {
      return realm.all<SortTypeModel>().first;
    } catch (e) {
      realm.write(() {
        realm.add(SortTypeModel('oldest', 'oldest'));
      });
      return realm.all<SortTypeModel>().first;
    }
  }

  void _saveSortType(String sortBoardTypeName, String sortTaskTypeName) {
    final model = _getConfiguration();
    realm.write(() {
      model
        ..sortBoardTypeName = sortBoardTypeName
        ..sortTaskTypeName = sortTaskTypeName;
    });
  }
}
