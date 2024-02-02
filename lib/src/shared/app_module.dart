import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/configuration/configuration_page.dart';
import 'package:listinha/src/configuration/services/configuration_service.dart';
import 'package:listinha/src/home/home_module.dart';
import 'package:listinha/src/home/services/taskboard_service.dart';
import 'package:listinha/src/shared/services/realm/realm_config.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:realm/realm.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i
      ..addInstance<Realm>(Realm(config))
      ..addSingleton<ConfigurationService>(RealmConfigurationService.new)
      ..addSingleton<RealmTaskBoardService>(RealmTaskBoardService.new)
      ..addSingleton(AppStore.new);
  }

  @override
  void routes(RouteManager r) {
    r
      ..module('/home', module: HomeModule())
      ..child('/config', child: (context) => const ConfigurationPage());
  }
}
