import 'package:flutter/cupertino.dart';
import 'package:solitary_meet/db/db_helper.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/model/conversation_model.dart';
import 'package:solitary_meet/services/conversation.dart';

class ConversationManager {
  var maxVersion = 0; //会话版本号
  var conList = <ConversationModel>[];

  void init() {
    loadConversationFromDB();
  }

  Future<void> loadConversationFromDB() async {
    conList.clear();
    var result =
        await dbHelp.loadConversationList(Global.userProfile!.userId ?? '');
    if (result.isNotEmpty) {
      conList.addAll(result);
    }
    getConversationMaxVersion();
  }

  void getConversationMaxVersion() {
    dbHelp
        .getConversationMaxVersion(Global.userProfile!.userId ?? '')
        .then((result) {
      maxVersion = result;
    });
  }

  Future<bool> syncConversationFromRemote() async {
    int pageNum = 1, pageSize = 200;
    int num = 1;
    //是否新的会话
    bool hasMore = false;
    //是否已计算页数
    bool gotPage = false;
    do {
      var result = await _doSyncConversationList(maxVersion, pageNum, pageSize);
      if (result != null) {
        pageNum++;

        //计算页数
        if (!gotPage) {
          gotPage = true;
          var total = result['total'] ?? 0;
          if (total > 0) {
            hasMore = true;
          }
          //总页数
          num = (total / pageSize).toInt();
          if ((total % pageSize) > 0) {
            num += 1;
          }
        }

        dbHelp.saveConversationToDB(result['list'] ?? []);
      }
    } while (pageNum <= num);

    debugPrint("syncConversationFromRemote finish......");
    return hasMore;
  }

  Future<Map<String, dynamic>?> _doSyncConversationList(
      int version, int pageNum, int pageSize) async {
    var result = await ConversationAPI.getConversationList(params: {
      "page_num": pageNum,
      "page_size": pageSize,
      "version": version
    }, loading: false);

    return result;
  }
}
