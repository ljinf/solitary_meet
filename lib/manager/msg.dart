import 'package:flutter/cupertino.dart';
import 'package:solitary_meet/db/db_helper.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/model/msg_model.dart';
import 'package:solitary_meet/services/chat.dart';

const String _userAction = 'user';
const String _convAction = 'conv';

class MsgManager {
  ///用户消息链的max seq
  var userMaxSeq = 0;

  Future<void> init() async {
    var userId = Global.userProfile!.userId ?? '';
    if (userId != '') {
      userMaxSeq = await dbHelp.getUserMaxSeq(userId);
    }
  }

  ///获取会话消息
  Future<List<MsgModel>> getMsgList(String conversationId, int seq) async {
    return await dbHelp.loadMsgList(conversationId, seq);
  }

  ///保存消息
  Future<bool> saveMsg(List<MsgModel> list) async {
    return await dbHelp.saveMsgToDB(list, Global.userProfile!.userId ?? '');
  }

  ///根据用户消息链，从服务端同步历史消息
  Future<bool> syncHistoryUserMsgList() async {
    int seq = userMaxSeq, limit = 200;
    //是否新的消息
    bool hasMore = true;

    do {
      hasMore = false;
      var result = await _doSyncMsgList(_userAction, {
        "seq": seq,
        "limit": limit,
      });
      if (result != null) {
        if ((result['total'] ?? 0) > limit) {
          hasMore = true;
        }
        List<MsgModel> list = result['list'] ?? [];
        //升序
        list.sort((a, b) => a.seq!.compareTo(b.seq!));
        if (list.isNotEmpty) {
          seq = list[list.length - 1].seq ?? seq;
        }

        dbHelp.saveMsgToDB(list, Global.userProfile!.userId ?? '');
      }
    } while (hasMore);
    //是否更新
    bool isUpdate = userMaxSeq == seq;
    //更新序列号
    userMaxSeq = seq;
    debugPrint("syncHistoryUserMsgList finish......");
    return isUpdate;
  }

  ///会话消息，从服务端获取会话消息
  Future<void> getHistoryConvMsgList(
      String conversationId, int seq, int limit) async {
    var result = await _doSyncMsgList(_userAction, {
      "conversation_id": conversationId,
      "seq": seq,
      "limit": limit,
    });
    if (result != null) {
      dbHelp.saveMsgToDB(
          result['list'] ?? [], Global.userProfile!.userId ?? '');
    }
  }

  Future<Map<String, dynamic>> _doSyncMsgList(String action, Map params) async {
    switch (action) {
      case _userAction:
        return ChatAPI.getChatHistoryMsgList(params: params);
      case _convAction:
        return ChatAPI.getConversationMsgList(params: params);
    }
    return {"total": 0};
  }
}
