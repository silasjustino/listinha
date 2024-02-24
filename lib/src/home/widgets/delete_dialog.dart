import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String nomeItem;
  final void Function() onPressedDelete;

  const DeleteDialog({
    super.key,
    required this.onPressedDelete,
    required this.nomeItem,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: AlignmentDirectional.center,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                'Apagar $nomeItem?',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Text(
                'A $nomeItem não poderá ser recuperada.',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Não',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: TextButton(
                    onPressed: onPressedDelete,
                    child: const Text(
                      'Sim',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
