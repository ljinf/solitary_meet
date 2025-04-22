import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/services/services.dart';

import '../../router/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  void login() async {
    var params = {
      "email": emailController.text,
      "password": pwdController.text,
    };
    var resp = await UserAPI.login(params: params);
    if (resp != null) {
      Global.userProfile?.token = resp.token;
      var userInfo = await UserAPI.userInfo();
      if (userInfo != null) {
        userInfo.token = resp.token;
        Global.saveProfile(userInfo);
      }
      Get.offAllNamed(AppRoutes.Home);
    }
  }
}
