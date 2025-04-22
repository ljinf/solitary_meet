import 'package:get/get.dart';
import 'package:solitary_meet/services/relation.dart';

import '../../../model/relationship_model.dart';
import '../../../router/app_pages.dart';
import '../../../utils/conts.dart';

class FriendListController extends GetxController {
  var friendList = <RelationshipModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getFriendList();
    super.onReady();
  }

  void getFriendList() async {
    var resp = await RelationAPI.getFriendList(
        params: {"relationship_type": relationshipFriend, "page_num": 1, "page_size": 200});
    if (resp != null) {
      friendList.clear();
      friendList.addAll(resp);
    }
  }

  void toProfilePage(int index) {
    var info = friendList[index];
    Get.toNamed(AppRoutes.Profile,
        arguments: {"userId": info.userId, "avatar": info.avatar, "nickName": info.nickName});
  }
}
