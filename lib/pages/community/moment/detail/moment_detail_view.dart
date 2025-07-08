import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/pages/community/moment/detail/moment_detail_controller.dart';

import '../../../../common/colors/colors.dart';
import '../../../../common/values/font.dart';
import '../../../../common/values/image.dart';
import '../../../../components/custom_appbar.dart';
import '../../../../components/custom_expandable_text.dart';
import '../../../../components/custom_image.dart';
import '../../../../components/pull_up_header.dart';
import '../../../../config.dart';
import '../../../../model/community.dart';
import '../../../../utils/conts.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/moment_view.dart';
import '../../../../utils/screen_device.dart';
import '../comment/comment_view.dart';
import '../comment/input_view.dart';

class MomentDetailPage extends StatefulWidget {
  const MomentDetailPage({super.key});

  @override
  State<MomentDetailPage> createState() => _MomentDetailPageState();
}

class _MomentDetailPageState extends State<MomentDetailPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  var controller = Get.find<MomentDetailController>();
  late AnimationController _animationController;

  ///评论相关
  int pageNum = 1;
  int pageSize = 30;
  List<CommentModel> commentList = [];
  String inputHint = '有何高见~';
  String inputContent = '';

  late ScrollController scrollController;

  // 设置一个小的阈值来判断是否接近底部
  final double bottomThreshold = 5;

  //是否向下
  bool scrollDown = false;

  //是否组件自动滚动
  bool autoScroll = false;
  double _previousScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    scrollController = ScrollController();
    _animationController = AnimationController(vsync: this);
    refreshCommentList();
    scrollController.addListener(() {
      final double currentScrollOffset = scrollController.offset;
      if (_previousScrollOffset > 0) {
        if (currentScrollOffset > _previousScrollOffset) {
          // 向下滑动
          scrollDown = true;
        } else if (currentScrollOffset < _previousScrollOffset) {
          // 向上滑动
          scrollDown = false;
        }
      }
      // 更新为当前滚动位置，以便下次比较
      // 注意：首次滚动时，_previousScrollOffset 为 0，因此不会触发方向判断
      _previousScrollOffset = currentScrollOffset;

      if (scrollDown) {
        // 检查是否接近底部
        final double maxScroll = scrollController.position.maxScrollExtent;
        final double currentScroll = scrollController.offset;
        if (maxScroll - currentScroll < bottomThreshold) {
          print('已经接近底部');
          // 在这里执行滚动到底部的逻辑
          if (!autoScroll) {
            autoScroll = false; //还原
            print('请求下一页');
            loadCommentList();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void refreshCommentList() async {
    commentList.clear();
    var resp = await controller.getCommentList({
      "moment_id": controller.moment.momentId,
      "index": 0,
    });
    if (resp.isNotEmpty) {
      setState(() {
        commentList.addAll(resp);
      });
    }
  }

  void loadCommentList() async {
    var resp = await controller.getCommentList({
      "moment_id": controller.moment.momentId,
      "index": commentList[commentList.length - 1].id,
      "page_size": pageSize,
    });
    if (resp.isNotEmpty) {
      setState(() {
        commentList.addAll(resp);
      });
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
      body: SingleChildScrollView(
        controller: scrollController,
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
                              onTap: () async {
                                var status =
                                    controller.moment.likeStatus == statusLiked
                                        ? statusUnLike
                                        : statusLiked;
                                var result = await controller.likeMoment({
                                  "moment_id": controller.moment.momentId,
                                  "status": status
                                });

                                if (result == "ok") {
                                  setState(() {
                                    controller.moment.likeStatus =
                                        status == statusLiked ? 1 : 0;

                                    switch (status) {
                                      case statusLiked:
                                        controller.moment.likeCount =
                                            (controller.moment.likeCount ?? 0) +
                                                1;
                                        break;
                                      case statusUnLike:
                                        controller.moment.likeCancelCount =
                                            (controller.moment
                                                        .likeCancelCount ??
                                                    0) +
                                                1;
                                        break;
                                    }
                                  });
                                }
                              },
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
                                    color: controller.moment.likeStatus == 1
                                        ? Color(0xFFfc5531)
                                        : Color(0xFFA7A6A7),
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
      /*body: SmartRefresher(
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
      ),*/
    );
  }

  Widget commentListView() {
    List<Widget> views = [];
    for (int index = 0; index < commentList.length; index++) {
      views.add(commentItem(index, commentList[index]));
    }
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Column(
        children: views,
      ),
    );
  }

  Widget commentItem(int index, CommentModel comment) {
    ///一级评论
    return CommentView(
      parentId: comment.commentId,
      comment: comment,
      isChild: false,
      onComment: (String momentId, String commentId, String replyId) {
        setState(() {
          controller.incrCommentCount();
        });
      },
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
        var resp = await controller.addComment({
          "parent_id": parentId,
          "moment_id": controller.moment.momentId,
          "reply_id": replyId,
          "reply_comment_id": commentId,
          "content": inputContent
        });
        if (resp != null) {
          setState(() {
            resp.nickName = Global.userProfile?.nickName;
            resp.avatar = Global.userProfile?.avatar;
            commentList.add(resp);
            controller.incrCommentCount();
          });
        }
      }
    });
  }
}
