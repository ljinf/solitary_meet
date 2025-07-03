import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/pages/login/phone/phone_controller.dart';

import '../../../common/colors/colors.dart';
import '../../../common/values/font.dart';
import '../../../utils/screen_device.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  bool enable = false;

  var controller = Get.find<PhoneController>();

  @override
  void initState() {
    listener();
    super.initState();
  }

  void listener() {
    phoneController.addListener(() {
      if (phoneController.text.length >= 11 && codeController.text.length >= 6) {
        setState(() {
          enable = true;
        });
      } else {
        setState(() {
          enable = false;
        });
      }
    });
    codeController.addListener(() {
      if (phoneController.text.length >= 11 && codeController.text.length >= 6) {
        setState(() {
          enable = true;
        });
      } else {
        setState(() {
          enable = false;
        });
      }
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '手机号码登录',
          style: TextStyle(fontSize: AppFont.defaultFontSize, color: AppColors.defaultFontColor),
        ),
      ),
      body: SizedBox(
        height: getDeviceHeight(context) * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '手机号',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: AppFont.FontSize13, color: AppColors.defaultFontColor, fontWeight: FontWeight.w500),
                  ),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(top: 8, bottom: 8),
                      hintText: '请输入手机号',
                      hintStyle: TextStyle(color: Color(0xFFB6C2D0), fontSize: AppFont.FontSize15),

                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE5E6EB), width: 0.5), // 设置下划线颜色
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE5E6EB), width: 0.5), // 设置下划线颜色
                      ),
                      focusColor: Color(0xFFB6C2D0),
                      // border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Color(0xFFB6C2D0), fontSize: AppFont.FontSize15),
                    cursorColor: const Color(0xFFB6C2D0),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    '验证码',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: AppFont.FontSize13, color: AppColors.defaultFontColor, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          //number是弹数字键盘，可以自己选者键盘弹出种类
                          keyboardType: TextInputType.number,
                          controller: codeController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6) //限制长度
                          ],
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.only(top: 8, bottom: 8),
                            hintText: '请输入验证码',
                            hintStyle: TextStyle(color: Color(0xFFB6C2D0), fontSize: AppFont.FontSize15),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFE5E6EB), width: 0.5), // 设置下划线颜色
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFE5E6EB), width: 0.5), // 设置下划线颜色
                            ),
                            // border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Color(0xFFB6C2D0), fontSize: AppFont.FontSize15),
                          cursorColor: const Color(0xFFB6C2D0),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.sendCode(phoneController.text);
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                          child: Center(
                            child: Obx(() => Text(
                                  controller.tips.value,
                                  style:
                                      const TextStyle(fontSize: AppFont.FontSize15, color: AppColors.defaultFontColor),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 45,
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0), // 这里设置圆角半径为按钮宽度的一半，以实现椭圆形效果
                    ),
                  ),
                  maximumSize: WidgetStateProperty.all(Size(getDeviceWidth(context), 45)),
                  minimumSize: WidgetStateProperty.all(const Size(343, 45)),
                  backgroundColor:
                      WidgetStateProperty.all(enable ? AppColors.defaultFontColor : const Color(0x881C212A)),
                ),
                onPressed: () {
                  controller.login(phoneController.text, codeController.text);
                },
                child: const Text(
                  '登录',
                  style: TextStyle(fontSize: AppFont.FontSize15, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
