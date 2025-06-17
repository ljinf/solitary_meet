import 'package:easy_event_bus/easy_event_bus.dart';

import '../global.dart';

class SyncManager {
  ///从服务器同步好友信息
  static syncFriendList() async {
    await Global.friendManager.syncFriendList(loading: false);
    Global.friendManager.loadFriendListFromDB();
  }

  ///从服务器同步会话，返回新会话Id list
  static Future<List<String>> syncConversationList() async {
    var more = await Global.conversationManager.syncConversationFromRemote();
    if (more.isNotEmpty) {
      await Global.conversationManager.loadConversationFromDB();
    }

    return more;
  }

  ///从服务器同步会话所有用户
  static Future<void> syncConversationUsers(List<String> cids) async {
    if (cids.isNotEmpty) {
      await Global.conversationManager.syncConvUsersFromRemote(cids);
    }
  }

  ///从服务器同步历史消息
  static Future<bool> syncMsgList() async {
    var hasmore = await Global.msgManager.syncHistoryUserMsgList();
    if (hasmore) {
      //更新会话最近消息
      await Global.conversationManager.loadRecentMsg();

      //有新的消息更新会话列表
      EasyEventBus.fire('updateConversation', null);
    }

    return hasmore;
  }
}
