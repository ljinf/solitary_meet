import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/model/msg_model.dart';
import 'package:solitary_meet/services/chat.dart';
import 'package:solitary_meet/services/socket.dart';

import '../../utils/conts.dart';

class ChatController extends GetxController implements MessageCallBack {
  var msgList = <MsgModel>[].obs;

//当前用户id
  String curUid = Global.userProfile?.userId ?? "";
  late String convId, friendId; //对方的id
  late String title, avatar;
  int seq = 0, pageSize = 30;

  ScrollController scrollController = ScrollController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode(); // 初始化一个FocusNode控件

  @override
  void onInit() {
    super.onInit();
    convId = Get.arguments['conversation_id'];
    friendId = Get.arguments['user_id'];
    title = Get.arguments['title'];
    avatar = Get.arguments['avatar'];
    loadMsgList();
  }

  @override
  void onReady() {
    super.onReady();
    ConnManager.addListener(convId, this);
    focusNode.addListener(_focusNodeListener);
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    refreshController.dispose();
    textController.dispose();
    ConnManager.remListener(convId);
    focusNode.removeListener(_focusNodeListener);
  }

  void loadMsgList() async {
    var result = await Global.msgManager.getMsgList(convId, seq);
    if (result.isNotEmpty) {
      msgList.addAll(result.reversed.toList());
      seq = msgList[0].seq!;
    }
    update(msgList);
    jumpToBottom();
  }

  void onRefresh() async {
    loadMsgList();
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
  }

  void onTxtChange(String text) {}

  void sendMsg() async {
    String txtData = textController.text;
    if (txtData == "") {
      EasyLoading.showToast("请输入内容");
      return;
    }

    var chatData = {
      "conversation_id": convId,
      "target_id": friendId,
      "content": txtData,
      "content_type": contentTypeTxt,
    };
    var resp = await ChatAPI.sendMsg(params: chatData);
    if (resp != null) {
      msgList.add(resp);
    }
    textController.clear();
    scrollToBottom();
  }

  @override
  void onMessage(MsgModel msg) {
    print('message callback and msg add to list');
    msgList.add(msg);
    update(msgList);
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void jumpToBottom() {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  Future<void> _focusNodeListener() async {
    // scrollToBottom();
  }
}
