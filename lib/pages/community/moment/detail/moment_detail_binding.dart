import 'package:get/get.dart';
import 'package:solitary_meet/pages/community/moment/detail/moment_detail_controller.dart';

class MomentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MomentDetailController());
  }
}
