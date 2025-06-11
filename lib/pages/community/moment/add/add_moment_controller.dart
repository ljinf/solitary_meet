import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:solitary_meet/services/community.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../services/upload.dart';
import '../../../../utils/message.dart';

class AddMomentController extends GetxController {
  var textController = TextEditingController();

  bool public = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<bool> upload(List<AssetEntity> selectedAssets) async {
    var imgList = <String>[];
    for (var item in selectedAssets) {
      var file = await item.file;
      if (file != null) {
        // 创建MultipartFile对象
        dio.MultipartFile fileData = await dio.MultipartFile.fromFile(
          file.path,
          filename:
              "${const Uuid().v4()}${file.path.substring(file.path.lastIndexOf('.'))}",
        );

        var result = await UploadAPI.uploadFile(
          params: {
            'file': fileData, // 'file'是后端接收文件的字段名
            'size': "${item.width}X${item.height}"
          },
        );
        debugPrint(result);
        imgList.add(result);
      }
    }

    var params = {
      "content": textController.text,
      "attachment": imgList,
      "attachment_type": 1,
      "public": public ? 1 : 2
    };

    var result = await CommunityAPI.addMoment(params, loading: false);
    if (result == 'ok') {
      Message.showInfo('发表成功！');
      return true;
    }

    return false;
  }
}
