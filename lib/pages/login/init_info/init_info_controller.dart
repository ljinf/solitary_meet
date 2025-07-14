import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/services.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../services/upload.dart';
import '../../../utils/img_cropper.dart';
import '../../../utils/message.dart';
import 'package:dio/dio.dart' as dio;

class InitInfoController extends GetxController {
  String avatar = '';
  AssetEntity? avatarAssets;
  String nickName = '';
  String selfSignature = '';
  int gender = 1; //性别 1男 2女

  var nickNameController = TextEditingController();
  var selfSignatureController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void setGender(int g) {
    gender = g;
  }

  Future<String> updateAvatar(AssetEntity assets) async {
    avatarAssets = assets;
    var source = await assets.file;
    if (source != null) {
      var filePath = await imageCrop(source.path);
      avatar = filePath ?? '';
      debugPrint(filePath);
    }
    return "";
  }

  Future<String> uploadAvatar() async {
    var source = await avatarAssets?.file;
    if (source != null) {
      var filePath = source.path;
      if (filePath != "") {
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
            'size': "${avatarAssets?.width}X${avatarAssets?.height}"
          },
        );
        Message.closeLoading();
        return result;
      }
    }
    return "";
  }

  Future<void> submitInfo() async {
    String avatar = await uploadAvatar();
    nickName = nickNameController.text;
    selfSignature = selfSignatureController.text;
    var resp = await UserAPI.updateProfile(params: {
      "avatar": avatar,
      "nick_name": nickName,
      "self_signature": selfSignature,
      "gender": gender,
    });

    if (resp != null) {
      Global.userProfile?.avatar = resp.avatar;
      Global.userProfile?.nickName = resp.nickName;
      Global.userProfile?.selfSignature = resp.selfSignature;
      Global.userProfile?.gender = resp.gender;
      Global.saveProfile(Global.userProfile!);

      Get.offAllNamed(AppRoutes.Home);
    }
  }
}
