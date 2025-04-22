library services;

import 'package:flutter_easyloading/flutter_easyloading.dart';

export 'user.dart';

void loading() {
  EasyLoading.show();
}

void dismissLoading() {
  EasyLoading.dismiss();
}

bool responseCheck(Map<String, dynamic> json) {
  if (json["code"] != 0) {
    EasyLoading.showError(json["message"]);
    return false;
  }
  return true;
}
