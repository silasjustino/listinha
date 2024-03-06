import 'package:listinha/src/shared/services/realm/models/configuration_model.dart';
import 'package:listinha/src/shared/services/realm/models/sort_type_model.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';
import 'package:listinha/src/shared/services/realm/models/task_view_model.dart';
import 'package:realm/realm.dart';

LocalConfiguration config = Configuration.local(
  [
    ConfigurationModel.schema,
    Task.schema,
    TaskBoard.schema,
    TaskViewModel.schema,
    SortTypeModel.schema,
  ],
  initialDataCallback: (realm) {
    realm
      ..add(ConfigurationModel('system'))
      ..add(SortTypeModel('oldest', 'oldest'))
      ..add(TaskViewModel('extended'));
  },
);
