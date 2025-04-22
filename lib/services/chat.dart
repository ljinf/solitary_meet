import 'package:solitary_meet/services/services.dart';

import '../model/msg_model.dart';
import '../utils/request.dart';

class ChatAPI {
  static Future<List<MsgModel>?> getChatHistoryMsgList({required Map params}) async {
    loading();
    var response = await Request().post(
      '/v1/chat/msg/history/list',
      params: params,
    );
    dismissLoading();
    if (!responseCheck(response)) {
      return null;
    }
    var resp = <MsgModel>[];
    List<dynamic> list = response['data'] as List<dynamic>;
    for (var element in list) {
      resp.add(MsgModel.fromJson(element));
    }
    return resp;
  }

  static Future<MsgModel?> sendMsg({required Map params}) async {
    loading();
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
