import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/models/sort_mode_model.dart';
import 'package:listinha/src/home/widgets/task_card.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class AllListsPage extends StatelessWidget {
  final List<TaskBoard> taskBoards;
  final SortMode sortMode;

  const AllListsPage({
    super.key,
    required this.taskBoards,
    required this.sortMode,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (sortMode == SortMode.oldest) {
      widget = ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 70),
        itemCount: taskBoards.length,
        itemBuilder: (_, index) {
          final board = taskBoards[index];

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
      final newestBoards = taskBoards.reversed.toList();

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
      final byNameBoards = taskBoards;

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
