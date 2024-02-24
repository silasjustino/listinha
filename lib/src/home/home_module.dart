import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/home/home_page.dart';
import 'package:listinha/src/home/task_page.dart';

class HomeModule extends Module {
  @override
  void routes(RouteManager r) {
    r
      ..child('/', child: (context) => const HomePage())
      ..child('/task', child: (context) => TaskPage(board: r.args.data));
  }
}
