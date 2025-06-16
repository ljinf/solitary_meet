import 'dart:async';

import 'package:easy_event_bus/easy_event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/common/values/font.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/pages/conversation/conversation_controller.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/socket.dart';
import 'package:solitary_meet/utils/conts.dart';

import '../../components/custom_conversation.dart';
import '../../model/conversation_model.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final pageController = Get.find<ConversationController>();

  var conList = <ConversationModel>[];

  String curLoginUid = Global.userProfile?.userId ?? "";

  late Timer timer;
  var networkConnected = true;

  @override
  void initState() {
    getList();
    EasyEventBus.on('updateConversation', (event) {
      getList();
    });
    checkNetwork();
    super.initState();
  }

  void getList() {
    conList.clear();
    setState(() {
      conList.addAll(pageController.getConversationList());

      conList.sort((a, b) {
        var aTime = pageController
                .conversationManager.recentMsg[a.conversationId]!.sendTime ??
            0;
        var bTime = pageController
                .conversationManager.recentMsg[b.conversationId]!.sendTime ??
            0;

        if (aTime > bTime) {
          return 1;
        }
        return 0;
      });
    });
  }

  ///检查网络
  void checkNetwork() {
    // 每3秒执行一次
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      debugPrint("retry connect ${ConnManager.connStatus}");
      if (ConnManager.connStatus == ConnStatus.connected) {
        setState(() {
          networkConnected = true;
        });
      } else if (ConnManager.connStatus == ConnStatus.closed) {
        setState(() {
          networkConnected = false;
        });
      }
      if (ConnManager.connStatus == ConnStatus.closed) {
        ConnManager.retryConnect();
      }
    });
  }

  @override
  void dispose() {
    // 如果需要停止定时器
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        centerTitle: true,
        title: const Text("消息"),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.Friends);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 20),
              child: const Icon(Icons.people_alt_sharp),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          getNetworkStatusView(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                var friendId = '', avatar = '';
                if (conList[index].type == 0) {
                  var ids = conList[index].conversationId!.split("-");
                  friendId = ids
                      .where((id) => id != Global.userProfile!.userId)
                      .toList()[0];

                  Global.conversationManager
                      .loadConvAvatar(
                          conList[index].conversationId ?? '', friendId)
                      .then((s) {
                    avatar = s ?? defIcon;
                  });
                }

                String title =
                    Global.friendManager.friends[friendId]?.remark ?? '';

                return GestureDetector(
                  onTap: () {
                    pageController.updateReadSeq(
                        conList[index].conversationId ?? '',
                        pageController.conversationManager.getRecentMsgSeq(
                            conList[index].conversationId ?? ''));

                    pageController
                        .toChatPage(conList[index].conversationId!, friendId,
                            avatar, title)
                        .then((b) {
                      getList();
                    });
                  },
                  child: CustomConversation(
                    convId: conList[index].conversationId ?? '',
                    imageUrl: avatar,
                    title: title,
                    recentMsg: pageController.conversationManager
                        .recentMsg[conList[index].conversationId],
                    readSeq: pageController
                        .getReadSeq(conList[index].conversationId ?? ''),
                  ),
                );
              },
              itemCount: conList.length,
            ),
          )
        ],
      ),
    );
  }

  Widget getNetworkStatusView() {
    if (!networkConnected) {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFFe0e0e0),
        ),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 15.0,
              height: 15.0,
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              networkConnected ? '已连接' : '连接中...',
              style: const TextStyle(
                  color: Colors.black54, fontSize: AppFont.FontSize12),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
