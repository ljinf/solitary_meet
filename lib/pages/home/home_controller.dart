import 'package:get/get.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/socket.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    //socket 连接初始化
    ConnManager.initSocket();

    //好友信息
    loadFriendList();

  }

  @override
  void onClose() {}

  toSearchPage() {
    Get.toNamed(AppRoutes.Search);
  }

  void loadFriendList() async {
    if (Global.friendManager.friends.values.isEmpty) {
      await Global.friendManager.syncFriendList(loading: false);
      Global.friendManager.loadFriendListFromDB();
    }
  }
}
