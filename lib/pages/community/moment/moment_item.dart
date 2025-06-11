import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/components/custom_expandable_text.dart';
import 'package:solitary_meet/components/custom_grid_view.dart';
import 'package:solitary_meet/model/community.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/community.dart';
import 'package:solitary_meet/utils/screen_device.dart';

import '../../../common/colors/colors.dart';
import '../../../common/values/font.dart';
import '../../../common/values/image.dart';
import '../../../config.dart';
import '../../../utils/conts.dart';
import '../../../utils/helper.dart';
import '../../../utils/moment_view.dart';

class MomentItemView extends StatefulWidget {
  MomentModel moment;

  //点赞评论回调
  Function(MomentModel moment)? likeCallBack;
  Function(int count)? commentCallBack;

  MomentItemView(this.moment,
      {this.likeCallBack, this.commentCallBack, super.key});

  @override
  State<MomentItemView> createState() => _MomentItemViewState();
}

class _MomentItemViewState extends State<MomentItemView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
      width: getDeviceWidth(context),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.Profile, arguments: {
                "userId": widget.moment.userInfo!.userId,
                "avatar": widget.moment.userInfo!.avatar,
                "nickName": widget.moment.userInfo!.nickName
              });
            },
            child: ImageView(
              widget.moment.userInfo!.avatar ?? '',
              circular: true,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 2,
                ),
                Text(
                  widget.moment.userInfo!.nickName ?? '',
                  style: const TextStyle(
                    fontSize: AppFont.FontSize18,
                    color: AppColors.defaultFontColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  convertMomentDate((widget.moment.createdAt ?? 0) * 1000),
                  style: const TextStyle(
                    fontSize: AppFont.FontSize14,
                    color: AppColors.primaryGreyText,
                  ),
                ),

                /// 时刻内容
                if ((widget.moment.content ?? '') != '')
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.MomentDetail,
                              arguments: {"moment": widget.moment});
                        },
                        child: momentTxtView(widget.moment.content ?? ''),
                      )
                    ],
                  ),
                if ((widget.moment.attachment ?? []).isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      momentImgListView(context, widget.moment.attachment ?? [])
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
                                  widget.moment.likeStatus == statusLiked
                                      ? statusUnLike
                                      : statusLiked;
                              var result = await CommunityAPI.addMomentLiked({
                                "moment_id": widget.moment.momentId,
                                "status": status
                              });

                              if (result == "ok") {
                                setState(() {
                                  widget.moment.likeStatus =
                                      status == statusLiked ? 1 : 0;

                                  switch (status) {
                                    case statusLiked:
                                      widget.moment.likeCount =
                                          (widget.moment.likeCount ?? 0) + 1;
                                      break;
                                    case statusUnLike:
                                      widget.moment.likeCancelCount =
                                          (widget.moment.likeCancelCount ?? 0) +
                                              1;
                                      break;
                                  }
                                });
                                widget.likeCallBack!(widget.moment);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  widget.moment.likeStatus == 1
                                      ? 'assets/icons/heart_fill.webp'
                                      : 'assets/icons/heart_line.webp',
                                  width: AppImage.ImageSize20,
                                  height: AppImage.ImageSize20,
                                  color: widget.moment.likeStatus == 1
                                      ? Color(0xFFfc5531)
                                      : Color(0xFFA7A6A7),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  '${(widget.moment.likeCount ?? 0) - (widget.moment.likeCancelCount ?? 0)}',
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
                              Get.toNamed(AppRoutes.MomentDetail,
                                  arguments: {"moment": widget.moment});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //#fc5531
                                Image.asset(
                                  'assets/icons/message_line.webp',
                                  width: AppImage.ImageSize20,
                                  height: AppImage.ImageSize20,
                                  color: Color(0xFFA7A6A7),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  '${widget.moment.commentCount}',
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
          )
        ],
      ),
    );
  }
}
