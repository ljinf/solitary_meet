import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:solitary_meet/pages/conversation/conversation_controller.dart';
import 'package:solitary_meet/pages/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  double iconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: BrnAppBar(
      //   themeData: BrnAppBarConfig.dark(),
      //   //自定义leading
      //   leading: BrnBackLeading(
      //     child: Image.asset(
      //       'assets/images/def_avatar.jpg',
      //       scale: 3.0,
      //       height: 80,
      //       width: 80,
      //     ),
      //   ),
      //   title: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       _buildTab(0),
      //       const SizedBox(
      //         width: 24,
      //       ),
      //       _buildTab(1),
      //       const SizedBox(
      //         width: 24,
      //       ),
      //       _buildTab(2)
      //     ],
      //   ),
      //   actions: BrnIconAction(
      //     child: const Icon(Icons.search, size: 20),
      //     iconPressed: () {
      //       controller.toSearchPage();
      //     },
      //   ),
      // ),
      body: PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return controller.pages[index];
        },
        itemCount: controller.bottomNavigationTitles.length,
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          controller.updateBottomNavigation(index);
        },
      ),
      bottomNavigationBar: Obx(() {
        return BrnBottomTabBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (int index) {
            controller.updateBottomNavigation(index);
          },
          fixedColor: Colors.blue,
          badgeColor: Colors.red,
          items: [
            BrnBottomTabBarItem(
                icon:
                    Image(width: iconSize, height: iconSize, image: AssetImage("assets/images/tabbar_discover_c.webp")),
                activeIcon:
                    Image(width: iconSize, height: iconSize, image: AssetImage("assets/images/tabbar_discover_s.webp")),
                title: Text(controller.bottomNavigationTitles[0])),
            BrnBottomTabBarItem(
                icon:
                    Image(width: iconSize, height: iconSize, image: AssetImage("assets/images/tabbar_contacts_c.webp")),
                activeIcon:
                    Image(width: iconSize, height: iconSize, image: AssetImage("assets/images/tabbar_contacts_s.webp")),
                title: Text(controller.bottomNavigationTitles[1])),
            BrnBottomTabBarItem(
                icon: Image(width: iconSize, height: iconSize, image: AssetImage("assets/images/tabbar_chat_c.webp")),
                activeIcon:
                    Image(width: iconSize, height: iconSize, image: AssetImage("assets/images/tabbar_chat_s.webp")),
                title: Text(controller.bottomNavigationTitles[2])),
            BrnBottomTabBarItem(
                icon: Image(width: iconSize, height: iconSize, image: AssetImage("assets/images/tabbar_me_c.webp")),
                activeIcon:
                    Image(width: iconSize, height: iconSize, image: AssetImage("assets/images/tabbar_me_s.webp")),
                title: Text(controller.bottomNavigationTitles[3])),
          ],
        );
      }),
    );
  }

  Widget _buildTab(int index) {
    return GestureDetector(
      onTap: () {
        controller.updateTopNavigation(index);
      },
      child: Obx(() => Text(
            controller.topNavigationTitles[index],
            style: controller.currentTopNavigationIndex.value == index
                ? const TextStyle(color: Colors.white)
                : const TextStyle(color: Colors.grey),
          )),
    );
  }
}
