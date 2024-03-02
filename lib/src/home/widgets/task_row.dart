import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:listinha/src/home/widgets/delete_dialog.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class TaskRow extends StatelessWidget {
  final List<Task> tasks;
  final int index;
  final bool checkbox;
  final void Function()? onPressedCheck;
  final void Function() onPressedDelete;

  const TaskRow({
    super.key,
    required this.tasks,
    required this.checkbox,
    required this.index,
    required this.onPressedCheck,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            SizedBox(
              width: 300,
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(tasks[index].description),
                value: checkbox,
                onChanged: (_) => onPressedCheck?.call(),
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => DeleteDialog(
                onPressedDelete: onPressedDelete,
                nomeItem: 'tarefa',
              ),
            );
          },
          icon: const Icon(Icons.cancel_outlined),
        ),
      ],
    );
  }
}
