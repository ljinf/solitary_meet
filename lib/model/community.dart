import 'package:get/get_common/get_reset.dart';

import 'login_model.dart';

class MomentModel {
  String? userId;
  UserLoginResponseModel? userInfo;

  String? momentId;
  String? content;
  List<String>? attachment;
  int? attachmentType;
  int? public;
  int? status;
  int? createdAt;
  int? likeCount;
  int? likeCancelCount;
  int? likeStatus;
  int? commentCount;

  MomentModel(
      {this.userId,
      this.momentId,
      this.content,
      this.attachment,
      this.attachmentType,
      this.public,
      this.status,
      this.createdAt,
      this.likeCount,
      this.likeCancelCount,
      this.likeStatus,
      this.commentCount,
      this.userInfo});

  factory MomentModel.fromJson(Map<String, dynamic> data) {
    return MomentModel(
      userId: data['user_id'] ?? '',
      momentId: data['moment_id'] ?? '',
      content: data['content'] ?? '',
      attachment: (data['attachment'] ?? []).cast<String>(),
      attachmentType: data['attachment_type'] ?? 0,
      public: data['public'] ?? 1,
      status: data['status'] ?? 2,
      createdAt: data['created_at'] ?? 0,
      likeCount: data['like_count'] ?? 0,
      likeCancelCount: data['like_cancel_count'] ?? 0,
      likeStatus: data['like_status'] ?? 0,
      commentCount: data['comment_count'] ?? 0,
      userInfo: UserLoginResponseModel.fromJson(data['user_info']),
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "moment_id": momentId,
        "content": content,
        "attachment": attachment,
        "attachment_type": attachmentType,
        "public": public,
        "status": status,
        "created_at": createdAt,
        "like_count": likeCount,
        "like_cancel_count": likeCancelCount,
        "like_status": likeStatus,
        "comment_count": commentCount,
        "user_info": userInfo
      };
}

class CommentModel {
  String? userId;
  UserLoginResponseModel? userInfo;

  String? momentId;
  String? parentId;
  String? commentId;

  String? replyId;
  UserLoginResponseModel? replyInfo;

  String? content;
  int? status;
  int? createdAt;
  int? likeCount;
  int? likeCancelCount;
  int? likeStatus;
  int? commentCount;

  CommentModel(
      {this.userId,
      this.userInfo,
      this.momentId,
      this.parentId,
      this.commentId,
      this.replyId,
      this.replyInfo,
      this.content,
      this.status,
      this.createdAt,
      this.likeCount,
      this.likeCancelCount,
      this.likeStatus,
      this.commentCount});

  factory CommentModel.fromJson(Map<String, dynamic> data) => CommentModel(
        commentId: data['comment_id'] ?? '',
        parentId: data['parent_id'] ?? '',
        userId: data['user_id'] ?? '',
        userInfo: UserLoginResponseModel.fromJson(data['user_info']),
        momentId: data['moment_id'] ?? '',
        replyId: data['reply_id'] ?? '',
        replyInfo: UserLoginResponseModel.fromJson(data['reply_info']),
        content: data['content'] ?? '',
        status: data['status'] ?? 2,
        createdAt: data['created_at'] ?? 0,
        likeCount: data['like_count'] ?? 0,
        likeCancelCount: data['like_cancel_count'] ?? 0,
        likeStatus: data['like_status'] ?? 0,
        commentCount: data['comment_count'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "parent_id": parentId,
        "moment_id": momentId,
        "user_id": userId,
        "user_info": userInfo,
        "reply_id": replyId,
        "reply_info": replyInfo,
        "content": content,
        "like_count": likeCount,
        "like_cancel_count": likeCancelCount,
        "comment_count": commentCount,
        "like_status": likeStatus,
        "status": status,
        "created_at": createdAt
      };
}
