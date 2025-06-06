import 'package:get/get.dart';
import 'package:solitary_meet/pages/community/moment/add/add_moment_controller.dart';

class AddMomentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddMomentController());
  }
}
