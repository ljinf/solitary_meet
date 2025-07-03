import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:solitary_meet/pages/community/moment/detail/moment_detail_controller.dart';

import '../../../../common/colors/colors.dart';
import '../../../../common/values/font.dart';
import '../../../../common/values/image.dart';
import '../../../../components/custom_appbar.dart';
import '../../../../components/custom_image.dart';
import '../../../../components/pull_up_header.dart';
import '../../../../config.dart';
import '../../../../model/community.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/moment_view.dart';
import '../../../../utils/screen_device.dart';
import '../comment/input_view.dart';

class MomentDetailPage extends StatefulWidget {
  const MomentDetailPage({super.key});

  @override
  State<MomentDetailPage> createState() => _MomentDetailPageState();
}

class _MomentDetailPageState extends State<MomentDetailPage>
    with SingleTickerProviderStateMixin {
  var controller = Get.find<MomentDetailController>();
  late AnimationController _animationController;

  ///评论相关
  late RefreshController refreshController;
  int pageNum = 1;
  int pageSize = 30;
  List<CommentModel> commentList = [];
  String inputContent = '';

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    _animationController = AnimationController(vsync: this);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // UI渲染完成，调用requestRefresh()
      refreshController.requestRefresh();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void refreshCommentList() async {
    commentList.clear();
    pageNum = 1;
    var resp = await controller.getCommentList({
      "moment_id": controller.moment.momentId,
      "created_at": 0,
    });
    if (resp.isNotEmpty) {
      setState(() {
        commentList.addAll(resp);
        pageNum++;
      });
    }
    refreshController.refreshCompleted();
  }

  void loadCommentList() async {
    var resp = await controller.getCommentList({
      "moment_id": controller.moment.momentId,
      "created_at": commentList[commentList.length - 1].createdAt,
      "page_num": pageNum,
      "page_size": pageSize,
    });
    if (resp.isNotEmpty) {
      setState(() {
        commentList.addAll(resp);
        pageNum++;
      });
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: const Text(
          '详情',
          style: TextStyle(fontSize: AppFont.defaultFontSize),
        ),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: refreshCommentList,
        onLoading: loadCommentList,
        header: const WaterDropHeader(
          waterDropColor: Colors.blue,
        ),
        footer: const PullUpHeader(),
        child: Column(
          children: [
            ///时刻内容
            Container(
              width: getDeviceWidth(context),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ImageView(
                        '$STATIC_ASSETS_URL${controller.moment.userInfo!.avatar ?? ''}',
                        circular: true,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            controller.moment.userInfo!.nickName ?? '',
                            style: const TextStyle(
                              fontSize: AppFont.FontSize18,
                              color: AppColors.defaultFontColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            convertMomentDate(
                                (controller.moment.createdAt ?? 0) * 1000),
                            style: const TextStyle(
                              fontSize: AppFont.FontSize13,
                              color: AppColors.primaryGreyText,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  /// 时刻内容
                  if ((controller.moment.content ?? '') != '')
                    Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        momentTxtView(controller.moment.content ?? '')
                      ],
                    ),
                  if ((controller.moment.attachment ?? []).isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        momentImgListView(
                            context, controller.moment.attachment ?? [])
                      ],
                    ),

                  ///评论点赞
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          //点赞
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    controller.moment.likeStatus == 1
                                        ? 'assets/icons/heart_fill.webp'
                                        : 'assets/icons/heart_line.webp',
                                    width: AppImage.ImageSize20,
                                    height: AppImage.ImageSize20,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${(controller.moment.likeCount ?? 0) - (controller.moment.likeCancelCount ?? 0)}',
                                    style: const TextStyle(
                                        fontSize: AppFont.FontSize12,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //评论
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                inputView('0', '0', '0');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/message_line.webp',
                                    width: AppImage.ImageSize20,
                                    height: AppImage.ImageSize20,
                                    // color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${controller.moment.commentCount}',
                                    style: const TextStyle(
                                        fontSize: AppFont.FontSize12,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),

            Container(
              height: 6,
              color: const Color(0x44E5E6EB),
            ),

            ///评论内容
            commentListView(),
          ],
        ),
      ),
    );
  }

  Widget commentListView() {
    List<Widget> views = [];
    for (var v in commentList) {
      views.add(commentItem(v));
    }
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: views,
      ),
    );
  }

  Widget commentItem(CommentModel comment) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageView(
            '$STATIC_ASSETS_URL${comment.userInfo!.avatar ?? ''}',
            circular: true,
            width: AppImage.ImageSize28,
            height: AppImage.ImageSize28,
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColors.primaryGrey2))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          comment.userInfo!.nickName ?? '孤舟一横',
                          style: const TextStyle(
                            fontSize: AppFont.FontSize12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          convertMomentDate((comment.createdAt ?? 0) * 1000),
                          style: const TextStyle(
                            fontSize: AppFont.FontSize10,
                            color: AppColors.primaryGreyText,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          comment.content ?? '',
                          style: const TextStyle(
                            fontSize: AppFont.FontSize14,
                            color: AppColors.defaultFontColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '10',
                    style: TextStyle(fontSize: AppFont.FontSize12),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Image.asset(
                    'assets/icons/icon_like_unselected.webp',
                    width: AppImage.ImageSize13,
                    height: AppImage.ImageSize13,
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
        '有何高见~',
        callback: (content) {
          inputContent = content;
        },
      ),
    ).then((e) async {
      if (inputContent != '') {
        var resp = await controller.addComment({
          "parent_id": parentId,
          "moment_id": controller.moment.momentId,
          "reply_id": replyId,
          "reply_comment_id": commentId,
          "content": inputContent
        });
        debugPrint(resp.toString());
      }
    });
  }
}
