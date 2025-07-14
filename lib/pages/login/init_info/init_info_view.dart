import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/common/values/image.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/pages/login/init_info/init_info_controller.dart';
import 'package:solitary_meet/utils/screen_device.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../common/colors/colors.dart';
import '../../../common/values/font.dart';
import '../../../utils/conts.dart';
import '../../../utils/message.dart';

class InitInfoPage extends StatefulWidget {
  const InitInfoPage({super.key});

  @override
  State<InitInfoPage> createState() => _InitInfoPageState();
}

class _InitInfoPageState extends State<InitInfoPage> {
  var controller = Get.find<InitInfoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGrey2,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: AppColors.primaryGrey2,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  width: getDeviceWidth(context),
                  child: Text(
                    '请输入您的基本信息',
                    style: TextStyle(fontSize: AppFont.FontSize20),
                    textAlign: TextAlign.left,
                  ),
                ),

                ///昵称
                Text(
                  '昵称',
                  style: TextStyle(
                      fontSize: AppFont.defaultFontSize,
                      color: AppColors.defaultFontColor1),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  width: getDeviceWidth(context) * 0.75,
                  height: 50,
                  padding: const EdgeInsets.only(
                      left: 12, top: 15, bottom: 15, right: 12),
                  decoration: BoxDecoration(
                    // color: const Color(0xFFF7F8FA),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    //number是弹数字键盘，可以自己选者键盘弹出种类
                    // keyboardType: TextInputType.number,
                    controller: controller.nickNameController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30) //限制长度
                    ],
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.all(0),
                      hintText: '请输入您的昵称',
                      hintStyle: TextStyle(
                          color: Color(0xFF83909D),
                          fontSize: AppFont.FontSize14),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      // border: InputBorder.none,
                    ),
                    style: const TextStyle(
                        color: Color(0xFF83909D), fontSize: AppFont.FontSize14),
                    cursorColor: const Color(0xFF83909D),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                ///性别
                Text(
                  '性别',
                  style: TextStyle(
                      fontSize: AppFont.defaultFontSize,
                      color: AppColors.defaultFontColor1),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          controller.setGender(man);
                        });
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: AppImage.ImageSize18,
                            height: AppImage.ImageSize18,
                            child: Image.asset(
                              controller.gender == 1
                                  ? 'assets/icons/icon_radio_true.png'
                                  : 'assets/icons/icon_radio_false.png',
                              width: AppImage.ImageSize18,
                              height: AppImage.ImageSize18,
                              color: AppColors.navSelectedColor,
                            ),
                          ),
                          Image.asset(
                            'assets/icons/icon_men.webp',
                            width: AppImage.ImageSize24,
                            height: AppImage.ImageSize24,
                            color: Color(0xFF0287DE),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          controller.setGender(women);
                        });
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: AppImage.ImageSize18,
                            height: AppImage.ImageSize18,
                            child: Image.asset(
                              controller.gender == 2
                                  ? 'assets/icons/icon_radio_true.png'
                                  : 'assets/icons/icon_radio_false.png',
                              width: AppImage.ImageSize18,
                              height: AppImage.ImageSize18,
                              color: AppColors.navSelectedColor,
                            ),
                          ),
                          Image.asset(
                            'assets/icons/icon_women.webp',
                            width: AppImage.ImageSize24,
                            height: AppImage.ImageSize24,
                            color: Color(0xFFFC4182),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '注意：确定后不可修改。',
                  style: TextStyle(
                      fontSize: AppFont.FontSize11,
                      color: AppColors.primaryGrey4),
                ),

                SizedBox(
                  height: 16,
                ),

                ///头像
                Text(
                  '头像',
                  style: TextStyle(
                      fontSize: AppFont.defaultFontSize,
                      color: AppColors.defaultFontColor1),
                ),
                SizedBox(
                  height: 2,
                ),
                InkWell(
                  onTap: () async {
                    List<AssetEntity>? fileList = await AssetPicker.pickAssets(
                      context,
                      pickerConfig: const AssetPickerConfig(
                          selectedAssets: [],
                          maxAssets: 1,
                          themeColor: Color(0xff478384),
                          textDelegate: AssetPickerTextDelegate()),
                    );
                    if (fileList != null && fileList.isNotEmpty) {
                      await controller.updateAvatar(fileList[0]);
                      setState(() {});
                    }
                  },
                  child: ImageView(
                    controller.avatar,
                    width: AppImage.ImageSize66,
                    height: AppImage.ImageSize66,
                    circular: true,
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                Container(
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50.0), // 这里设置圆角半径为按钮宽度的一半，以实现椭圆形效果
                        ),
                      ),
                      maximumSize: WidgetStateProperty.all(
                          Size(getDeviceWidth(context), 52)),
                      minimumSize: WidgetStateProperty.all(const Size(200, 52)),
                      backgroundColor:
                          WidgetStateProperty.all(AppColors.moderateCyan),
                    ),
                    onPressed: () {
                      if (controller.nickNameController.text == '') {
                        Message.showInfo('请输入昵称');
                        return;
                      }
                      if (controller.avatar == '') {
                        Message.showInfo('请选择头像');
                        return;
                      }
                      controller.submitInfo();
                    },
                    child: const Text(
                      '提交',
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
        ),
      ),
    );
  }
}
