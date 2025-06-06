import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/pages/community/moment/detail/moment_detail_controller.dart';

import '../../../../common/colors/colors.dart';
import '../../../../common/values/font.dart';
import '../../../../common/values/image.dart';
import '../../../../components/custom_appbar.dart';
import '../../../../components/custom_image.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/moment_view.dart';
import '../../../../utils/screen_device.dart';

class MomentDetailPage extends StatefulWidget {
  const MomentDetailPage({super.key});

  @override
  State<MomentDetailPage> createState() => _MomentDetailPageState();
}

class _MomentDetailPageState extends State<MomentDetailPage>
    with SingleTickerProviderStateMixin {
  var controller = Get.find<MomentDetailController>();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: const Text('详情'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: getDeviceWidth(context),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  ImageView(
                    controller.moment.userInfo!.avatar ?? '',
                    circular: true,
                  ),
                  const SizedBox(
                    width: 10,
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
                          fontSize: AppFont.FontSize14,
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
                      height: 10,
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
                          onTap: () {},
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
      ),
    );
  }
}
