import 'package:flutter/material.dart';
import 'package:solitary_meet/pages/Index/Index_controller.dart';
import 'package:solitary_meet/pages/splash/spalsh_view.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/router/app_pages.dart';

import '../../common/colors/colors.dart';
import '../../common/values/font.dart';
import '../../config.dart';
import '../../utils/message.dart';
import '../../utils/screen_device.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool agreePolicy = true;

  final controller = Get.find<IndexController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg_1.png'), fit: BoxFit.cover)),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16), // 圆角半径
                    child: Image.asset(
                      'assets/images/logo_1.png',
                      width: 72,
                      height: 72,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  textAlign: TextAlign.center,
                  "孤独是人生的常态。",
                  style: TextStyle(
                      fontSize: AppFont.FontSize18,
                      color: Colors.white,
                      height: 2,
                      letterSpacing: 3),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    50.0), // 这里设置圆角半径为按钮宽度的一半，以实现椭圆形效果
                              ),
                            ),
                            maximumSize: WidgetStateProperty.all(
                                Size(getDeviceWidth(context), 45)),
                            minimumSize:
                                WidgetStateProperty.all(const Size(343, 45)),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            if (!agreePolicy) {
                              Message.showError('请阅读并同意用户协议');
                              return;
                            }
                            // controller.loginHandler('wechat');
                          },
                          child: const Text(
                            '微信一键登录',
                            style: TextStyle(
                                fontSize: AppFont.FontSize15,
                                color: AppColors.defaultFontColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    50.0), // 这里设置圆角半径为按钮宽度的一半，以实现椭圆形效果
                              ),
                            ),
                            maximumSize: WidgetStateProperty.all(
                                Size(getDeviceWidth(context), 45)),
                            minimumSize:
                                WidgetStateProperty.all(const Size(343, 45)),
                            backgroundColor:
                                WidgetStateProperty.all(AppColors.moderateCyan),
                          ),
                          onPressed: () {
                            controller.toPhoneLogin();

                            // if (!agreePolicy) {
                            //   Message.showError('请阅读并同意用户协议');
                            //   return;
                            // }
                            // controller.loginHandler('phone');
                          },
                          child: const Text(
                            '手机号码登录',
                            style: TextStyle(
                                fontSize: AppFont.FontSize15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: agreePolicy
                                  ? Image.asset(
                                      'assets/icons/checked.webp',
                                      width: 14,
                                      height: 14,
                                    )
                                  : Image.asset(
                                      'assets/icons/uncheck.webp',
                                      width: 14,
                                      height: 14,
                                    ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              '阅读并同意',
                              style: TextStyle(
                                  fontSize: AppFont.FontSize13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          /*Get.dialog(
                            PolicyPage(
                              'user_agreement',
                              pathUrl:
                              'https://api.qingdupub.cn/policy/user_agreement.html',
                            ),
                          );*/
                        },
                        child: const Text(
                          '《用户协议》',
                          style: TextStyle(
                            fontSize: AppFont.FontSize13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor: Colors.white,
                            decorationThickness: 2.0, // 线条宽度为2.0),
                          ),
                        ),
                      ),
                      const Text(
                        '和',
                        style: TextStyle(
                            fontSize: AppFont.FontSize13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Get.dialog(
                          //   PolicyPage(
                          //     'policy',
                          //     pathUrl:
                          //     'https://api.qingdupub.cn/policy/privacy.html',
                          //   ),
                          // );
                        },
                        child: const Text(
                          '《隐私政策》',
                          style: TextStyle(
                            fontSize: AppFont.FontSize13,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor: Colors.white,
                            fontWeight: FontWeight.w500,
                            decorationThickness: 2.0, // 线条宽度为2.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
