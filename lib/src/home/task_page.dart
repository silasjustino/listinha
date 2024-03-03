import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/services/taskboard_service.dart';
import 'package:listinha/src/home/widgets/delete_dialog.dart';
import 'package:listinha/src/home/widgets/rename_dialog.dart';
import 'package:listinha/src/home/widgets/task_row.dart';
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
  final store = Modular.get<AppStore>();
  final taskBoardService = Modular.get<RealmTaskBoardService>();
  late TextEditingController boardTitleController;
  late TextEditingController taskDescriptionController;
  late Widget taskTypeWidget;

  late FocusNode _focusNode;

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

    final theme = Theme.of(context);
    final tasks = board.tasks;
    final progress = getProgress(tasks);

    final completed = tasks.where((task) => task.completed).toList();
    final notCompleted =
        tasks.where((task) => task.completed == false).toList();

    bool extendedNotSelected;
    bool compactedNotSelected;

    final pageViewController = PageController();

    if (taskBoardService.store.taskViewMode.value == 'compacted') {
      extendedNotSelected = true;
      compactedNotSelected = false;

      taskTypeWidget = Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: notCompleted.length,
                        itemBuilder: (_, index) {
                          final task = notCompleted[index];

                          return TaskRow(
                            tasks: notCompleted,
                            checkbox: task.completed,
                            index: index,
                            onPressedCheck: () {
                              setState(() {
                                taskBoardService.changeTaskStats(
                                  notCompleted[index],
                                );
                              });
                            },
                            onPressedDelete: () => setState(() {
                              taskBoardService.deleteTask(
                                notCompleted[index],
                                board,
                              );
                              Navigator.pop(context);
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    color: theme.colorScheme.background,
                    height: 80,
                    width: MediaQuery.sizeOf(context).width,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          children: [
                            Text(
                              'Realizadas',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: completed.length,
                        itemBuilder: (_, index) {
                          final task = completed[index];

                          Widget finalPadding = Container();

                          if (index == completed.length - 1) {
                            finalPadding = const SizedBox(
                              height: 60,
                            );
                          }

                          return Column(
                            children: [
                              TaskRow(
                                tasks: completed,
                                checkbox: task.completed,
                                index: index,
                                onPressedCheck: () => setState(() {
                                  taskBoardService.changeTaskStats(
                                    task,
                                  );
                                }),
                                onPressedDelete: () => setState(() {
                                  taskBoardService.deleteTask(
                                    task,
                                    board,
                                  );
                                  Navigator.pop(context);
                                }),
                              ),
                              finalPadding,
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: theme.colorScheme.background,
            height: 80,
            width: MediaQuery.sizeOf(context).width,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  children: [
                    Text(
                      'Pendentes',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          LinearProgressIndicator(
            value: progress,
          ),
        ],
      );
    } else {
      extendedNotSelected = false;
      compactedNotSelected = true;

      taskTypeWidget = Stack(
        children: [
          PageView(
            controller: pageViewController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 80, 10, 0),
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: notCompleted.length,
                        itemBuilder: (_, index) {
                          final task = notCompleted[index];

                          return TaskRow(
                            tasks: notCompleted,
                            checkbox: task.completed,
                            index: index,
                            onPressedCheck: () {
                              setState(() {
                                taskBoardService.changeTaskStats(
                                  notCompleted[index],
                                );
                              });
                            },
                            onPressedDelete: () => setState(() {
                              taskBoardService.deleteTask(
                                notCompleted[index],
                                board,
                              );
                              Navigator.pop(context);
                            }),
                          );
                        },
                      ),
                    ),
                    Container(
                      color: theme.colorScheme.background,
                      height: 80,
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 10),
                        child: Row(
                          children: [
                            Text(
                              'Pendentes',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                pageViewController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.linear,
                                );
                              },
                              icon: const Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 80, 10, 0),
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: completed.length,
                        itemBuilder: (_, index) {
                          final task = completed[index];

                          return TaskRow(
                            tasks: completed,
                            checkbox: task.completed,
                            index: index,
                            onPressedCheck: () => setState(() {
                              taskBoardService.changeTaskStats(
                                task,
                              );
                            }),
                            onPressedDelete: () => setState(() {
                              taskBoardService.deleteTask(
                                task,
                                board,
                              );
                              Navigator.pop(context);
                            }),
                          );
                        },
                      ),
                    ),
                    Container(
                      color: theme.colorScheme.background,
                      height: 80,
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 10),
                        child: Row(
                          children: [
                            Text(
                              'Realizadas',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                pageViewController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.linear,
                                );
                              },
                              icon: const Icon(Icons.arrow_back_ios),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          LinearProgressIndicator(
            value: progress,
          ),
        ],
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
                const PopupMenuItem(
                  child: Text('Ordenar'),
                ),
                PopupMenuItem(
                  onTap: () {
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(1, 0, 0, 0),
                      items: [
                        PopupMenuItem(
                          enabled: compactedNotSelected,
                          onTap: () {
                            setState(() {
                              store.taskViewMode.value = 'compacted';
                            });
                          },
                          child: const Text('Lista compacta'),
                        ),
                        PopupMenuItem(
                          enabled: extendedNotSelected,
                          onTap: () {
                            setState(() {
                              store.taskViewMode.value = 'extended';
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
        body: taskTypeWidget,
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
