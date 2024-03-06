import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/configuration/services/configuration_service.dart';
import 'package:listinha/src/home/services/sort_type_service.dart';
import 'package:listinha/src/home/services/taskboard_service.dart';
import 'package:listinha/src/home/services/taskview_service.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:listinha/src/shared/themes/themes.dart';
import 'package:rx_notifier/rx_notifier.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final config = Modular.get<ConfigurationService>();
  final taskBoards = Modular.get<RealmTaskBoardService>();
  final taskViewType = Modular.get<TaskViewService>();
  final sortType = Modular.get<SortTypeService>();
  final appStore = Modular.get<AppStore>();

  @override
  void initState() {
    super.initState();

    config.init();
    taskBoards.init();
    taskViewType.init();
    sortType.init();
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/home/');

    final themeMode = context.select(() => appStore.themeMode.value);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
    );
  }
}
