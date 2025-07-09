import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/common/values/image.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/pages/login/init_info/init_info_controller.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../common/values/font.dart';
import '../../../components/custom_photo_view.dart';

class InitInfoPage extends StatefulWidget {
  const InitInfoPage({super.key});

  @override
  State<InitInfoPage> createState() => _InitInfoPageState();
}

class _InitInfoPageState extends State<InitInfoPage> {
  var controller = Get.find<InitInfoController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
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
                  width: AppImage.ImageSize56,
                  height: AppImage.ImageSize56,
                  circular: true,
                ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: AppImage.ImageSize24,
                        height: AppImage.ImageSize24,
                        child: controller.gender == 1
                            ? Image.asset(
                          'assets/icons/checked.webp',
                          width: AppImage.ImageSize24,
                          height: AppImage.ImageSize24,
                        )
                            : Image.asset(
                          'assets/icons/uncheck.webp',
                          width: AppImage.ImageSize24,
                          height: AppImage.ImageSize24,
                        ),
                      ),
                      SizedBox(width: 6,),
                      Image.asset(
                        'assets/icons/icon_men.webp',
                        width: AppImage.ImageSize20,
                        height: AppImage.ImageSize20,
                        color: Color(0xFF0287DE),
                      )
                    ],
                  ),
                  SizedBox(width: 16,),
                  Row(
                    children: [
                      SizedBox(
                        width: AppImage.ImageSize24,
                        height: AppImage.ImageSize24,
                        child: controller.gender == 1
                            ? Image.asset(
                          'assets/icons/checked.webp',
                          width: AppImage.ImageSize24,
                          height: AppImage.ImageSize24,
                        )
                            : Image.asset(
                          'assets/icons/uncheck.webp',
                          width: AppImage.ImageSize24,
                          height: AppImage.ImageSize24,
                        ),
                      ),
                      SizedBox(width: 6,),
                      Image.asset(
                        'assets/icons/icon_women.webp',
                        width: AppImage.ImageSize20,
                        height: AppImage.ImageSize20,
                        color: Color(0xFFFC4182),
                      )
                    ],
                  )
                ],
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.only(
                    left: 12, top: 15, bottom: 15, right: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
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
                    hintText: '请输入昵称',
                    hintStyle: TextStyle(
                        color: Color(0xFF83909D), fontSize: AppFont.FontSize14),
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
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
