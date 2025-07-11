import 'package:solitary_meet/model/login_model.dart';
import 'package:solitary_meet/services/services.dart';
import 'package:solitary_meet/utils/utils.dart';

/// 用户
class UserAPI {
  /// 请求验证码
  static Future<String> requestVerificationCode(
      {required Map params, bool loading = true}) async {
    var result = await doRequest('/v1/verificationCode',
        params: params, loading: loading);

    if (result != null) {
      return result['message'];
    }

    return "";
  }

  /// 登录
  static Future<UserLoginResponseModel?> login({
    required Map params,
  }) async {
    showLoading();
    var response = await Request().post(
      '/v1/login',
      params: params,
    );
    dismissLoading();
    if (!responseCheck(response)) {
      return null;
    }
    return UserLoginResponseModel.fromJson(response['data']);
  }

  /// 用户信息
  static Future<UserLoginResponseModel?> userInfo() async {
    showLoading();
    var response = await Request().get(
      '/v1/user',
    );
    dismissLoading();
    if (!responseCheck(response)) {
      return null;
    }
    return UserLoginResponseModel.fromJson(response['data']);
  }

  /// 查询信息
  static Future<UserLoginResponseModel?> searchUserInfo(Map params) async {
    var response = await doRequest('/v1/search', params: params, loading: true);
    if (response != null) {
      return UserLoginResponseModel.fromJson(response['data']);
    }
    return null;
  }

  /// 更新用户信息
  static Future<UserLoginResponseModel?> updateProfile(
      {required Map params}) async {
    showLoading();
    var response = await Request().put(
      '/v1/user',
      params: params,
    );
    dismissLoading();
    if (!responseCheck(response)) {
      return null;
    }
    return UserLoginResponseModel.fromJson(response['data']);
  }
}
