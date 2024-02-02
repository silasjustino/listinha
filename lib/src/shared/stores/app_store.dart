import 'package:flutter/material.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';
import 'package:rx_notifier/rx_notifier.dart';

class AppStore {
  final themeMode = RxNotifier(ThemeMode.system);
  final syncDate = RxNotifier<DateTime?>(null);
  final taskboards = ValueNotifier<List<TaskBoard>>([]);
}
