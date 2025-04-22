import 'package:solitary_meet/model/relationship_model.dart';
import 'package:solitary_meet/services/services.dart';
import '../utils/request.dart';

/// 关系相关
class RelationAPI {
  /// 好友列表
  static Future<List<RelationshipModel>?> getFriendList({
    required Map params,
  }) async {
    loading();
    var response = await Request().post(
      '/v1/relationship/relation/list',
      params: params,
    );
    dismissLoading();
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
