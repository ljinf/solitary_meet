import 'package:get/get.dart';
import 'package:solitary_meet/model/login_model.dart';
import 'package:solitary_meet/services/services.dart';

class ProfileController extends GetxController {
  late UserLoginResponseModel userInfo;

  @override
  void onInit() {
    super.onInit();
    userInfo = UserLoginResponseModel();
    userInfo.userId = Get.arguments['userId'];
    userInfo.avatar = Get.arguments['avatar'];
    userInfo.nickName = Get.arguments['nickName'];
  }

  @override
  void onReady() {
    super.onReady();
    getProfile();
  }

  void getProfile() async {
    var resp = await UserAPI.searchUserInfo({});
    if (resp != null) {
      userInfo = resp;
    }
  }
}
