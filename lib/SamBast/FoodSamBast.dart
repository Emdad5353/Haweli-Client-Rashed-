// basically same as the io runner but with extra output
import 'dart:async';

import 'package:haweli/SamBast/DbConfig.dart';
import 'package:sembast/sembast.dart';

class FoodSamBast {
  Future foodTestFunc() async {
    var db = await DbConfig().database();
    var store = intMapStoreFactory.store("my_store");
    await db.transaction((txn) async {
      await store.add(txn, {
        'name': {'price': 10}
      });
      await store.add(txn, {'name': 'cat'});
    });
  }
}
