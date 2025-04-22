import 'package:solitary_meet/model/login_model.dart';
import 'package:solitary_meet/services/services.dart';
import 'package:solitary_meet/utils/utils.dart';

/// 用户
class UserAPI {
  /// 登录
  static Future<UserLoginResponseModel?> login({
    required Map params,
  }) async {
    loading();
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
    loading();
    var response = await Request().get(
      '/v1/user',
    );
    dismissLoading();
    if (!responseCheck(response)) {
      return null;
    }
    return UserLoginResponseModel.fromJson(response['data']);
  }

  /// 仅支持email查询信息
  static Future<UserLoginResponseModel?> searchUserInfo(Map params) async {
    loading();
    var response = await Request().post(
      '/v1/search',
      params: params,
    );
    dismissLoading();
    if (!responseCheck(response)) {
      return null;
    }
    return UserLoginResponseModel.fromJson(response['data']);
  }
}
