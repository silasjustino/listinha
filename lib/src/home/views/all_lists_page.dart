import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/widgets/task_card.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class AllListsPage extends StatelessWidget {
  final List<TaskBoard> taskBoards;

  const AllListsPage({
    super.key,
    required this.taskBoards,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
  }
}
