import 'package:flutter_easyloading/flutter_easyloading.dart';

class Message {
  static void showLoading({String? status}) {
    EasyLoading.show(status: status);
  }

  static void closeLoading() {
    EasyLoading.dismiss();
  }

  static void showInfo(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    EasyLoading.showInfo(status, duration: duration, maskType: maskType, dismissOnTap: dismissOnTap);
  }

  static void showError(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    EasyLoading.showError(status, duration: duration, maskType: maskType, dismissOnTap: dismissOnTap);
  }

  static void showSuccess(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    EasyLoading.showSuccess(status, duration: duration, maskType: maskType, dismissOnTap: dismissOnTap);
  }

  static void showToast(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    EasyLoading.showToast(status, duration: duration, maskType: maskType, dismissOnTap: dismissOnTap);
  }
}
