import 'package:flutter/cupertino.dart';
import 'package:solitary_meet/global.dart';

import '../db/db_helper.dart';
import '../model/relationship_model.dart';
import '../services/relation.dart';
import '../utils/conts.dart';

class FriendManager {
  var friends = <String, RelationshipModel>{}; //userId-RelationshipModel

  //好友头像
  var friendAvatars = <String, String>{}; //userId-avatarUrl

  void init() {
    loadFriendListFromDB();
  }

  void loadFriendListFromDB() async {
    friendAvatars.clear();
    friends.clear();
    var list = await dbHelp.loadFriendList(Global.userProfile!.userId ?? '');
    for (var item in list) {
      friendAvatars[item.friendId!] = item.avatar ?? '';
      friends[item.friendId!] = item;
    }
  }

  //同步好友列表
  Future<void> syncFriendList({bool loading = true}) async {
    var pageNum = 1, pageSize = 200;
    int num = 1;
    //是否已计算页数
    bool gotPage = false;
    do {
      var resp = await _doSyncFromRemote(pageNum, pageSize);
      if (resp != null) {
        pageNum++;

        //计算页数
        if (!gotPage) {
          gotPage = true;
          var total = resp['total'] ?? 0;
          //总页数
          num = (total / pageSize).toInt();
          if ((total % pageSize) > 0) {
            num += 1;
          }
        }

        /* for (var item in resp['list'] ?? []) {
          friendAvatars[item.userId!] = item.avatar ?? '';
          friends[item.userId!] = item;
        }*/

        dbHelp.saveFriendToDB(resp['list'] ?? []);
      }
    } while (pageNum <= num);
    debugPrint("syncFriendList finish......");
  }

  Future<Map<String, dynamic>?> _doSyncFromRemote(int pageNum, int pageSize,
      {bool loading = true}) async {
    return await RelationAPI.getFriendList(params: {
      "relationship_type": relationshipFriend,
      "page_num": pageNum,
      "page_size": pageSize
    }, loading: loading);
  }
}
