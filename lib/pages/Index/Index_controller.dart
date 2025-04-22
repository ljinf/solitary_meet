import 'package:get/get.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/services.dart';

class IndexController extends GetxController {
  /// 是否离线登录
  bool isOfflineLogin = false;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    startCountdownTimer();
  }

  @override
  void onClose() {}

  // 展示欢迎页，倒计时1.5秒之后进入应用
  Future startCountdownTimer() async {
    var respUserInfo = await UserAPI.userInfo();
    if (respUserInfo != null) {
      respUserInfo.token = Global.userProfile?.token;
      Global.saveProfile(respUserInfo);
      isOfflineLogin = true;
    }

    await Future.delayed(const Duration(milliseconds: 1500), () async {
      if (isOfflineLogin) {
        Get.offAllNamed(AppRoutes.Home);
      } else {
        Get.offAndToNamed(AppRoutes.Login);
      }
    });
  }
}
