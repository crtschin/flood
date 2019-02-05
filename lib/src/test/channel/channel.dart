import 'dart:io';

import 'package:aqueduct/aqueduct.dart';

class DbConfig extends Configuration {
  DbConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration db;
}

class DbChannel extends ApplicationChannel {
  ManagedContext context;
  @override
  Future prepare() async {
    final config = DbConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        config.db.username,
        config.db.password,
        config.db.host,
        config.db.port,
        config.db.databaseName);

    context = ManagedContext(dataModel, persistentStore);
  }

  @override
  Controller get entryPoint {
    return Router();
  }
}
