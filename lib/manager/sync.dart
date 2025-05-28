import 'package:easy_event_bus/easy_event_bus.dart';

import '../global.dart';

class SyncManager {
  ///从服务器同步好友信息
  static syncFriendList() async {
    await Global.friendManager.syncFriendList(loading: false);
    Global.friendManager.loadFriendListFromDB();
  }

  ///从服务器同步会话
  static Future<bool> syncConversationList() async {
    var more = await Global.conversationManager.syncConversationFromRemote();
    if (more) {
      await Global.conversationManager.loadConversationFromDB();
      return true;
    }

    return false;
  }

  ///从服务器同步历史消息
  static Future<bool> syncMsgList() async {
    var hasmore = await Global.msgManager.syncHistoryUserMsgList();
    if (hasmore) {
      //更新会话最近消息
      await Global.conversationManager.loadRecentMsg();

      //有新的消息更新会话列表
      EasyEventBus.fire('updateConversation', '');
    }

    return hasmore;
  }
}
