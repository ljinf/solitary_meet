import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/common/values/font.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/router/app_pages.dart';

import '../../components/custom_image.dart';
import '../../utils/conts.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.Profile, arguments: {
                      "userId": Global.userProfile!.userId,
                      "avatar": Global.userProfile!.avatar,
                      "nickName": Global.userProfile!.nickName
                    });
                  },
                  child: ImageView(
                    Global.userProfile!.avatar!,
                    width: defaultWidth,
                    height: defaultWidth,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      Global.userProfile!.nickName ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // 必需设置为1来使用ellipsis
                      style: TextStyle(fontSize: AppFont.FontSize14),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      Global.userProfile!.selfSignature ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // 必需设置为1来使用ellipsis
                      style: TextStyle(fontSize: AppFont.FontSize14),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
