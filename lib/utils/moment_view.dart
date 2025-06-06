import 'package:flutter/material.dart';
import 'package:solitary_meet/utils/screen_device.dart';

import '../common/colors/colors.dart';
import '../common/values/font.dart';
import '../common/values/image.dart';
import '../components/custom_expandable_text.dart';
import '../components/custom_grid_view.dart';
import '../components/custom_image.dart';
import '../config.dart';
import 'helper.dart';

Widget momentTxtView(String txt) {
  return CustomExpandableText(
    linkColor: Color(0xFF00a3af),
    text: txt,
    style: const TextStyle(
        fontSize: AppFont.FontSize16,
        color: AppColors.defaultFontColor,
        height: 1.2,
        letterSpacing: 1.0),
  );
}

Widget momentImgListView(BuildContext context, List<String> list) {
  var num = list.length;
  if (num < 2) {
    //默认宽高
    double width = getDeviceWidth(context) / 3;
    double height = width + 100;
    //原始宽高
    var wh = getWidthHeight(getFileName(list[0]));
    if (wh.isNotEmpty) {
      //按比例缩小图片的尺寸
      var resize = resizeImageProportionally(context, wh[0], wh[1]);
      if (resize.isNotEmpty) {
        width = resize[0];
        height = resize[1];
      }
    }
    return ImageView(
      "$STATIC_ASSETS_URL${list[0]}",
      width: width,
      height: height,
    );
  }

  return CustomGridView(
    crossAxisCount: 3,
    crossAxisSpacing: 6,
    mainAxisSpacing: 6,
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      return LayoutBuilder(builder: (BuildContext ctx, BoxConstraints cs) {
        return ImageView(
          width: cs.maxWidth,
          height: cs.maxWidth,
          "$STATIC_ASSETS_URL${list[index]}",
        );
      });
    },
  );
}

Widget likeView(int status) {
  //#fc5531
  return Image.asset(
    status == 1
        ? 'assets/icons/heart_fill.webp'
        : 'assets/icons/heart_line.webp',
    width: AppImage.ImageSize20,
    height: AppImage.ImageSize20,
    color: status == 1 ? Color(0xFFfc5531) : Color(0xFFA7A6A7),
  );
}
