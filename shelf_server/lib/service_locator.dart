import 'package:get_it/get_it.dart';
import 'package:shelf_server/database/postgres.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<Database>(() => Database());
}
