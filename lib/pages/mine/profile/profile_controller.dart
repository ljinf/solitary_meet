import 'package:get/get.dart';
import 'package:solitary_meet/model/login_model.dart';
import 'package:solitary_meet/services/services.dart';
import 'package:solitary_meet/utils/message.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../../services/upload.dart';
import '../../../utils/img_cropper.dart';

class ProfileController extends GetxController {
  late UserLoginResponseModel userInfo;

  @override
  void onInit() {
    super.onInit();
    userInfo = UserLoginResponseModel();
    userInfo.userId = Get.arguments['userId'];
    userInfo.avatar = Get.arguments['avatar'];
    userInfo.nickName = Get.arguments['nickName'];
  }

  @override
  void onReady() {
    super.onReady();
  }

  void pickPic(AssetEntity assets) async {
    var source = await assets.file;
    if (source != null) {
      var filePath = await imageCrop(source.path);
      //debugPrint(filePath);
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
        await updateProfile({
          "background": result,
        });
        Message.closeLoading();
      }
    }
  }

  Future<void> updateProfile(Map params) async {
    var resp = await UserAPI.updateProfile(params: {});
    if (resp != null) {
      userInfo.background = resp.background;
    }
  }
}
