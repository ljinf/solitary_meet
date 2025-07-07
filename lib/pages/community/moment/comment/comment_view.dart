import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/model/community.dart';
import 'package:solitary_meet/pages/community/moment/moment_item.dart';

import '../../../../common/colors/colors.dart';
import '../../../../common/values/font.dart';
import '../../../../common/values/image.dart';
import '../../../../components/custom_expandable_text.dart';
import '../../../../components/custom_image.dart';
import '../../../../config.dart';
import '../../../../global.dart';
import '../../../../services/community.dart';
import '../../../../utils/callback.dart';
import '../../../../utils/helper.dart';
import 'input_view.dart';

class CommentView extends StatefulWidget {
  CommentModel comment;
  bool divide = true; //是否分割线
  OnLike? onLike;
  OnComment? onComment;

  CommentView(
      {required this.comment,
      this.onComment,
      this.onLike,
      this.divide = true,
      super.key});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  bool loading = false;
  String inputHint = '有何高见~';
  String inputContent = '';

  Future<List<CommentModel>> loadCommentList(
      Map<String, dynamic> params) async {
    return await CommunityAPI.getCommentList(params);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: widget.divide ? 10 : 0, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageView(
            '$STATIC_ASSETS_URL${widget.comment.avatar ?? ''}',
            circular: true,
            width: AppImage.ImageSize24,
            height: AppImage.ImageSize24,
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: widget.divide ? 10 : 0),
              decoration: widget.divide
                  ? const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.primaryGrey2)))
                  : const BoxDecoration(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.comment.nickName ?? '',
                          style: const TextStyle(
                            fontSize: AppFont.FontSize12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          convertMomentDate(
                              (widget.comment.createdAt ?? 0) * 1000),
                          style: const TextStyle(
                            fontSize: AppFont.FontSize10,
                            color: AppColors.primaryGreyText,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onComment!(
                              widget.comment.momentId ?? '',
                              widget.comment.commentId ?? '',
                              widget.comment.userId ?? '',
                            );
                          },
                          child: CustomExpandableText(
                            maxLine: 2,
                            linkColor: AppColors.moderateCyan,
                            text: widget.comment.content ?? '',
                            style: const TextStyle(
                              fontSize: AppFont.FontSize14,
                              color: AppColors.defaultFontColor,
                            ),
                          ),
                        ),
                        if ((widget.comment.commentCount ?? 0) > 0)
                          moreSubComment()
                      ],
                    ),
                  ),

                  ///点赞
                  GestureDetector(
                    onTap: () {
                      var likeStatus = widget.comment.likeStatus == 0 ? 1 : 0;
                      CommunityAPI.addCommentLiked({
                        "comment_id": widget.comment.commentId,
                        "status": likeStatus,
                      }).then((v) {
                        if (v == "ok") {
                          setState(() {
                            widget.comment.likeStatus = likeStatus;
                            if (likeStatus == 0) {
                              widget.comment.likeCancelCount =
                                  widget.comment.likeCancelCount! + 1;
                            } else {
                              widget.comment.likeCount =
                                  widget.comment.likeCount! + 1;
                            }
                          });
                        }
                      });
                    },
                    child: Image.asset(
                      widget.comment.likeStatus == 0
                          ? 'assets/icons/icon_like_unselected.webp'
                          : 'assets/icons/icon_like_selected.webp',
                      width: AppImage.ImageSize13,
                      height: AppImage.ImageSize13,
                      color: widget.comment.likeStatus == 0
                          ? AppColors.primaryGreyText
                          : AppColors.moderateCyan,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${widget.comment.likeCount ?? 0}',
                    style: const TextStyle(fontSize: AppFont.FontSize12),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void inputView(String? parentId, String? commentId, String? replyId) {
    Get.dialog(
      InputView(
        inputHint,
        callback: (content) {
          inputContent = content;
        },
      ),
    ).then((e) async {
      if (inputContent != '') {
        var resp = await CommunityAPI.addComment({
          "parent_id": parentId,
          "moment_id": widget.comment.momentId,
          "reply_id": replyId,
          "reply_comment_id": commentId,
          "content": inputContent
        });
        resp?.nickName = Global.userProfile?.nickName;
        resp?.avatar = Global.userProfile?.avatar;
        reset();
      }
    });
  }

  Widget moreSubComment() {
    var moreTips = widget.comment.children.isEmpty
        ? '还有${widget.comment.commentCount}条回复'
        : '更多回复';

    if (widget.comment.children.isNotEmpty) {
      var list = <Widget>[];
      for (var item in widget.comment.children) {
        list.add(CommentView(
          comment: item,
          divide: false,
        ));
      }
      return Column(
        children: list,
      );
    }

    return GestureDetector(
      onTap: () async {
        int? index = 0;
        if (widget.comment.children.isNotEmpty) {
          index =
              widget.comment.children[widget.comment.children.length - 1].id;
        }
        setState(() {
          loading = true;
        });
        var result = await loadCommentList({
          "moment_id": widget.comment.momentId,
          "parent_id": widget.comment.commentId,
          "index": index,
          "page_size": 5,
        });
        setState(() {
          widget.comment.children.addAll(result);
          loading = false;
          if (result.length < 5) {
            moreTips = '';
          }
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            moreTips,
            style: const TextStyle(
                fontSize: AppFont.FontSize11, color: AppColors.moderateCyan),
          ),
          loading
              ? Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: 8,
                  height: 8,
                  child: const CircularProgressIndicator(
                    color: AppColors.moderateCyan,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppImage.ImageSize15,
                  color: AppColors.moderateCyan,
                )
        ],
      ),
    );
  }

  void reset() {}
}
