import 'package:solitary_meet/utils/request.dart';

class UploadAPI {
  static Future<String> uploadFile({required Map<String,dynamic> params}) async {
    var result = await Request().postForm("/v1/upload", params: params);

    if (result != null) {
      return result['data'];
    }

    return "";
  }
}
