import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/models/sort_mode_model.dart';
import 'package:listinha/src/home/services/taskboard_service.dart';
import 'package:listinha/src/home/views/all_lists_page.dart';
import 'package:listinha/src/home/views/completed_lists_page.dart';
import 'package:listinha/src/home/views/desactivated_lists_page.dart';
import 'package:listinha/src/home/views/pendents_lists_page.dart';
import 'package:listinha/src/home/widgets/custom_drawer.dart';
import 'package:listinha/src/home/widgets/rename_dialog.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:realm/realm.dart';

enum ListType { all, pendents, completed, desactivated }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Variables from FloatingActionButton
  late TextEditingController listNameController;
  late FocusNode _focusNode;

  //Modular Singletons
  final store = Modular.get<AppStore>();
  final taskBoardService = Modular.get<RealmTaskBoardService>();

  //Variables from SegmentedButton
  int listType = 0;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    listNameController = TextEditingController();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    listNameController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  //Dialog to exit app
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              alignment: AlignmentDirectional.center,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        'Sair do aplicativo?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Não',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: TextButton(
                            onPressed: SystemNavigator.pop,
                            child: Text(
                              'Sim',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    //Boards
    List<TaskBoard> taskBoards;
    taskBoards = store.taskboards.value.toList();

    //Boards Variables
    Widget widget;
    final _pageController = PageController();

    //SortMode
    final _sortMode = SortMode.fromString(store.sortBoardTypeName.value);

    //SortMode Conditional
    if (_sortMode == SortMode.newest) {
      taskBoards = taskBoards.reversed.toList();
    } else if (_sortMode == SortMode.byName) {
      taskBoards.sort(
        (a, b) => a.title.compareTo(b.title),
      );
    }

    //Board View Conditional
    if (taskBoards.isEmpty) {
      widget = const Padding(
        padding: EdgeInsets.fromLTRB(20, 80, 20, 70),
        child: Text('Sem listas'),
      );
    } else {
      widget = PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          AllListsPage(
            taskBoards: taskBoards,
          ),
          PendentsListsPage(
            taskBoards: taskBoards,
          ),
          CompletedListsPage(
            taskBoards: taskBoards,
          ),
          DesactivatedListsPage(
            taskBoards: taskBoards,
          ),
        ],
      );
    }

    //View
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text('Listas'),
          scrolledUnderElevation: 0,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    Modular.to.pushNamed('./searchBoard');
                  },
                  child: const Text('Pesquisar'),
                ),
                PopupMenuItem(
                  onTap: () {
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(1, 0, 0, 0),
                      items: [
                        PopupMenuItem<SortMode>(
                          value: SortMode.oldest,
                          enabled: _sortMode != SortMode.oldest,
                          onTap: () {
                            setState(() {
                              store.sortBoardTypeName.value =
                                  SortMode.oldest.name;
                            });
                          },
                          child: const Text('Mais antigo'),
                        ),
                        PopupMenuItem<SortMode>(
                          value: SortMode.newest,
                          enabled: _sortMode != SortMode.newest,
                          onTap: () {
                            setState(() {
                              store.sortBoardTypeName.value =
                                  SortMode.newest.name;
                            });
                          },
                          child: const Text('Mais recente'),
                        ),
                        PopupMenuItem<SortMode>(
                          value: SortMode.byName,
                          enabled: _sortMode != SortMode.byName,
                          onTap: () {
                            setState(() {
                              store.sortBoardTypeName.value =
                                  SortMode.byName.name;
                            });
                          },
                          child: const Text('Ordem alfabética'),
                        ),
                      ],
                    );
                  },
                  child: const Text('Ordenar'),
                ),
              ],
            ),
          ],
        ),
        body: Center(
          child: Stack(
            children: [
              widget,
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
                  child: SegmentedButton<int>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: 0,
                        label: Text('Todas'),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text('Pendentes'),
                      ),
                      ButtonSegment(
                        value: 2,
                        label: Text('Concluídas'),
                      ),
                      ButtonSegment(
                        value: 3,
                        label: Text('Desativadas'),
                      ),
                    ],
                    selected: <int>{listType},
                    onSelectionChanged: (values) {
                      setState(() {
                        listType = values.first;
                      });
                      _pageController.jumpToPage(listType);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.edit),
          label: const Text('Nova lista'),
          onPressed: () {
            bool checkboxValue;
            checkboxValue = true;

            showDialog<String>(
              context: context,
              builder: (BuildContext context) => RenameDialog(
                controller: listNameController,
                focusNode: _focusNode,
                nomeItem: 'lista',
                list: true,
                checkboxValue: checkboxValue,
                onChangedCheckbox: (value) {
                  checkboxValue = value;
                },
                onPressed: (key) {
                  if (key.currentState!.validate()) {
                    final board = TaskBoard(
                      Uuid.v4(),
                      listNameController.text,
                      enable: checkboxValue,
                    );
                    taskBoardService.saveTaskBoard(board);

                    Modular.to.pushNamed('./task', arguments: board);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
