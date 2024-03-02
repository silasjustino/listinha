import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RenameDialog extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function() onPressed;
  final String nomeItem;
  final bool list;
  bool? checkboxValue;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool value)? onChangedCheckbox;

  RenameDialog({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onPressed,
    required this.nomeItem,
    required this.list,
    this.checkboxValue,
    this.onChangedCheckbox,
  });

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  @override
  Widget build(BuildContext context) {
    Widget activeList = Container();

    if (widget.list) {
      activeList = Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('Ativa'),
          value: widget.checkboxValue ?? true,
          onChanged: (value) => setState(() {
            widget.checkboxValue = value;
            widget.onChangedCheckbox!(value!);
          }),
        ),
      );
    }

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
                      label: Text('Nome da ${widget.nomeItem}'),
                    ),
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: activeList,
                ),
                ElevatedButton(
                  onPressed: widget.onPressed,
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
