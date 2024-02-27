import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/widgets/task_card.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class DesactivatedListsPage extends StatelessWidget {
  final List<TaskBoard> taskBoards;

  const DesactivatedListsPage({
    super.key,
    required this.taskBoards,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget;

    final desactivated = taskBoards
        .where(
          (taskboard) => taskboard.enable == false,
        )
        .toList();

    if (desactivated.isEmpty) {
      widget = const Padding(
        padding: EdgeInsets.fromLTRB(20, 80, 20, 70),
        child: Text('Sem listas desativadas'),
      );
    } else {
      widget = ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 70),
        itemCount: desactivated.length,
        itemBuilder: (_, index) {
          final board = desactivated[index];

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
