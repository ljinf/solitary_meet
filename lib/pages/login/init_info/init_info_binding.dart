import 'package:get/get.dart';
import 'package:solitary_meet/pages/login/init_info/init_info_controller.dart';

class InitInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitInfoController());
  }
}
