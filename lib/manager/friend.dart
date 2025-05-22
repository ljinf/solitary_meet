import '../db/db_helper.dart';
import '../model/relationship_model.dart';
import '../services/relation.dart';
import '../utils/conts.dart';

class FriendManager {
  var friends = <String, RelationshipModel>{}; //userId-RelationshipModel

  //好友头像
  var friendAvatars = <String, String>{}; //userId-avatarUrl

  FriendManager() {
    loadFriendListFromDB();
  }

  void loadFriendListFromDB() async {
    friendAvatars.clear();
    friends.clear();
    var list = await dbHelp.loadFriendList();
    for (var item in list) {
      friendAvatars[item.userId!] = item.avatar ?? '';
      friends[item.userId!] = item;
    }

    if (list.isEmpty) {
      syncFriendList(loading: false);
    }
  }

  //同步好友列表
  void syncFriendList({bool loading = true}) async {
    var pageNum = 1, pageSize = 200;
    var resp = await _doSyncFromRemote(pageNum, pageSize);
    if (resp != null) {
      for (var item in resp) {
        friendAvatars[item.userId!] = item.avatar ?? '';
        friends[item.userId!] = item;
      }
      dbHelp.saveFriendToDB(resp);
    }
  }

  Future<List<RelationshipModel>?> _doSyncFromRemote(int pageNum, int pageSize,
      {bool loading = true}) async {
    return await RelationAPI.getFriendList(params: {
      "relationship_type": relationshipFriend,
      "page_num": pageNum,
      "page_size": pageSize
    }, loading: loading);
  }
}
