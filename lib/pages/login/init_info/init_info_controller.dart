import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../services/upload.dart';
import '../../../utils/img_cropper.dart';
import '../../../utils/message.dart';
import 'package:dio/dio.dart' as dio;

class InitInfoController extends GetxController {
  String avatar = '';
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

  Future<void> updateAvatar(AssetEntity assets) async {
    var source = await assets.file;
    if (source != null) {
      var filePath = await imageCrop(source.path);
      avatar = filePath ?? '';
      //debugPrint(filePath);
      /*if (filePath != null && filePath != "") {
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
        await updateUserBackground({
          "background": result,
        });
        Message.closeLoading();
      }*/
    }
  }
}
