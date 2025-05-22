import 'package:get/get.dart';
import 'package:solitary_meet/model/msg_model.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/conversation.dart';
import 'package:solitary_meet/services/socket.dart';

import '../../model/conversation_model.dart';
import '../../utils/conts.dart';

class ConversationController extends GetxController implements MessageCallBack {
  var conList = <ConversationModel>[].obs;

  @override
  void onInit() {
    ConnManager.addListener(conversationPage, this);
    getConversationList();
    super.onInit();
  }

  void getConversationList() async {
    conList.clear();
    var resp = await ConversationAPI.getConversationList(params: {"page_num": 1, "page_size": 1000});
    if (resp != null) {
      conList.addAll(resp);
    }
    update(conList);
  }

  void refreshConversationList() async {
    conList.clear();
    getConversationList();
  }

  void toChatPage(String conversationId, String userId, String avatar, String title) {
    Get.toNamed(AppRoutes.Chat,
        arguments: {"conversation_id": conversationId, "user_id": userId, "avatar": avatar, "title": title});
  }

  @override
  void onMessage(MsgModel msg) {
    print("converstion calback");
    bool exist = false;
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
    }
  }
}
