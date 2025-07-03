import 'package:get/get.dart';
import 'package:solitary_meet/pages/login/phone/phone_controller.dart';

class PhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhoneController());
  }
}
