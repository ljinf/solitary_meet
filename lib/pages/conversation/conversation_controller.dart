import 'package:get/get.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/manager/sync.dart';
import 'package:solitary_meet/model/msg_model.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/socket.dart';

import '../../model/conversation_model.dart';
import '../../utils/conts.dart';

class ConversationController extends GetxController implements MessageCallBack {
  var conversationManager = Global.conversationManager;
  var conList = <ConversationModel>[].obs;

  //收取中
  bool collecting = false;

  @override
  void onInit() {
    getConversationList();
    ConnManager.addListener(conversationPage, this);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void getConversationList() async {
    conList.clear();
    conList.addAll(Global.conversationManager.conList);
    update(conList);
  }

  //同步会话
  void syncConversation() async {
    collecting = true;
    try {
      if (await SyncManager.syncConversationList()) {
        getConversationList();
      }
    } finally {
      collecting = false;
    }
  }

  void refreshConversationList() async {
    getConversationList();
  }

  void toChatPage(
      String conversationId, String userId, String avatar, String title) {
    Get.toNamed(AppRoutes.Chat, arguments: {
      "conversation_id": conversationId,
      "user_id": userId,
      "avatar": avatar,
      "title": title
    });
  }

  @override
  void onMessage(MsgModel msg) {
    print("conversation calback");

    Global.msgManager.saveMsg([msg]).then((success) {
      if (success) {
        Global.conversationManager
            .setConvRecentMsg(msg.conversationId ?? '', msg);
        Global.conversationManager
            .setConvSeq(msg.conversationId ?? '', msg.seq ?? 0);

        getConversationList();
      }
    });
  }
}
