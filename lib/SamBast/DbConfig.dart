// basically same as the io runner but with extra output
import 'dart:async';

import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DbConfig {
  Future<Database> database() async {
    return await databaseFactoryIo.openDatabase(
        join(".dart_tool", "sembast", "example", "record_demo.db"));
  }
}
