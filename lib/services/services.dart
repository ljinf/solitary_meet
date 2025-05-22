library services;

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../utils/request.dart';

export 'user.dart';

void showLoading() {
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

Future<dynamic> doRequest(
  String path, {
  dynamic params,
  Options? options,
  bool loading = true,
}) async {
  if (loading) {
    showLoading();
  }
  bool catchErr = false;
  try {
    var response = await Request().post(
      path,
      params: params,
      options: options,
    );

    if (response != null && response['code'] != 0) {
      // 错误提示
      catchErr = true;
      EasyLoading.showInfo(response['message'].toString());
      return null;
    }
    return response;
  } catch (e) {
    catchErr = true;
    print(e);
  } finally {
    if (!catchErr && loading) {
      dismissLoading();
    }
  }
  return null;
}
