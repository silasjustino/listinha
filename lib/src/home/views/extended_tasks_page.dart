import 'package:flutter/material.dart';
import 'package:listinha/src/home/widgets/task_row.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class ExtendedTasksPage extends StatelessWidget {
  final List<Task> notCompleted;
  final List<Task> completed;
  final TaskBoard board;
  final void Function(Task task) onPressedCheck;
  final void Function(Task task, TaskBoard board) onPressedDelete;

  const ExtendedTasksPage({
    super.key,
    required this.notCompleted,
    required this.completed,
    required this.board,
    required this.onPressedCheck,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    final pageViewController = PageController();
    final theme = Theme.of(context);

    return PageView(
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
                  padding: const EdgeInsets.only(bottom: 80),
                  physics: const ClampingScrollPhysics(),
                  itemCount: notCompleted.length,
                  itemBuilder: (_, index) {
                    final task = notCompleted[index];

                    return TaskRow(
                      tasks: notCompleted,
                      checkbox: task.completed,
                      index: index,
                      onPressedCheck: () => onPressedCheck(task),
                      onPressedDelete: () => onPressedDelete(task, board),
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
                            duration: const Duration(milliseconds: 300),
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
                  padding: const EdgeInsets.only(bottom: 80),
                  physics: const ClampingScrollPhysics(),
                  itemCount: completed.length,
                  itemBuilder: (_, index) {
                    final task = completed[index];

                    return TaskRow(
                      tasks: completed,
                      checkbox: task.completed,
                      index: index,
                      onPressedCheck: () => onPressedCheck(task),
                      onPressedDelete: () => onPressedDelete(task, board),
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
                        'Concluídas',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          pageViewController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
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
    );
  }
}
