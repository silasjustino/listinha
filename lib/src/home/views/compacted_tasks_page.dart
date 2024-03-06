import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/services/taskboard_service.dart';
import 'package:listinha/src/home/widgets/task_row.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class CompactedTasksPage extends StatefulWidget {
  final List<Task> notCompleted;
  final List<Task> completed;
  final TaskBoard board;

  const CompactedTasksPage({
    super.key,
    required this.notCompleted,
    required this.completed,
    required this.board,
  });

  @override
  State<CompactedTasksPage> createState() => _CompactedTasksPageState();
}

class _CompactedTasksPageState extends State<CompactedTasksPage> {
  final taskBoardService = Modular.get<RealmTaskBoardService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notCompleted = widget.notCompleted;
    final completed = widget.completed;
    final board = widget.board;

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      children: [
                        Text(
                          'Concluídas',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
