import 'package:solitary_meet/model/msg_model.dart';
import 'package:solitary_meet/services/services.dart';

import '../model/conversation_model.dart';
import '../utils/request.dart';

class ConversationAPI {
  static Future<List<ConversationModel>?> getConversationList({required Map params}) async {
    showLoading();
    var response = await Request().post(
      '/v1/chat/conversation/list',
      params: params,
    );
    dismissLoading();
    if (!responseCheck(response)) {
      return null;
    }
    var resp = <ConversationModel>[];
    List<dynamic> list = response['data'] as List<dynamic>;
    for (var element in list) {
      resp.add(ConversationModel.fromJson(element));
    }
    return resp;
  }
}
