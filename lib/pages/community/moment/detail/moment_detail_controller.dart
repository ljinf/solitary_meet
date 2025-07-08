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

  //评论数+1
  void incrCommentCount() {
    moment.commentCount = (moment.commentCount ?? 0) + 1;
  }

  ///获取评论
  Future<List<CommentModel>> getCommentList(Map<String, dynamic> params) async {
    return await CommunityAPI.getCommentList(params);
  }

  ///添加评论
  Future<CommentModel?> addComment(Map<String, dynamic> params) async {
    return await CommunityAPI.addComment(params);
  }

  ///点赞时刻
  Future<String> likeMoment(Map<String, dynamic> params) async {
    return await CommunityAPI.addMomentLiked(params);
  }

  ///点赞评论
  Future<String?> likeComment(Map<String, dynamic> params) async {
    return await CommunityAPI.addCommentLiked(params);
  }
}
