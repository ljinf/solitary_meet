import 'package:get/get.dart';
import 'package:solitary_meet/db/db_helper.dart';
import 'package:solitary_meet/manager/sync.dart';
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
    SyncManager.syncFriendList();

    //同步会话
    SyncManager.syncConversationList().then((res) {
      //同步会话的所有用户
      if (res.isNotEmpty) {
        SyncManager.syncConversationUsers(res);
      }
      //历史消息
      SyncManager.syncMsgList();
    });
  }

  @override
  void onClose() {
    dbHelp.close();
  }

  toSearchPage() {
    Get.toNamed(AppRoutes.Search);
  }
}
