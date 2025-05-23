import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/pages/conversation/conversation_controller.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/utils/conts.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final pageController = Get.find<ConversationController>();

  String curLoginUid = Global.userProfile?.userId ?? "";

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
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
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: const WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Obx(() => ListView.builder(
              itemBuilder: (ctx, index) {
                var friendId = '', avatar = '';
                if (pageController.conList[index].type == 0) {
                  var ids =
                      pageController.conList[index].conversationId!.split("-");
                  friendId = ids
                      .where((id) => id != Global.userProfile!.userId)
                      .toList()[0];

                  avatar =
                      Global.friendManager.friendAvatars[friendId] ?? defIcon;
                }

                String title =
                    Global.friendManager.friends[friendId]?.remark ?? '';

                return GestureDetector(
                  onTap: () => pageController.toChatPage(
                      pageController.conList[index].conversationId!,
                      friendId,
                      avatar,
                      title),
                  child: Obx(() => CustomConversation(
                        imageUrl: avatar,
                        title: title,
                        recentMsg: pageController.conList[index].recentMsg,
                      )),
                );
              },
              itemCount: pageController.conList.length,
            )),
      ),
    );
  }
}
