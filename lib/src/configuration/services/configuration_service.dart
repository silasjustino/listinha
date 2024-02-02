import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:listinha/src/shared/services/realm/models/configuration_model.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:realm/realm.dart';
import 'package:rx_notifier/rx_notifier.dart';

abstract class ConfigurationService {
  void init();
  void deleteAll();
}

class RealmConfigurationService implements ConfigurationService, Disposable {
  final Realm realm;
  final AppStore appStore;
  late final RxDisposer disposer;

  RealmConfigurationService(this.realm, this.appStore);

  @override
  void init() {
    final model = _getConfiguration();
    appStore.themeMode.value = _getThemeModeByName(model.themeModeName);
    appStore.syncDate.value = model.syncDate;

    disposer = rxObserver(() {
      final themeMode = appStore.themeMode.value;
      final syncDate = appStore.syncDate.value;

      _saveConfiguration(themeMode.name, syncDate);
    });
  }

  @override
  void deleteAll() {
    realm.deleteAll();
  }

  @override
  void dispose() {
    disposer();
  }

  ConfigurationModel _getConfiguration() {
    return realm.all<ConfigurationModel>().first;
  }

  void _saveConfiguration(String themeModeName, DateTime? syncDate) {
    final model = _getConfiguration();
    realm.write(() {
      model
        ..themeModeName = themeModeName
        ..syncDate = syncDate;
    });
  }

  ThemeMode _getThemeModeByName(String name) {
    return ThemeMode.values
        .firstWhere((mode) => mode.name.toUpperCase() == name.toUpperCase());
  }
}
  // final ConfigurationService _configurationService;

  // AppStore(this._configurationService) {
  //   init();
  // }

  // void init() {
  //   final model = _configurationService.getConfiguration();
  //   syncDate.value = model.syncDate;
  //   themeMode.value = _getThemeModeByName(model.themeModeName);
  // }

  // void save() {
  //   _configurationService.saveConfiguration(
  //     themeMode.value.name,
  //     syncDate.value,
  //   );
  // }

  // void changeThemeMode(ThemeMode? mode) {
  //   if (mode != null) {
  //     themeMode.value = mode;
  //     save();
  //   }
  // }

  // void setSyncDate(DateTime date) {
  //   syncDate.value = date;
  //   save();
  // }

  // void deleteAll() {
  //   _configurationService.deleteAll();
  // }
  

  
