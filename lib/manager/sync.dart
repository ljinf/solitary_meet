import '../global.dart';

class SyncManager {
  //从服务器同步好友信息
  static syncFriendList() async {
    await Global.friendManager.syncFriendList(loading: false);
    Global.friendManager.loadFriendListFromDB();
  }

  //从服务器同步会话
  static syncConversationList() async {
    var more = await Global.conversationManager.syncConversationFromRemote();
    if (more) {
      await Global.conversationManager.loadConversationFromDB();
    }
  }
}
