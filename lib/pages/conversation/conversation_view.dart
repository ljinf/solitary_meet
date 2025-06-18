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
import '../../components/observable_List.dart';
import '../../manager/sync.dart';
import '../../model/conversation_model.dart';
import '../../model/msg_model.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    with AutomaticKeepAliveClientMixin {
  final pageController = Get.find<ConversationController>();

  var conList = <ConversationModel>[];

  String curLoginUid = Global.userProfile?.userId ?? "";

  late Timer timer;
  var networkConnected = true;

  @override
  void initState() {
    getList();
    EasyEventBus.on(updateConversationPrefix, (event) async {
      if (event != null) {
        updateList(event);
      }
      reorder(event.conversationId ?? '');
    });
    checkNetwork();
    super.initState();
  }

  void getList() {
    conList.clear();
    conList.addAll(pageController.getConversationList());
    initConversation();
  }

  void updateList(MsgModel msg) async {
    ///消息会话是否存在
    var exist = pageController.conversationManager
        .isExistConv(msg.conversationId ?? '');
    if (exist) {
      debugPrint("---------------有新的消息......");
      EasyEventBus.fire(
          '$updateConversationRecentMsgPrefix${msg.conversationId ?? ''}',
          null);
    } else {
      ///从服务器同步
      debugPrint("---------------有新的会话......");
      //同步会话
      SyncManager.syncConversationList().then((res) {
        //同步会话的所有用户
        if (res.isNotEmpty) {
          SyncManager.syncConversationUsers(res).then((v) {
            getList();
          });
        }
      });
    }
  }

  ///排序
  void initConversation() {
    conList.sort((a, b) {
      var aTime = pageController
              .conversationManager.recentMsg[a.conversationId]!.sendTime ??
          0;
      var bTime = pageController
              .conversationManager.recentMsg[b.conversationId]!.sendTime ??
          0;

      if (aTime > bTime) {
        return 0;
      }
      return 1;
    });
    setState(() {});
  }

  ///重排
  void reorder(String convid) {
    debugPrint("---------------reorder---------------");
    setState(() {
      var index = conList.indexWhere((v) => v.conversationId == convid);
      if (index > -1) {
        var element = conList.removeAt(index);
        conList.insert(0, element);
      }
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

  //页面缓存
  @override
  bool get wantKeepAlive => true;

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
                var friendId = '';
                if (conList[index].type == 0) {
                  var ids = conList[index].conversationId!.split("-");
                  friendId = ids
                      .where((id) => id != Global.userProfile!.userId)
                      .toList()[0];
                }

                return ConversationItem(
                  conversationId: conList[index].conversationId ?? '',
                  friendId: friendId,
                  key: Key(conList[index].conversationId ?? ''),
                );
              },
              itemCount: conList.length,
            ),
          ),
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

class ConversationItem extends StatefulWidget {
  String conversationId;
  String friendId;

  ConversationItem(
      {required this.conversationId, required this.friendId, super.key});

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  final pageController = Get.find<ConversationController>();
  var listenerKey = "";

  String avatar = defAvatar;
  String title = "";

  MsgModel? recentMsg; //最新消息
  int readSeq = 0; //已读序列号

  @override
  void initState() {
    listenerKey = '$updateConversationRecentMsgPrefix${widget.conversationId}';
    listener();
    initInfo();
    updateMsg();
    super.initState();
  }

  void listener() {
    EasyEventBus.on(listenerKey, (event) {
      updateMsg();
    });
  }

  @override
  void dispose() {
    EasyEventBus.cancel(listenerKey);
    super.dispose();
  }

  void initInfo() async {
    pageController.conversationManager
        .loadConvUserInfo(widget.conversationId ?? '', widget.friendId)
        .then((info) {
      if (info != null) {
        setState(() {
          avatar = info.avatar == '' ? defAvatar : info.avatar ?? defAvatar;
          title = info.nickName ?? '';
        });
      }
    });
  }

  void updateMsg() {
    setState(() {
      updateRecent();
      updateSeq();
    });
  }

  void updateRecent() {
    recentMsg =
        pageController.conversationManager.recentMsg[widget.conversationId];
  }

  void updateSeq() {
    readSeq = pageController
            .conversationManager.conList[widget.conversationId]!.lastReadSeq ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pageController.updateReadSeq(
            widget.conversationId,
            pageController.conversationManager
                .getRecentMsgSeq(widget.conversationId));
        updateSeq();

        pageController.toChatPage(
            widget.conversationId, widget.friendId, avatar, title);
      },
      child: CustomConversation(
        convId: widget.conversationId,
        friendId: widget.friendId,
        imageUrl: avatar,
        title: title,
        recentMsg: recentMsg,
        readSeq: readSeq,
      ),
    );
  }
}
