import 'package:solitary_meet/pages/Index/Index_controller.dart';
import 'package:get/get.dart';

import '../login/login_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndexController>(() => IndexController());
  }
}
