import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/services.dart';

import '../../model/login_model.dart';

class FindController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  var list = <UserLoginResponseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    focusNode.requestFocus();
    super.onReady();
  }

  void search() async {
    list.clear();
    var txt = textEditingController.text;
    if (txt == "") {
      return;
    }
    var resp = await UserAPI.searchUserInfo({"email": txt});
    if (resp != null) {
      list.add(resp);
    }
    update(list);
  }

  void toProfilePage(int index) {
    var info = list[index];
    Get.offAndToNamed(AppRoutes.Profile,
        arguments: {"userId": info.userId, "avatar": info.avatar, "nickName": info.nickName});
  }
}
