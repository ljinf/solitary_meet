import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/router/app_pages.dart';

import '../../common/colors/colors.dart';
import '../../common/values/font.dart';
import '../../common/values/image.dart';
import '../../utils/authentication.dart';
import '../../utils/screen_device.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: const Text(
          '设置',
          style: TextStyle(fontSize: AppFont.FontSize14),
        ),
        brightness: Brightness.dark,
        backgroundColor: Colors.white,
        leadingType: AppBarBackType.Back,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Text('个人信息'),
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
            Container(
              margin:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50.0), // 这里设置圆角半径为按钮宽度的一半，以实现椭圆形效果
                    ),
                  ),
                  maximumSize: WidgetStateProperty.all(
                      Size(getDeviceWidth(context), 40)),
                  minimumSize: WidgetStateProperty.all(const Size(200, 40)),
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  deleteAuthentication();
                },
                child: const Text(
                  '退出登录',
                  style: TextStyle(
                    fontSize: AppFont.FontSize14,
                    color: AppColors.defaultFontColor,
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50.0), // 这里设置圆角半径为按钮宽度的一半，以实现椭圆形效果
                    ),
                  ),
                  maximumSize: WidgetStateProperty.all(
                      Size(getDeviceWidth(context), 40)),
                  minimumSize: WidgetStateProperty.all(const Size(200, 40)),
                  backgroundColor: WidgetStateProperty.all(Colors.red[400]),
                ),
                onPressed: () {},
                child: const Text(
                  '注销账号',
                  style: TextStyle(
                    fontSize: AppFont.FontSize14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
