import 'package:solitary_meet/services/services.dart';

import '../model/msg_model.dart';
import '../utils/request.dart';

class ChatAPI {
  //用户消息
  static Future<Map<String, dynamic>> getChatHistoryMsgList(
      {required Map params}) async {
    var response = await doRequest('/v1/chat/msg/history/list', params: params);
    if (!responseCheck(response)) {
      return {"total": 0};
    }
    var resp = <MsgModel>[];
    List<dynamic> list = response['data']['rows'] as List<dynamic>;
    for (var element in list) {
      resp.add(MsgModel.fromJson(element));
    }
    return {"list": resp, "total": response['data']['total'] ?? 0};
  }

  //会话消息
  static Future<Map<String, dynamic>> getConversationMsgList(
      {required Map params}) async {
    var response = await doRequest('/v1/chat/msg/list', params: params);
    if (!responseCheck(response)) {
      return {"total": 0};
    }
    var resp = <MsgModel>[];
    List<dynamic> list = response['data']['rows'] as List<dynamic>;
    for (var element in list) {
      resp.add(MsgModel.fromJson(element));
    }
    return {"list": resp, "total": response['data']['total'] ?? 0};
  }

  static Future<MsgModel?> sendMsg({required Map params}) async {
    showLoading();
    var response = await Request().post(
      '/v1/chat/send',
      params: params,
    );
    dismissLoading();
    if (!responseCheck(response)) {
      return null;
    }
    return MsgModel.fromJson(response['data']);
  }
}
