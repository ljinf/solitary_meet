import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/router/app_pages.dart';

import '../../../services/user.dart';
import '../../../utils/conts.dart';
import '../../../utils/helper.dart';
import '../../../utils/message.dart';

class PhoneController extends GetxController {
  final tips = "获取验证码".obs;
  var seconds = 60;

  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  void sendCode(String phone) async {
    if (tips.value == '获取验证码') {
      if (validatePhoneNumber(phone)) {
        var resp = await UserAPI.requestVerificationCode(
            params: {"account": phone, "account_type": 2});
        if (resp == "ok") {
          Message.showSuccess('短信验证码已发送');
          countdown(); //开始倒计时
        }
      }
    }
  }

  void login(String phone, String code) async {
    var resp = await UserAPI.login(params: {
      "account_type": accountTypePhone,
      "account": phone,
      "code": code,
      "channel": "",
      "app_version": "",
    });
    if (resp == null) {
      codeController.clear();
    }

    if (resp != null) {
      seconds=0;
      Global.saveProfile(resp);
      if (!(resp.initInfo ?? false)) {
        Get.offAllNamed(AppRoutes.InitInfo);
      } else {
        Get.offAllNamed(AppRoutes.Home);
      }
    }
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
