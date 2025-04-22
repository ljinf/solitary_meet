import 'package:get/get.dart';
import 'package:solitary_meet/pages/friend/friends_list/friend_list_controller.dart';

class FriendListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendListController());
  }
}
