import 'package:get/get.dart';

import '../../../../model/community.dart';

class MomentDetailController extends GetxController {
  late MomentModel moment;

  @override
  void onInit() {
    moment = Get.arguments['moment'];
    super.onInit();
  }
}
