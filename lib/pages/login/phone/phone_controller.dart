import 'package:get/get.dart';

import '../../../services/user.dart';
import '../../../utils/helper.dart';
import '../../../utils/message.dart';

class PhoneController extends GetxController {
  final tips = "获取验证码".obs;
  var seconds = 60;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void sendCode(String phone) async {
    if (tips.value == '获取验证码') {
      if (validatePhoneNumber(phone)) {
        /* var resp = await UserAPI.sendCode(params: {"phone": phone});
        if (resp == "success") {
          Message.showSuccess('短信验证码已发送');
          countdown(); //开始倒计时
        }*/
      }
    }
  }

  void login(String phone, String code) async {
    // var resp = await UserAPI.login(params: {
    //   "login_type": LoginTypePhone,
    //   "account": phone,
    //   "code": code,
    //   "channel": DIVICE_CHANNEL,
    //   "register_app_code": APP_VERSION,
    // });
  }

  // 倒计时60秒
  void countdown() async {
    if (seconds <= 0) {
      print('倒计时结束！');
      tips.value = "获取验证码";
      seconds = 60;
      return;
    }
    print('剩余时间: $seconds 秒');
    await Future.delayed(const Duration(seconds: 1)); // 等待一秒
    seconds--;
    tips.value = '${seconds}s';
    update();
    countdown(); // 递归调用，减少一秒
  }
}
