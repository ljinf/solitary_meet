import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solitary_meet/common/values/values.dart';
import 'package:solitary_meet/model/login_model.dart';
import 'package:solitary_meet/utils/utils.dart';

/// 全局配置
class Global {
  /// 用户配置
  static UserLoginResponseModel? userProfile = UserLoginResponseModel(token: null);

  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// 是否 release
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // Ruquest 模块初始化
    Request();
    // 本地存储初始化
    await LocalStorage.init();

    // 极光推送初始化
    // await PushManager.setup();

    // 语音播报初始化
    // await TtsManager.setup();

    // 高德地图初始化
    // await AmapService.instance.init(
    //   iosKey: 'xxxx',
    //   androidKey: 'xxxx',
    // );

    // 读取设备第一次打开
    isFirstOpen = !LocalStorage().getBool(STORAGE_DEVICE_ALREADY_OPEN_KEY);
    if (isFirstOpen) {
      LocalStorage().setBool(STORAGE_DEVICE_ALREADY_OPEN_KEY, true);
    }

    // 读取离线用户信息
    var profileJSON = LocalStorage().getJSON(STORAGE_USER_PROFILE_KEY);
    if (profileJSON != null) {
      userProfile = UserLoginResponseModel.fromJson(profileJSON);
    }

    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  // 持久化 用户信息
  static Future<bool> saveProfile(UserLoginResponseModel userResponse) {
    userProfile = userResponse;
    return LocalStorage().setJSON(STORAGE_USER_PROFILE_KEY, userResponse.toJson());
  }
}
