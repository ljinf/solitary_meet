import 'package:get/get.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/model/msg_model.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/socket.dart';

import '../../model/conversation_model.dart';
import '../../utils/conts.dart';

class ConversationController extends GetxController implements MessageCallBack {
  var conList = <ConversationModel>[].obs;

  //收取中
  bool collecting = false;

  @override
  void onInit() {
    ConnManager.addListener(conversationPage, this);
    syncConversation();
    super.onInit();
  }

  @override
  void onReady() {
    getConversationList();
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
      var more = await Global.conversationManager.syncConversationFromRemote();
      if (more) {
        await Global.conversationManager.loadConversationFromDB();
        getConversationList();
      }
    } finally {
      collecting = false;
    }
  }

  void refreshConversationList() async {
    conList.clear();
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
    /* bool exist = false;
    ConversationModel? item;
    for (int i = 0; i < conList.length; i++) {
      if (conList[i].conversationId == msg.conversationId) {
        exist = true;
        item = conList[i];
        item.recentMsg = msg;
        conList.removeAt(i);
        break;
      }
    }
    if (exist) {
      conList.insert(0, item!);
    }*/
  }
}
