import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/pages/home_page.dart';
import 'package:listinha/src/home/widgets/task_card.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class PendentsListsPage extends StatelessWidget {
  final List<TaskBoard> taskBoards;
  final SortMode sortMode;

  const PendentsListsPage({
    super.key,
    required this.taskBoards,
    required this.sortMode,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget;

    final pendents = taskBoards
        .where(
          (taskboard) =>
              (taskboard.tasks.where((task) => task.completed).length <
                      taskboard.tasks.length ||
                  taskboard.tasks.isEmpty) &&
              taskboard.enable == true,
        )
        .toList();

    if (pendents.isEmpty) {
      widget = const Padding(
        padding: EdgeInsets.fromLTRB(20, 80, 20, 70),
        child: Text('Sem listas pendentes'),
      );
    } else if (sortMode == SortMode.oldest) {
      widget = ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 70),
        itemCount: pendents.length,
        itemBuilder: (_, index) {
          final board = pendents[index];

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
    } else if (sortMode == SortMode.newest) {
      final newestBoards = pendents.reversed.toList();

      widget = ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 70),
        itemCount: newestBoards.length,
        itemBuilder: (_, index) {
          final board = newestBoards[index];

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
    } else {
      final byNameBoards = pendents;

      // ignore: cascade_invocations
      byNameBoards.sort(
        (a, b) => a.title.compareTo(b.title),
      );

      widget = ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 70),
        itemCount: byNameBoards.length,
        itemBuilder: (_, index) {
          final board = byNameBoards[index];

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
