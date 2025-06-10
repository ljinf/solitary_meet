import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/pages/community/moment/moment_list_view.dart';
import 'package:solitary_meet/pages/home/home_controller.dart';
import '../../common/colors/colors.dart';
import '../../common/values/font.dart';
import '../../common/values/image.dart';
import '../conversation/conversation_view.dart';
import '../mine/mine_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = Get.find<HomeController>();

  // var bottomNavigationTitles = ['广场', '心愿', '消息', '我的'];
  var bottomNavigationTitles = ['xx', 'xx', '消息', 'xx'];
  late PageController pageController;

  var pages = <Widget>[];

  int selectedIndex = 0;

  @override
  void initState() {
    pages.add(MomentPage());
    pages.add(const Center(
      child: Text("2"),
    ));
    pages.add(ConversationPage());
    pages.add(MinePage());

    pageController = PageController(
      initialPage: selectedIndex,
      // keepPage: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return pages[index];
        },
        itemCount: bottomNavigationTitles.length,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
            pageController.jumpToPage(selectedIndex);
          });
        },
        unselectedItemColor: AppColors.navUnselectedColor,
        selectedItemColor: AppColors.navSelectedColor,
        unselectedFontSize: AppFont.navFontSize,
        selectedFontSize: AppFont.navFontSize,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/tabbar_me_c.webp",
                width: AppImage.navImageSize,
                height: AppImage.navImageSize,
              ),
              activeIcon: Image.asset(
                "assets/icons/tabbar_me_c.webp",
                width: AppImage.navImageSize,
                height: AppImage.navImageSize,
              ),
              label: bottomNavigationTitles[0],
              tooltip: bottomNavigationTitles[0]),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/tabbar_me_c.webp",
                width: AppImage.navImageSize,
                height: AppImage.navImageSize,
              ),
              activeIcon: Image.asset(
                "assets/icons/tabbar_me_c.webp",
                width: AppImage.navImageSize,
                height: AppImage.navImageSize,
              ),
              label: bottomNavigationTitles[1],
              tooltip: bottomNavigationTitles[1]),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/tabbar_me_c.webp",
                width: AppImage.navImageSize,
                height: AppImage.navImageSize,
              ),
              activeIcon: Image.asset(
                "assets/icons/tabbar_me_c.webp",
                width: AppImage.navImageSize,
                height: AppImage.navImageSize,
              ),
              label: bottomNavigationTitles[2],
              tooltip: bottomNavigationTitles[2]),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/tabbar_me_c.webp",
                width: AppImage.navImageSize,
                height: AppImage.navImageSize,
              ),
              activeIcon: Image.asset(
                "assets/icons/tabbar_me_c.webp",
                width: AppImage.navImageSize,
                height: AppImage.navImageSize,
              ),
              label: bottomNavigationTitles[3],
              tooltip: bottomNavigationTitles[3]),
        ],
      ),
    );
  }
}
