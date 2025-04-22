import 'package:solitary_meet/pages/home/home_controller.dart';
import 'package:get/get.dart';

import '../conversation/conversation_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConversationController());

    Get.lazyPut<HomeController>(() => HomeController());
  }
}
