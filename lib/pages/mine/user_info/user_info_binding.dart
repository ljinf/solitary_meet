import 'package:get/get.dart';
import 'package:solitary_meet/pages/mine/user_info/user_info_controller.dart';

class UserInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserInfoController());
  }
}
