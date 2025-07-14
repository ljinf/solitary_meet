import 'dart:ffi';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/common/values/font.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/router/app_pages.dart';

import '../../common/colors/colors.dart';
import '../../common/values/image.dart';
import '../../components/custom_image.dart';
import '../../components/custom_photo_view.dart';
import '../../config.dart';
import '../../utils/avatar.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  double avatarSize = 56.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  OpenContainer<bool>(
                    transitionType: ContainerTransitionType.fade,
                    openBuilder: (BuildContext context, VoidCallback callback) {
                      return CustomPhotoView(
                          imgList: [(Global.userProfile?.avatar ?? '')],
                          selected: 0);
                    },
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return getAvatarView(
                          '$STATIC_ASSETS_URL${Global.userProfile?.avatar ?? ''}',
                          avatarSize);
                    },
                    closedShape: const RoundedRectangleBorder(),
                    closedColor: Colors.white,
                    closedElevation: 0,
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
                          Global.userProfile!.nickName ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // 必需设置为1来使用ellipsis
                          style: const TextStyle(
                              fontSize: AppFont.defaultFontSize),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          (Global.userProfile!.selfSignature ?? '') == ''
                              ? '这家伙很懒，没有留下签名~ '
                              : Global.userProfile!.selfSignature!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: AppFont.FontSize13,
                            color: AppColors.primaryGreyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await Get.toNamed(AppRoutes.UserInfo);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('12'),
                      Text(
                        '关注',
                        style: TextStyle(fontSize: AppFont.FontSize13),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('12'),
                      Text(
                        '粉丝',
                        style: TextStyle(fontSize: AppFont.FontSize13),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('408'),
                      Text(
                        '被赞',
                        style: TextStyle(fontSize: AppFont.FontSize13),
                      ),
                    ],
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/icons/icon_eye.webp",
                    width: AppImage.ImageSize20,
                    height: AppImage.ImageSize20,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('我的足迹'),
                  Expanded(child: Container()),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chevron_right_rounded,
                        size: AppImage.ImageSize24,
                      ))
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/icons/icon_like_unselected.webp",
                    width: AppImage.ImageSize20,
                    height: AppImage.ImageSize20,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('点赞历史'),
                  Expanded(child: Container()),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chevron_right_rounded,
                        size: AppImage.ImageSize24,
                      ))
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/icons/icon_message.webp",
                    width: AppImage.ImageSize20,
                    height: AppImage.ImageSize20,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('评论历史'),
                  Expanded(child: Container()),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chevron_right_rounded,
                        size: AppImage.ImageSize24,
                      ))
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300], // 线条颜色
              height: 1, // 线条高度（包括上下间距）
              thickness: 1, // 线条粗细
              // indent: 16,         // 左边距
              // endIndent: 16,      // 右边距
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/icons/icon_setting.webp",
                    width: AppImage.ImageSize20,
                    height: AppImage.ImageSize20,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('设置'),
                  Expanded(child: Container()),
                  IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.Setting);
                      },
                      icon: const Icon(
                        Icons.chevron_right_rounded,
                        size: AppImage.ImageSize24,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
