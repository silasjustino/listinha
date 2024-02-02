import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/widgets/task_row.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class TaskPage extends StatelessWidget {
  final TaskBoard board;

  const TaskPage({super.key, required this.board});

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
    final theme = Theme.of(context);
    final tasks = board.tasks;
    final progress = getProgress(tasks);

    return WillPopScope(
      onWillPop: () async {
        await Modular.to.pushNamed('./');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Listinha'),
          actions: [
            IconButton(
              onPressed: () {
                Modular.to.pushNamed('./');
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80, bottom: 80),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 50,
                        ),
                        child: ListView.builder(
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
                            );
                          },
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 50,
                        ),
                        child: ListView.builder(
                          itemCount: tasks
                              .where((task) => task.completed == true)
                              .length,
                          itemBuilder: (_, index) {
                            final completed = <Task>[];

                            for (var i = 0; i < tasks.length; i++) {
                              if (tasks[i].completed == true) {
                                completed.add(tasks[i]);
                              }
                            }

                            return TaskRow(
                              tasks: completed,
                              checkbox: true,
                              index: index,
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
                        board.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Modular.to.pushNamed('./task_register');
                        },
                        icon: const Icon(Icons.edit),
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
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Novo item'),
          onPressed: () {},
        ),
      ),
    );
  }
}
