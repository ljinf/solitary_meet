import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/pages/chat/chat_controller.dart';

import '../../components/custom_appbar.dart';
import '../../components/custom_message.dart';
import '../../config.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  var controller = Get.find<ChatController>();

  String curUid = Global.userProfile?.userId ?? "";
  String uAvatar = Global.userProfile?.avatar ?? "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 页面尺寸改变时回调
  @override
  didChangeMetrics() {
    super.didChangeMetrics();
    // 在页面重新渲染完成之后，获取软键盘高度
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
      if (isKeyboardOpen) {
        var scrollController = controller.scrollController;
        // 减少对其他不可scroll包裹页面的键盘唤起
        var maxScrollExtent = (scrollController.hasClients ?? false)
            ? scrollController.position.maxScrollExtent
            : null;
        if (maxScrollExtent != null) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: Text(controller.title),
        brightness: Brightness.dark,
        backgroundColor: Colors.blue,
        leadingType: AppBarBackType.Back,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Obx(() => SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  onRefresh: controller.onRefresh,
                  header: const WaterDropHeader(
                    waterDropColor: Colors.blue,
                  ),
                  controller: controller.refreshController,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      String avatar = uAvatar;
                      bool isSelf = true;

                      if (curUid != controller.msgList[index].userId) {
                        avatar = controller.avatar ?? "";
                        isSelf = false;
                      }

                      var sendTime = controller.msgList[index].sendTime ?? 0;
                      if (index > 0) {
                        var preTime =
                            controller.msgList[index - 1].sendTime ?? 0;
                        //两分钟内不显示时间
                        if (sendTime - preTime <= 120) {
                          sendTime = 0;
                        }
                      }
                      return CustomMessage(
                        '$STATIC_HOST_DEV$avatar',
                        controller.msgList[index].content!,
                        controller.msgList[index].contentType!,
                        isSelf,
                        sendTime: sendTime,
                      );
                    },
                    itemCount: controller.msgList.length,
                  ),
                )),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: const BoxDecoration(color: Color(0xFFf9f7f7)),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Flexible(
                    child: Container(
                  height: 36,
                  margin: const EdgeInsets.only(right: 10),
                  child: TextField(
                    controller: controller.textController,
                    focusNode: controller.focusNode,
                    // onChanged: controller.onTxtChange,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                )),
                SizedBox(
                  width: 50,
                  height: 30,
                  child: TextButton(
                    style: ButtonStyle(
                        padding:
                            const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                                EdgeInsets.all(2)),
                        backgroundColor:
                            ButtonStyleButton.allOrNull<Color>(Colors.blue)),
                    onPressed: () {
                      controller.sendMsg();
                    },
                    child: const Text(
                      '发送',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
