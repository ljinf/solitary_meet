import 'package:flutter/cupertino.dart';
import 'package:solitary_meet/model/community.dart';
import 'package:solitary_meet/services/services.dart';

class CommunityAPI {
  //发表时刻
  static Future<String> addMoment(Map<String, dynamic> params,
      {bool loading = true}) async {
    var result = await doRequest("/v1/community/moment/add",
        params: params, loading: loading);
    if (result != null) {
      return result['message'];
    }

    return "";
  }

  //时刻列表
  static Future<List<MomentModel>> getMomentList(Map<String, dynamic> params,
      {bool loading = true}) async {
    var resp = <MomentModel>[];
    var result = await doRequest("/v1/community/moment/list",
        params: params, loading: loading);

    if (!responseCheck(result)) {
      return resp;
    }

    try {
      if (result != null && result['data'] != null) {
        for (var item in result['data']) {
          resp.add(MomentModel.fromJson(item));
        }
      }
    } catch (e) {
      debugPrint("Err:$e");
    }

    return resp;
  }

  //评论列表
  static Future<List<CommentModel>> getCommentList(Map<String, dynamic> params,
      {bool loading = true}) async {
    var resp = <CommentModel>[];
    var result = await doRequest("/v1/community/comment/list",
        params: params, loading: loading);

    if (!responseCheck(result)) {
      return resp;
    }

    if (result != null && result['data'] != null) {
      for (var item in result['data']) {
        resp.add(CommentModel.fromJson(item));
      }
    }

    return resp;
  }

  //点赞时刻
  static Future<String> addMomentLiked(Map<String, dynamic> params,
      {bool loading = true}) async {
    var result = await doRequest("/v1/community/moment/like",
        params: params, loading: loading);

    if (result != null) {
      return result['message'];
    }

    return "";
  }

  //点赞评论
  static Future<String> addCommentLiked(Map<String, dynamic> params,
      {bool loading = true}) async {
    var result = await doRequest("/v1/community/comment/like",
        params: params, loading: loading);

    if (result != null) {
      return result['message'];
    }

    return "";
  }

  //发表评论
  static Future<CommentModel?> addComment(Map<String, dynamic> params,
      {bool loading = true}) async {
    var result = await doRequest("/v1/community/comment/add",
        params: params, loading: loading);

    if (result != null && result['data'] != null) {
      return CommentModel.fromJson(result['data']);
    }

    return null;
  }
}
