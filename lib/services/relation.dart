import 'package:solitary_meet/model/relationship_model.dart';
import 'package:solitary_meet/services/services.dart';

/// 关系相关
class RelationAPI {
  /// 好友列表
  static Future<List<RelationshipModel>?> getFriendList(
      {required Map params, bool loading = true}) async {
    var response = await doRequest('/v1/relationship/relation/list',
        params: params, loading: loading);
    if (!responseCheck(response)) {
      return null;
    }
    var resp = <RelationshipModel>[];
    List<dynamic> list = response['data']['rows'] as List<dynamic>;
    for (var element in list) {
      resp.add(RelationshipModel.fromJson(element));
    }
    return resp;
  }
}
