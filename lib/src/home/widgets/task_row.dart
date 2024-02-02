import 'package:flutter/material.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class TaskRow extends StatelessWidget {
  final List<Task> tasks;
  final int index;
  final bool checkbox;

  const TaskRow({
    super.key,
    required this.tasks,
    required this.checkbox,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checkbox,
          onChanged: (value) {},
        ),
        Text(tasks[index].description),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.cancel_outlined),
        ),
      ],
    );
  }
}
