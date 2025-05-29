import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solitary_meet/common/values/font.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/utils/conts.dart';
import 'package:solitary_meet/utils/screen_device.dart';

class CustomMessage extends StatefulWidget {
  String? name;
  String avatar;
  String content;
  int contentType;
  bool isSelf; //是否自己
  int? sendTime;

  CustomMessage(this.avatar, this.content, this.contentType, this.isSelf,
      {this.name = "", this.sendTime = 0, Key? key})
      : super(key: key);

  @override
  State<CustomMessage> createState() => _CustomMessageState();
}

class _CustomMessageState extends State<CustomMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double imgSize = 42.0;
  double fontSize = AppFont.FontSize16;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget genView(BuildContext ctx) {
    if (widget.contentType == contentTypeTxt) {
      return txtView(ctx);
    }
    return Container();
  }

  Widget txtView(BuildContext ctx) {
    if (widget.isSelf) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.sendTime! > 0)
            Container(
              margin: const EdgeInsets.only(
                bottom: mainSpace,
                top: mainSpace,
              ),
              child: Text(
                convertDate(widget.sendTime! * 1000),
                style: const TextStyle(
                    fontSize: AppFont.FontSize13, color: Colors.black45),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(
                left: 10, right: 10, top: 0, bottom: mainSpace),
            child: SizedBox(
              width: getDeviceWidth(ctx),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.all(10),
                    constraints:
                        BoxConstraints(maxWidth: getDeviceWidth(ctx) * 0.65),
                    decoration: const BoxDecoration(
                      // color: Color(0xFFd6e4f0),
                      color: Color(0xFFe6f2ff),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                    ),
                    child: Text(widget.content,
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: Colors.black, fontSize: fontSize)),
                  ),
                  ImageView(widget.avatar,
                      circular: true,
                      height: imgSize,
                      width: imgSize,
                      fit: BoxFit.cover),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.sendTime! > 0)
          Container(
            margin: const EdgeInsets.only(
              bottom: mainSpace,
              top: mainSpace,
            ),
            child: Text(
              convertDate(widget.sendTime! * 1000),
              style: const TextStyle(
                  fontSize: AppFont.FontSize13, color: Colors.black45),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(
              left: 10, right: 46, top: 0, bottom: mainSpace),
          child: SizedBox(
            width: getDeviceWidth(ctx),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ImageView(widget.avatar,
                    circular: true,
                    height: imgSize,
                    width: imgSize,
                    fit: BoxFit.cover),
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.all(10),
                  constraints:
                      BoxConstraints(maxWidth: getDeviceWidth(ctx) * 0.65),
                  decoration: const BoxDecoration(
                    color: Color(0xFFf2f2f2),//f5f5f5  #f6f6f6
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                  ),
                  child: Text(widget.content,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(color: Colors.black, fontSize: fontSize)),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  String convertDate(int timestamp) {
    String formatStr = '';
    DateTime curTime = DateTime.now();
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
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

  @override
  Widget build(BuildContext context) {
    return genView(context);
  }
}
