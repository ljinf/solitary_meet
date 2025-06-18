import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/model/msg_model.dart';
import 'package:solitary_meet/services/socket.dart';

import '../../utils/conts.dart';

class ChatController extends GetxController implements MessageCallBack {
  var msgList = <MsgModel>[].obs;

//当前用户id
  String curUid = Global.userProfile?.userId ?? "";
  late String convId, friendId; //对方的id
  late String title, avatar;
  int seq = 0, limit = 10;

  //是否首次加载，第一次加载信息不要太多，30条，方便滚动到底部
  bool isFirstLoad = true;

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
    title = Get.arguments['title'] ?? '';
    avatar = Get.arguments['avatar'] ?? '';
    loadMsgList(true);
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

  void loadMsgList(bool reversed,
      {bool toBottom = true,
      String direction = ">",
      String orderType = 'DESC'}) async {
    var result = await Global.msgManager
        .getMsgList(convId, seq, limit, direction, orderType);
    if (result.isNotEmpty) {
      var list = <MsgModel>[];
      if (reversed) {
        list = result.reversed.toList();
      } else {
        list = result;
      }

      switch (direction) {
        case ">":
          msgList.addAll(list);
          break;
        case "<":
          msgList.insertAll(0, list);
          break;
      }

      seq = msgList[0].seq!;
      update(msgList);
      if (toBottom) {
        jumpToBottom();
      }
    }
    if (isFirstLoad) {
      isFirstLoad = false;
      limit = 50;
    }
  }

  void onRefresh() async {
    loadMsgList(false, toBottom: false, direction: "<", orderType: "ASC");
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
      "client_id": "${DateTime.now().millisecond}",
      "conversation_id": convId,
      "user_id": curUid,
      "target_id": friendId,
      "content": txtData,
      "content_type": contentTypeTxt,
    };
    await ConnManager.sendJson(3, chatData);
    textController.clear();
  }

  @override
  void onMessage(MsgModel msg) {
    print('message callback and msg add to list');
    msgList.add(msg);
    update(msgList);
    scrollToBottom();

    //更新已读seq
    Global.conversationManager.setConvReadSeq(convId, msg.seq ?? 0);
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50)).then((_) {
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
