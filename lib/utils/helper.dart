import 'package:intl/intl.dart';

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
