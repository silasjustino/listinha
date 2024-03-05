import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/pages/home_page.dart';
import 'package:listinha/src/home/pages/search_board_page.dart';
import 'package:listinha/src/home/pages/task_page.dart';

class HomeModule extends Module {
  @override
  void routes(RouteManager r) {
    r
      ..child('/', child: (context) => const HomePage())
      ..child('/searchBoard', child: (context) => const SearchBoardPage())
      ..child('/task', child: (context) => TaskPage(board: r.args.data));
  }
}
