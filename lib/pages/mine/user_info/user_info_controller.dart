import 'package:get/get.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/pages/mine/update_view/update_page.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../services/upload.dart';
import '../../../services/user.dart';
import '../../../utils/img_cropper.dart';
import '../../../utils/message.dart';
import 'package:dio/dio.dart' as dio;

class UserInfoController extends GetxController {
  var avatar = ''.obs;
  var nickName = ''.obs;
  var selfSignature = ''.obs;

  @override
  void onInit() {
    avatar.value = Global.userProfile?.avatar ?? '';
    nickName.value = Global.userProfile?.nickName ?? '';
    selfSignature.value = Global.userProfile?.selfSignature ?? '';
    super.onInit();
  }

  Future<void> updateAvatar(AssetEntity assets) async {
    var source = await assets.file;
    if (source != null) {
      var filePath = await imageCrop(source.path);
      if (filePath != null && filePath != "") {
        Message.showLoading();
        // 创建MultipartFile对象
        dio.MultipartFile fileData = await dio.MultipartFile.fromFile(
          filePath,
          filename:
              "${const Uuid().v4()}${filePath.substring(filePath.lastIndexOf('.'))}",
        );

        var result = await UploadAPI.uploadFile(
          params: {
            'file': fileData, // 'file'是后端接收文件的字段名
            'size': "${assets.width}X${assets.height}"
          },
        );
        var resp = await UserAPI.updateProfile(params: {"avatar": result});
        if (resp != null && resp.avatar != '') {
          avatar.value = resp.avatar ?? '';

          Global.userProfile?.avatar = resp.avatar;
          Global.saveProfile(Global.userProfile!);
        }

        Message.closeLoading();
      }
    }
  }

  Future<void> updateNickName() async {
    return Get.dialog(
      UpdatePage(
          title: '编辑昵称',
          content: nickName.value,
          limit: 20,
          submit: (content) {
            UserAPI.updateProfile(params: {"nick_name": content}).then((resp) {
              if (resp != null && resp.nickName != '') {
                nickName.value = resp.nickName ?? '';
                Global.userProfile?.nickName = resp.nickName;
                Global.saveProfile(Global.userProfile!);
              }
            });
          }),
      useSafeArea: false,
    );
  }

  Future<void> updateSelfSignature() async {
    return Get.dialog(
      UpdatePage(
          title: '编辑签名',
          content: selfSignature.value,
          limit: 50,
          submit: (content) {
            UserAPI.updateProfile(params: {"self_signature": content})
                .then((resp) {
              if (resp != null && resp.selfSignature != '') {
                selfSignature.value = resp.selfSignature ?? '';
                Global.userProfile?.selfSignature = resp.selfSignature;
                Global.saveProfile(Global.userProfile!);
              }
            });
          }),
      useSafeArea: false,
    );
  }
}
