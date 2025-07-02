import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/common/values/font.dart';
import 'package:solitary_meet/pages/mine/user_info/user_info_controller.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../common/colors/colors.dart';
import '../../../common/values/image.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_photo_view.dart';
import '../../../config.dart';
import '../../../utils/avatar.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  var controller = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text(
          '个人资料',
          style: TextStyle(fontSize: AppFont.defaultFontSize),
        ),
        leadingType: AppBarBackType.Back,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                    child: Text(
                  '头像',
                  style: TextStyle(
                      color: AppColors.defaultFontColor,
                      fontSize: AppFont.defaultFontSize),
                )),
                OpenContainer<bool>(
                  transitionType: ContainerTransitionType.fade,
                  openBuilder: (BuildContext context, VoidCallback callback) {
                    return CustomPhotoView(
                        imgList: [(controller.avatar.value)], selected: 0);
                  },
                  closedBuilder:
                      (BuildContext context, VoidCallback openContainer) {
                    return getAvatarView(
                        '$STATIC_ASSETS_URL${controller.avatar.value}', 36);
                  },
                  closedShape: const RoundedRectangleBorder(),
                  closedColor: Colors.white,
                  closedElevation: 0,
                ),
                IconButton(
                    onPressed: () async {
                      List<AssetEntity>? fileList =
                          await AssetPicker.pickAssets(
                        context,
                        pickerConfig: const AssetPickerConfig(
                            selectedAssets: [],
                            maxAssets: 1,
                            themeColor: Color(0xff478384),
                            textDelegate: AssetPickerTextDelegate()),
                      );
                      if (fileList != null && fileList.isNotEmpty) {
                        controller
                            .updateAvatar(fileList[0])
                            .then((v) => setState(() {}));
                      }
                    },
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      size: AppImage.ImageSize24,
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '昵称',
                  style: TextStyle(
                      color: AppColors.defaultFontColor,
                      fontSize: AppFont.defaultFontSize),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Obx(()=>Text(
                      textAlign: TextAlign.end,
                      controller.nickName.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.primaryGreyText,
                          fontSize: AppFont.FontSize14),
                    ))),
                IconButton(
                    onPressed: () async {
                      await controller.updateNickName();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      size: AppImage.ImageSize24,
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '签名',
                  style: TextStyle(
                      color: AppColors.defaultFontColor,
                      fontSize: AppFont.defaultFontSize),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Obx(()=>Text(
                      textAlign: TextAlign.end,
                      controller.selfSignature.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.primaryGreyText,
                          fontSize: AppFont.FontSize14),
                    ))),
                IconButton(
                    onPressed: () async {
                      await controller.updateSelfSignature();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      size: AppImage.ImageSize24,
                    ))
              ],
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                    child: Text(
                  '绑定手机号',
                  style: TextStyle(color: AppColors.defaultFontColor, fontSize: AppFont.FontSize15),
                )),
                phone.isNotEmpty
                    ? Text(
                        phone,
                        style: const TextStyle(color: AppColors.defaultFontColor, fontSize: AppFont.FontSize15),
                      )
                    : GestureDetector(
                        onTap: () {
                          Get.dialog(
                            Center(
                              child: Container(
                                height: 275,
                                margin: const EdgeInsets.only(left: 50, right: 50),
                                child: BindPhoneView(),
                              ),
                            ),
                            useSafeArea: false,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '去绑定',
                              style: TextStyle(color: AppColors.defaultFontColor, fontSize: AppFont.FontSize15),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Image.asset(
                              'assets/icons/back_right.webp',
                              width: 18,
                              height: 18,
                            )
                          ],
                        ),
                      )
              ],
            )*/
          ],
        ),
      ),
    );
  }
}
