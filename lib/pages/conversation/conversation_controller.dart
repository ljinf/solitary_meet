import 'package:easy_event_bus/easy_event_bus.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/model/msg_model.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/socket.dart';

import '../../model/conversation_model.dart';
import '../../utils/conts.dart';

class ConversationController extends GetxController implements MessageCallBack {
  var conversationManager = Global.conversationManager;

  //收取中
  bool collecting = false;

  @override
  void onInit() {
    ConnManager.addListener(conversationPage, this);
    super.onInit();
  }

  List<ConversationModel> getConversationList() {
    return Global.conversationManager.conList.values.toList();
  }

  Future<bool> toChatPage(
      String conversationId, String userId, String avatar, String title) async {
    await Get.toNamed(AppRoutes.Chat, arguments: {
      "conversation_id": conversationId,
      "user_id": userId,
      "avatar": avatar,
      "title": title
    });
    return true;
  }

  int getReadSeq(String conversationId) {
    return Global.conversationManager.conList[conversationId]!.lastReadSeq ?? 0;
  }

  void updateReadSeq(String conversationId, int seq) async {
    Global.conversationManager.setConvReadSeq(conversationId, seq);
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

        EasyEventBus.fire('updateConversation', msg);
      }
    });
  }
}
