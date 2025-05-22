import 'package:get/get.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/socket.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    //socket 连接初始化
    ConnManager.initSocket();
  }

  @override
  void onClose() {}

  toSearchPage() {
    Get.toNamed(AppRoutes.Search);
  }
}
