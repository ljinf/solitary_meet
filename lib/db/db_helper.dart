import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:solitary_meet/model/conversation_model.dart';
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
    await db.execute(createConversationTableSql);
  }

  //加载好友列表
  Future<List<RelationshipModel>> loadFriendList(String userId) async {
    List<RelationshipModel> models = [];
    var dbClient = await db;
    var result = await dbClient!.rawQuery(
        "SELECT * FROM `relationship_list` WHERE `user_id`=? and `relationship_type`=1 and `status`!=3",
        [userId]);
    List list = result.toList();
    models.addAll(list.map((i) => RelationshipModel.fromDB(i)).toList());
    return models;
  }

  //保存好友信息
  void saveFriendToDB(List<RelationshipModel> list) async {
    var dbClient = await db;
    for (var item in list) {
      var rows = await dbClient!.insert(
        "relationship_list",
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint("insert into relationship_list 影响行数$rows");
    }
  }

  //加载会话列表
  Future<List<ConversationModel>> loadConversationList(String userId) async {
    List<ConversationModel> models = [];
    var dbClient = await db;
    var result = await dbClient!.rawQuery(
        "SELECT * FROM `user_conversation_list` WHERE `user_id`=? and `is_del`=0",
        [userId]);
    List list = result.toList();
    models.addAll(list.map((i) => ConversationModel.fromJson(i)).toList());
    return models;
  }

  //获取会话最大版本号
  Future<int> getConversationMaxVersion(String userId) async {
    var version = 0;
    var dbClient = await db;
    var result = await dbClient!.rawQuery(
        "SELECT max(`version`)as `version` FROM `user_conversation_list` WHERE `user_id`=?",
        [userId]);
    List list = result.toList();
    if (list.isNotEmpty) {
      version = list[0]['version'] ?? 0;
    }
    return version;
  }

  //保存会话信息
  void saveConversationToDB(List<ConversationModel> list) async {
    var dbClient = await db;
    for (var item in list) {
      var data = {
        "conversation_id": item.conversationId,
        "type": item.type,
        "user_id": item.userId,
        "last_read_seq": item.lastReadSeq,
        "notify_type": item.notifyType,
        "is_top": item.isTop,
        "version": item.version,
      };

      var rows = await dbClient!.insert(
        "user_conversation_list",
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint("insert into user_conversation_list 影响行数$rows");
    }
  }
}

/// 关系信息表
var createFriendTableSql = """
CREATE TABLE `relationship_list` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `user_id` varchar(32) NOT NULL,
  `friend_id` varchar(32) NOT NULL,
  `phone` varchar(11) DEFAULT(''),
  `email` varchar(64) DEFAULT(''),
  `nick_name` varchar(256) DEFAULT(''),
  `avatar` text null,
  `gender` tinyint(2) DEFAULT(1),
  `remark` varchar(64) DEFAULT(''),
  `relationship_type` tinyint(2) DEFAULT('1'),
  `status` tinyint(2) DEFAULT('1'),
  `extra` varchar(256) DEFAULT(''),
  `created_at` bigint(20) NULL,
  `updated_at` datetime NULL,
  `deleted_at` datetime NULL,
  UNIQUE (`user_id`,`friend_id`,`relationship_type`)
)
""";

/// 会话表
var createConversationTableSql = """
CREATE TABLE `user_conversation_list` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `conversation_id` varchar(64) NOT NULL,
  `type` tinyint(2) DEFAULT(0),
  `user_id` varchar(32) NOT NULL,
  `last_read_seq` INTEGER(11) DEFAULT(0),
  `notify_type` tinyint(2) DEFAULT(0),
  `is_top` tinyint(2) DEFAULT(0),
  `version` INTEGER(11) NOT NULL DEFAULT(1),
  `is_del` tinyint(2) DEFAULT(0),
  `created_at` bigint(20) NULL,
  UNIQUE (`user_id`,`conversation_id`)
)
""";
