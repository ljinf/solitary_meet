import 'package:solitary_meet/model/login_model.dart';
import 'package:solitary_meet/services/services.dart';

import '../model/conversation_model.dart';

class ConversationAPI {
  static Future<Map<String, dynamic>?> getConversationList(
      {required Map params, bool loading = true}) async {
    var response = await doRequest('/v1/chat/conversation/list',
        params: params, loading: loading);
    if (!responseCheck(response)) {
      return null;
    }
    var resp = <ConversationModel>[];
    List<dynamic> list = response['data']['rows'] as List<dynamic>;
    for (var element in list) {
      resp.add(ConversationModel.fromJson(element));
    }
    return {"list": resp, "total": response['data']['total'] ?? 0};
  }

  static Future<List<UserInfoModel>> getConversationUsers(
      {required Map params, bool loading = true}) async {
    var resp = <UserInfoModel>[];
    var response = await doRequest('/v1/chat/conversation/users',
        params: params, loading: loading);
    if (!responseCheck(response)) {
      return resp;
    }

    List<dynamic> list = response['data'] as List<dynamic>;
    for (var element in list) {
      resp.add(UserInfoModel.fromJson(element));
    }
    return resp;
  }
}
