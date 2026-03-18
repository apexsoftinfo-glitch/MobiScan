import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

@InjectableInit(
  initializerName: 'init',
  asExtension: true,
)
Future<void> configureDependencies() async {
  await getIt.init();
}
