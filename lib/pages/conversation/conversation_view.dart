import 'dart:async';

import 'package:easy_event_bus/easy_event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/common/values/font.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/pages/conversation/conversation_controller.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/socket.dart';
import 'package:solitary_meet/utils/conts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../components/custom_conversation.dart';
import '../../components/observable_List.dart';
import '../../config.dart';
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
  var networkConnected = false;

  @override
  void initState() {
    checkNetwork();
    checkMsgCollected();
    EasyEventBus.on(updateConversationPrefix, (event) async {
      debugPrint("---------------更新会话EventBus......");
      if (event != null) {
        updateList(event);
        reorder(event.conversationId ?? '');
        return;
      }

      getList();
    });
    super.initState();
  }

  void getList() {
    if (pageController.collecting.value) {
      return;
    }
    conList.clear();
    conList.addAll(pageController.getConversationList());
    debugPrint('---------------conList:${conList.length}');
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
    if (conList.isEmpty) {
      return;
    }
    conList.sort((a, b) {
      var aTime = pageController
              .conversationManager.recentMsg[a.conversationId]?.sendTime ??
          0;
      var bTime = pageController
              .conversationManager.recentMsg[b.conversationId]?.sendTime ??
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
  void checkNetwork() async {
    EasyEventBus.on('network', (connected) {
      if (!connected) {
        setNetworkStatusView();
      }
    });

    // 间隔执行
    timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      setNetworkStatusView();
      if (ConnManager.connStatus == ConnStatus.closed) {
        ConnManager.retryConnect();
      }
    });
  }

  void setNetworkStatusView() {
    setState(() {
      if (ConnManager.connStatus == ConnStatus.connected) {
        networkConnected = true;
      } else if (ConnManager.connStatus == ConnStatus.closed) {
        networkConnected = false;
      }
    });
  }

  ///检查消息收取情况
  void checkMsgCollected() {
    if (pageController.collecting.value) {
      // 每1秒执行一次
      Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        debugPrint('---------------checkCollected');
        if (!pageController.collecting.value) {
          debugPrint('---------------checkCollected collecting=false');
          timer.cancel();
          getList();
        }
      });
    } else {
      getList();
    }
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
    return VisibilityDetector(
      key: const Key('conversationPage-key'),
      onVisibilityChanged: (visibilityInfo) {
        setNetworkStatusView();
      },
      child: Scaffold(
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
            Obx(
              () => pageController.collecting.value
                  ? collectView()
                  : contentView(),
            )
          ],
        ),
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

  Widget collectView() {
    return const Expanded(
        child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 2,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "收取中...",
            style:
                TextStyle(color: Colors.black54, fontSize: AppFont.FontSize14),
          ),
        ],
      ),
    ));
  }

  Widget contentView() {
    return Expanded(
      child: conList.isEmpty
          ? Center(
              child: Image.asset(
                "assets/images/empty.png",
                width: 128,
                height: 128,
              ),
            )
          : ListView.builder(
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
    );
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
          avatar = info.avatar == '' ? defAvatar : '$STATIC_HOST_DEV${info.avatar}' ?? defAvatar;
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
            .conversationManager.conList[widget.conversationId]?.lastReadSeq ??
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
