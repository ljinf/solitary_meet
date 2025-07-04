import 'package:get/get.dart';

import '../../../../model/community.dart';
import '../../../../services/community.dart';

class MomentDetailController extends GetxController {
  late MomentModel moment;

  @override
  void onInit() {
    moment = Get.arguments['moment'];
    super.onInit();
  }

  Future<List<CommentModel>> getCommentList(Map<String, dynamic> params) async {
    return await CommunityAPI.getCommentList(params);
  }

  Future<CommentModel?> addComment(Map<String, dynamic> params) async {
    return await CommunityAPI.addComment(params);
  }

  Future<String?> likeComment(Map<String, dynamic> params) async {
    return await CommunityAPI.addCommentLiked(params);
  }
}
