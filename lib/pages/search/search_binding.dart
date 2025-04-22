import 'package:get/get.dart';
import 'package:solitary_meet/pages/search/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FindController>(() => FindController());
  }
}
