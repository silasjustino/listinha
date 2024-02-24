import 'package:flutter/material.dart';

class RenameDialog extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function() onPressed;
  final String nomeItem;

  const RenameDialog({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onPressed,
    required this.nomeItem,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: AlignmentDirectional.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 150,
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      label: Text('Nome da $nomeItem'),
                    ),
                    controller: controller,
                    focusNode: focusNode,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onPressed,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
