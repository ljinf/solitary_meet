import 'package:flutter/cupertino.dart';
import 'package:solitary_meet/db/db_helper.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/model/conversation_model.dart';
import 'package:solitary_meet/model/msg_model.dart';
import 'package:solitary_meet/services/conversation.dart';

class ConversationManager {
  var maxVersion = 0; //会话版本号
  //会话列表
  var conList = <String, ConversationModel>{};

  //会话最新一条消息
  var recentMsg = <String, MsgModel>{};

  //会话最新的消息序列号
  var _convSeq = <String, int>{};

  //会话头像
  var _convAvatars = <String, String>{};

  void init() {
    loadConversationFromDB();
  }

  Future<void> loadConversationFromDB() async {
    var result =
        await dbHelp.loadConversationList(Global.userProfile!.userId ?? '');
    if (result.isNotEmpty) {
      for (var item in result) {
        conList[item.conversationId ?? ''] = item;
      }
    }
    loadRecentMsg();
    getConversationMaxVersion();
  }

  Future<void> loadRecentMsg() async {
    for (var item in conList.keys) {
      var msg = await dbHelp.loadRecentMsg(item);
      if (msg != null) {
        recentMsg[item] = msg;
        _convSeq[item] = msg.seq ?? 0;
      }
    }
  }

  ///获取消息序列号
  int getRecentMsgSeq(String convId) {
    var msg = recentMsg[convId];
    if (msg != null) {
      return msg.seq ?? 0;
    }
    return 0;
  }

  ///会话最大版本号
  void getConversationMaxVersion() {
    dbHelp
        .getConversationMaxVersion(Global.userProfile!.userId ?? '')
        .then((result) {
      maxVersion = result;
    });
  }

  ///更新会话最近消息
  void setConvRecentMsg(String conversationId, MsgModel msg) {
    recentMsg[conversationId] = msg;
  }

  ///更新会话的消息序列号
  void setConvSeq(String conversationId, int seq) {
    _convSeq[conversationId] = seq;
  }

  ///更新会话已读消息序列号
  void setConvReadSeq(String conversationId, int seq) {
    if ((conList[conversationId]!.lastReadSeq ?? 0) < seq) {
      conList[conversationId]!.lastReadSeq = seq;
    }

    dbHelp.setConversationReadSeq(
        conversationId, Global.userProfile!.userId ?? '', seq);
  }

  ///从服务器同步会话
  Future<List<String>> syncConversationFromRemote() async {
    int pageNum = 1, pageSize = 200;
    int num = 1;
    //是否新的会话
    bool hasMore = false;
    //是否已计算页数
    bool gotPage = false;
    //新会话的ids
    var newsConv = <String>[];
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
        var cids = await dbHelp.saveConversationToDB(result['list'] ?? []);
        newsConv.addAll(cids);
      }
    } while (pageNum <= num);

    debugPrint("syncConversationFromRemote finish......");
    return newsConv;
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

  ///从服务器同步会话的用户
  Future<void> syncConvUsersFromRemote(List<String> conIds) async {
    for (var item in conIds) {
      var result = await ConversationAPI.getConversationUsers(params: {
        "conversation_id": item,
      }, loading: false);

      await dbHelp.saveConversationUser(item, result);
    }
  }

  ///加载会话avatar
  Future<String> loadConvAvatar(String convId, String userId) async {
    return await dbHelp.getConversationAvatar(convId, userId);
  }
}
