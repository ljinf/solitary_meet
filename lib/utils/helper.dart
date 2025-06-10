import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'dart:math';

import 'package:solitary_meet/utils/screen_device.dart';

/// 时间戳（秒）转 YYYY-MM-DD 字符串
String parseDateTime(int timestamp, String format) {
  if (timestamp == 0) {
    return '';
  }
  // 将时间戳转换为 DateTime 对象
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  // 格式化 DateTime 对象为 YYYY-MM-DD 字符串
  String formattedDate = DateFormat(format).format(dateTime);
  return formattedDate;
}

///手机号校验函数
///大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数
/// 此方法中前三位格式有：
/// 13+任意数 * 15+除4的任意数 * 18+除1和4的任意数 * 17+除9的任意数 * 147
// bool validatePhoneNumber(String value) {
//   // 这里可以根据需求调整正则表达式
//   // final phoneRegex = RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
//
//   //中国大陆的手机号码通常以 1 开头，第二位可以是 3-9 中的任意一个数字，剩下的9位是数字 0-9
//   final phoneRegex = RegExp('^1[3-9]\\d{9}\$');
//   if (value.isEmpty) {
//     Message.showError('请输入手机号码');
//     return false;
//   } else if (!phoneRegex.hasMatch(value)) {
//     Message.showError('请输入正确的手机号码');
//     return false;
//   }
//   return true;
// }

String convertMomentDate(int timestamp) {
  String formatStr = '';
  if (timestamp == 0) {
    return formatStr;
  }
  DateTime curTime = DateTime.now();
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
  if (curTime.year != dateTime.year) {
    formatStr =
        DateFormat('yyyy年MM月dd HH:mm').format(dateTime); //yyyy-MM-dd HH:mm:ss
  } else if (curTime.day == dateTime.day) {
    formatStr = DateFormat('HH:mm').format(dateTime); //yyyy-MM-dd HH:mm:ss
  } else if (curTime.day == dateTime.day + 1) {
    formatStr = '昨天 ${DateFormat('HH:mm').format(dateTime)}';
  } else {
    formatStr = DateFormat('MM月dd日 HH:mm').format(dateTime);
  }
  return formatStr;
}

/// 获取文件名（包含扩展名）
String getFileName(String filePath) {
  return path.basename(filePath);
}

/// [0]:width  [1]:height
List<double> getWidthHeight(String str) {
  var list = <double>[];
  List<String> wh = str.split("_");

  if (wh.isNotEmpty) {
    List<String> t = (wh[0].toUpperCase()).split("X");

    if (t.length > 1) {
      //width
      list.add(double.parse(t[0]));
      //height
      list.add(double.parse(t[1]));
    }
  }

  return list;
}

///按比例缩小图片的尺寸 [0]:new_width  [1]:new_height
List<double> resizeImageProportionally(
    BuildContext context, double originalWidth, double originalHeight,
    {double targetWidth = 0, double targetHeight = 0}) {
  var list = <double>[];
  if (targetWidth != 0 && targetHeight != 0) {
    // 如果同时指定了宽度和高度，则按比例调整
    var widthRatio = targetWidth / originalWidth;
    var heightRatio = targetHeight / originalHeight;
    var ratio = min(widthRatio, heightRatio) * 0.2;
    //new_width
    list.add(originalWidth * ratio);
    //new_height
    list.add(originalHeight * ratio);
  } else if (targetWidth != 0) {
    // 如果只指定了宽度，则按比例调整高度
    var ratio = (targetWidth / originalWidth) * 0.2;
    //new_width
    list.add(targetWidth);
    //new_height
    list.add(originalHeight * ratio);
  } else if (targetHeight != 0) {
    // 如果只指定了高度，则按比例调整高度
    var ratio = (targetHeight / originalHeight) * 0.2;
    //new_width
    list.add(originalWidth * ratio);
    //new_height
    list.add(targetHeight);
  } else {
    // 如果都没有指定宽度和高度

    // 基准分辨率
    double baseResolution =
        (getDeviceWidth(context) * getDeviceHeight(context)) * 0.5; // 设置基准分辨率
    // 计算分辨率
    double resolution = originalWidth * originalHeight;
    // 计算缩小比例
    double scaleFactor;
    if (resolution > baseResolution) {
      // 分辨率大于基准分辨率，缩小倍数较大
      scaleFactor = baseResolution / resolution;
    } else {
      // 分辨率小于或等于基准分辨率，缩小倍数较小
      scaleFactor = 0.8; // 不缩小或按需调整
    }

    // 计算新的宽度和高度
    //new_width
    list.add(originalWidth * scaleFactor);
    //new_height
    list.add(originalHeight * scaleFactor);
  }

  return list;
}
