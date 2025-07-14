import 'package:get/get.dart';
import 'package:solitary_meet/pages/setting/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
