import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/models/sort_mode_model.dart';
import 'package:listinha/src/home/models/view_mode_model.dart';
import 'package:listinha/src/home/services/taskboard_service.dart';
import 'package:listinha/src/home/views/compacted_tasks_page.dart';
import 'package:listinha/src/home/views/extended_tasks_page.dart';
import 'package:listinha/src/home/widgets/delete_dialog.dart';
import 'package:listinha/src/home/widgets/rename_dialog.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:realm/realm.dart';

class TaskPage extends StatefulWidget {
  final TaskBoard board;

  const TaskPage({super.key, required this.board});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  //Modular Singletons
  final store = Modular.get<AppStore>();
  final taskBoardService = Modular.get<RealmTaskBoardService>();

  //TextEditingControllers
  late TextEditingController boardTitleController;
  late TextEditingController taskDescriptionController;
  late FocusNode _focusNode;

  //View Widget Variable
  late Widget taskTypeWidget;

  //Get Progress Method
  double getProgress(List<Task> tasks) {
    final tasksCompleted = tasks.where((task) => task.completed).length;
    double value;

    if (tasks.isEmpty) {
      value = 0;
    } else {
      value = tasksCompleted / tasks.length;
    }

    return value;
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    boardTitleController = TextEditingController();
    taskDescriptionController = TextEditingController();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    taskDescriptionController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final board = widget.board;

    final tasks = board.tasks;
    final progress = getProgress(tasks);

    final _sortMode = SortMode.fromString(store.sortTaskTypeName.value);
    final _viewMode = ViewMode.fromString(store.taskViewMode.value);

    List<Task> completed;
    completed = tasks.where((task) => task.completed).toList();
    List<Task> notCompleted;
    notCompleted = tasks.where((task) => task.completed == false).toList();

    if (_sortMode == SortMode.newest) {
      completed = completed.reversed.toList();
      notCompleted = notCompleted.reversed.toList();
    } else if (_sortMode == SortMode.byName) {
      completed.sort(
        (a, b) => a.description.compareTo(b.description),
      );
      notCompleted.sort(
        (a, b) => a.description.compareTo(b.description),
      );
    }

    if (_viewMode == ViewMode.compacted) {
      taskTypeWidget = CompactedTasksPage(
        notCompleted: notCompleted,
        completed: completed,
        board: board,
        onPressedCheck: (task) {
          setState(() {
            taskBoardService.changeTaskStats(
              task,
            );
          });
        },
        onPressedDelete: (task, board) {
          setState(() {
            taskBoardService.deleteTask(
              task,
              board,
            );
            Navigator.pop(context);
          });
        },
      );
    } else {
      taskTypeWidget = ExtendedTasksPage(
        notCompleted: notCompleted,
        completed: completed,
        board: board,
        onPressedCheck: (task) {
          setState(() {
            taskBoardService.changeTaskStats(
              task,
            );
          });
        },
        onPressedDelete: (task, board) {
          setState(() {
            taskBoardService.deleteTask(
              task,
              board,
            );
            Navigator.pop(context);
          });
        },
      );
    }

    return WillPopScope(
      onWillPop: () async {
        await Modular.to.pushNamed('./');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(board.title),
          scrolledUnderElevation: 0,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () =>
                      Modular.to.pushNamed('./searchTask', arguments: board),
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
                              store.sortTaskTypeName.value =
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
                              store.sortTaskTypeName.value =
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
                              store.sortTaskTypeName.value =
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
                PopupMenuItem(
                  onTap: () {
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(1, 0, 0, 0),
                      items: [
                        PopupMenuItem<ViewMode>(
                          value: ViewMode.compacted,
                          enabled: _viewMode != ViewMode.compacted,
                          onTap: () {
                            setState(() {
                              store.taskViewMode.value =
                                  ViewMode.compacted.name;
                            });
                          },
                          child: const Text('Lista compacta'),
                        ),
                        PopupMenuItem<ViewMode>(
                          value: ViewMode.extended,
                          enabled: _viewMode != ViewMode.extended,
                          onTap: () {
                            setState(() {
                              store.taskViewMode.value = ViewMode.extended.name;
                            });
                          },
                          child: const Text('Lista estendida'),
                        ),
                      ],
                    );
                  },
                  child: const Text('Visualizar'),
                ),
                PopupMenuItem(
                  onTap: () {
                    boardTitleController.text = board.title;
                    bool checkboxValue;
                    checkboxValue = board.enable;

                    showDialog(
                      context: context,
                      builder: (context) => RenameDialog(
                        controller: boardTitleController,
                        focusNode: _focusNode,
                        nomeItem: 'lista',
                        list: true,
                        checkboxValue: checkboxValue,
                        onChangedCheckbox: (value) {
                          checkboxValue = value;
                        },
                        onPressed: () {
                          taskBoardService
                            ..renameTaskBoard(
                              boardTitleController.text,
                              board,
                            )
                            ..toggleTaskBoard(
                              enable: checkboxValue,
                              model: board,
                            );
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  child: const Text('Editar'),
                ),
                PopupMenuItem(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => DeleteDialog(
                        onPressedDelete: () {
                          taskBoardService.deleteTaskBoard(board);
                          Modular.to.pushNamed('./');
                        },
                        nomeItem: 'lista',
                      ),
                    );
                  },
                  child: const Text('Excluir'),
                ),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            taskTypeWidget,
            LinearProgressIndicator(
              value: progress,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Novo item'),
          onPressed: () {
            taskDescriptionController.clear();

            showDialog<String>(
              context: context,
              builder: (BuildContext context) => RenameDialog(
                controller: taskDescriptionController,
                focusNode: _focusNode,
                onPressed: () {
                  final newTask = Task(
                    Uuid.v4(),
                    taskDescriptionController.text,
                  );
                  taskBoardService.saveTask(newTask, board);
                  setState(() {});
                  Navigator.pop(context);
                },
                nomeItem: 'tarefa',
                list: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
