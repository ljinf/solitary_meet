import 'package:get/get.dart';
import 'package:solitary_meet/pages/mine/profile/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
