import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/relationship_model.dart';

var dbHelp = Dbhelper();

class Dbhelper {
  // 单例
  Dbhelper._internal();

  static final Dbhelper _singleton = Dbhelper._internal();

  factory Dbhelper() => _singleton;

  Database? _db;

  /// 获取数据库
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();
    return _db;
  }

  _initDb() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'meet.db');
    debugPrint(path);
    // open the database
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(createFriendTableSql);
  }

  //加载好友列表
  Future<List<RelationshipModel>> loadFriendList() async {
    List<RelationshipModel> models = [];
    var dbClient = await db;
    var result = await dbClient!
        .rawQuery("SELECT * FROM `relationship_list` WHERE `status`!=3");
    List list = result.toList();
    models.addAll(list.map((i) => RelationshipModel.fromJson(i)).toList());
    return models;
  }

  //保存好友信息
  void saveFriendToDB(List<RelationshipModel> list) async {
    var dbClient = await db;
    for (var item in list) {
      await dbClient!.insert(
        "relationship_list",
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}

/// 关系信息表
var createFriendTableSql = """
CREATE TABLE `relationship_list` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `user_id` bigint(20) NOT NULL ,
  `target_id` bigint(20) NOT NULL  ,
  `remark` varchar(64) DEFAULT('')  ,
  `relationship_type` tinyint(2) DEFAULT('1'),
  `status` tinyint(2) DEFAULT('1'),
  `extra` varchar(256) DEFAULT('') ,
  `created_at` bigint(20) NULL ,
  `updated_at` datetime NULL,
  `deleted_at` datetime NULL,
  UNIQUE (`user_id`,`target_id`,`relationship_type`)
)
""";
