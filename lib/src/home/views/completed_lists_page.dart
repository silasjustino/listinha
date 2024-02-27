import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/widgets/task_card.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class CompletedListsPage extends StatelessWidget {
  final List<TaskBoard> taskBoards;

  const CompletedListsPage({
    super.key,
    required this.taskBoards,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget;

    final completed = taskBoards
        .where(
          (taskboard) =>
              taskboard.tasks.where((task) => task.completed).length ==
                  taskboard.tasks.length &&
              taskboard.tasks.isNotEmpty,
        )
        .toList();

    if (completed.isEmpty) {
      widget = const Padding(
        padding: EdgeInsets.fromLTRB(20, 80, 20, 70),
        child: Text('Sem listas concluídas'),
      );
    } else {
      widget = ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 70),
        itemCount: completed.length,
        itemBuilder: (_, index) {
          final board = completed[index];

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Modular.to.pushNamed('./task', arguments: board);
                },
                child: TaskCard(
                  board: board,
                  height: 140,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      );
    }

    return widget;
  }
}
