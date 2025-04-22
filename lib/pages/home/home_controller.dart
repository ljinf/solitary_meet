import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/pages/conversation/conversation_view.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/socket.dart';

class HomeController extends GetxController {
  var topNavigationTitles = ['推荐', '最新', '关注'];
  var bottomNavigationTitles = ['广场', '心愿', '消息', '我的'];
  var selectedIndex = 0.obs;

  var currentTopNavigationIndex = 0.obs;
  late PageController pageController;

  var pages = <Widget>[];

  @override
  void onInit() {
    super.onInit();

    pages.add(const Center(
      child: Text("1"),
    ));
    pages.add(const Center(
      child: Text("2"),
    ));
    pages.add(ConversationPage());
    pages.add(const Center(
      child: Text("3"),
    ));

    pageController = PageController(
      initialPage: selectedIndex.value,
      // keepPage: true,
    );
  }

  @override
  void onReady() {
    //socket 连接初始化
    ConnManager.initSocket();
  }

  @override
  void onClose() {}

  updateTopNavigation(int index) {
    update();
    currentTopNavigationIndex.value = index;
  }

  updateBottomNavigation(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
    update();
  }

  toSearchPage() {
    Get.toNamed(AppRoutes.Search);
  }
}
