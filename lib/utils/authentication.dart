import 'dart:async';
import 'package:solitary_meet/common/values/values.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/utils/utils.dart';
import 'package:get/get.dart';

import '../model/login_model.dart';

/// 检查是否有 token
Future<bool> isAuthenticated() async {
  var profileJSON = LocalStorage().getJSON(STORAGE_USER_PROFILE_KEY);
  return profileJSON != null ? true : false;
}

/// 删除缓存token
Future deleteAuthentication() async {
  await LocalStorage().remove(STORAGE_USER_PROFILE_KEY);
  Global.userProfile = UserLoginResponseModel(token: null);
}

/// 重新登录
void deleteTokenAndReLogin() async {
  await deleteAuthentication();
  Get.offAndToNamed('/login');
}
