import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/services/taskboard_service.dart';
import 'package:listinha/src/home/widgets/task_card.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class SearchBoardPage extends StatefulWidget {
  const SearchBoardPage({super.key});

  @override
  State<SearchBoardPage> createState() => _SearchBoardPageState();
}

class _SearchBoardPageState extends State<SearchBoardPage> {
  late TextEditingController searchController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    searchController = TextEditingController();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    //Modular Singletons
    final taskBoardService = Modular.get<RealmTaskBoardService>();
    final taskBoards = taskBoardService.store.taskboards.value;

    Widget widget;

    if (taskBoards.isEmpty) {
      widget = const Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Text('Sem listas'),
      );
    } else if (searchController.text.isEmpty) {
      widget = ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
    } else {
      List<TaskBoard> searchedBoards;
      searchedBoards = taskBoards
          .where(
            (board) => board.title
                .toUpperCase()
                .contains(searchController.text.toUpperCase()),
          )
          .toList();

      if (searchedBoards.isEmpty) {
        widget = const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text('Sem listas'),
        );
      } else {
        widget = ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          itemCount: searchedBoards.length,
          itemBuilder: (_, index) {
            final board = searchedBoards[index];

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: TextFormField(
          autofocus: true,
          decoration: const InputDecoration(
            label: Text('Nome da lista'),
            border: InputBorder.none,
          ),
          controller: searchController,
          focusNode: _focusNode,
          onChanged: (value) {
            setState(() {});
          },
        ),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: widget,
      ),
    );
  }
}
