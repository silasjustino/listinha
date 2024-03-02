import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/services/taskboard_service.dart';
import 'package:listinha/src/home/widgets/delete_dialog.dart';
import 'package:listinha/src/home/widgets/rename_dialog.dart';
import 'package:listinha/src/home/widgets/task_row.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';
import 'package:realm/realm.dart';

class TaskPage extends StatefulWidget {
  final TaskBoard board;

  const TaskPage({super.key, required this.board});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final taskBoardService = Modular.get<RealmTaskBoardService>();
  late TextEditingController boardTitleController;
  late TextEditingController taskDescriptionController;

  late FocusNode _focusNode;

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
  Widget build(BuildContext context) {
    final board = widget.board;

    final theme = Theme.of(context);
    final tasks = board.tasks;
    final progress = getProgress(tasks);

    final completed = tasks.where((task) => task.completed).toList();

    return WillPopScope(
      onWillPop: () async {
        await Modular.to.pushNamed('./');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(board.title),
          actions: [
            IconButton(
              onPressed: () {
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
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
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
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: Stack(
          children: [
            PageView(
              physics: const ClampingScrollPhysics(),
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
                          itemCount: tasks
                              .where((task) => task.completed == false)
                              .length,
                          itemBuilder: (_, index) {
                            final notCompleted = <Task>[];

                            for (var i = 0; i < tasks.length; i++) {
                              if (tasks[i].completed == false) {
                                notCompleted.add(tasks[i]);
                              }
                            }

                            return TaskRow(
                              tasks: notCompleted,
                              checkbox: false,
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
                    ],
                  ),
                ),
              ],
            ),
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
