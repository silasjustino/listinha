import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/services/taskboard_service.dart';
import 'package:listinha/src/home/widgets/task_row.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';

class SearchTaskPage extends StatefulWidget {
  final TaskBoard board;

  const SearchTaskPage({super.key, required this.board});

  @override
  State<SearchTaskPage> createState() => _SearchTaskPageState();
}

class _SearchTaskPageState extends State<SearchTaskPage> {
  late Widget tasksWidget;
  late TextEditingController searchController;
  late FocusNode _focusNode;

  final taskBoardService = Modular.get<RealmTaskBoardService>();

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    searchController = TextEditingController();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final board = widget.board;
    final tasks = board.tasks;

    if (tasks.isEmpty) {
      tasksWidget = const Text('Sem tarefas');
    } else if (searchController.text.isEmpty) {
      tasksWidget = SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (_, index) {
              final task = tasks[index];

              return TaskRow(
                tasks: tasks,
                checkbox: task.completed,
                index: index,
                onPressedCheck: () => setState(() {
                  taskBoardService.changeTaskStats(
                    task,
                  );
                }),
                onPressedDelete: () => setState(() {
                  taskBoardService.deleteTask(
                    task,
                    board,
                  );
                  Navigator.pop(context);
                }),
              );
            },
          ),
        ),
      );
    } else {
      List<Task> searchedTasks;
      searchedTasks = tasks
          .where(
            (task) => task.description
                .toUpperCase()
                .contains(searchController.text.toUpperCase()),
          )
          .toList();

      if (searchedTasks.isEmpty) {
        tasksWidget = const Text('Sem tarefas');
      } else {
        tasksWidget = SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: searchedTasks.length,
              itemBuilder: (_, index) {
                final task = searchedTasks[index];

                return TaskRow(
                  tasks: searchedTasks,
                  checkbox: task.completed,
                  index: index,
                  onPressedCheck: () => setState(() {
                    taskBoardService.changeTaskStats(
                      task,
                    );
                  }),
                  onPressedDelete: () => setState(() {
                    taskBoardService.deleteTask(
                      task,
                      board,
                    );
                    Navigator.pop(context);
                  }),
                );
              },
            ),
          ),
        );
      }
    }

    return WillPopScope(
      onWillPop: () async {
        await Modular.to.pushNamed('./task', arguments: board);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: TextFormField(
            autofocus: true,
            decoration: const InputDecoration(
              label: Text('Nome da tarefa'),
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
          child: tasksWidget,
        ),
      ),
    );
  }
}
