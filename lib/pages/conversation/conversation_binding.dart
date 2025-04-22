import 'package:get/get.dart';
import 'package:solitary_meet/pages/conversation/conversation_controller.dart';

class ConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationController>(() => ConversationController());
  }
}
