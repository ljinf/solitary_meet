import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solitary_meet/common/colors/colors.dart';
import 'package:solitary_meet/common/values/font.dart';
import 'package:solitary_meet/common/values/image.dart';
import '../model/msg_model.dart';
import '../utils/conts.dart';
import 'custom_image.dart';

class CustomConversation extends StatefulWidget {
  //会话id
  String convId;
  String imageUrl;
  String title;
  MsgModel? recentMsg; //最新消息
  int readSeq = 0; //已读序列号
  bool isBorder;

  CustomConversation(
      {required this.convId,
      required this.imageUrl,
      required this.title,
      this.recentMsg,
      this.readSeq = 0,
      this.isBorder = true,
      super.key});

  @override
  State<CustomConversation> createState() => _CustomConversationState();
}

class _CustomConversationState extends State<CustomConversation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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

  String convertDate(int timestamp) {
    if (timestamp == 0) {
      return '';
    }
    String formatStr = '';
    DateTime curTime = DateTime.now();
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
    if (curTime.year != dateTime.year) {
      formatStr =
          DateFormat('yyyy年MM月dd').format(dateTime); //yyyy-MM-dd HH:mm:ss
    } else if (curTime.day == dateTime.day) {
      formatStr = DateFormat('HH:mm').format(dateTime); //yyyy-MM-dd HH:mm:ss
    } else if (curTime.day == dateTime.day + 1) {
      formatStr = '昨天';
    } else {
      formatStr = DateFormat('MM-dd').format(dateTime);
    }
    return formatStr;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ImageView(widget.imageUrl,
              circular: true,
              height: defaultWidth,
              width: defaultHeight,
              fit: BoxFit.cover),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // 必需设置为1来使用ellipsis
                        style: const TextStyle(
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 5.0),
                      if (widget.recentMsg != null)
                        Text(
                          widget.recentMsg!.content ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // 必需设置为1来使用ellipsis
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                              height: 1.5,
                              letterSpacing: 1.0),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // const Space(width: mainSpace),
                if (widget.recentMsg != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        convertDate((widget.recentMsg!.sendTime ?? 0) * 1000),
                        style: const TextStyle(
                            fontSize: AppFont.FontSize12,
                            color: Colors.black45),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      if ((widget.recentMsg!.seq ?? 0) > widget.readSeq)
                        Container(
                          width: AppImage.ImageSize18,
                          height: AppImage.ImageSize18,
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(50),
                            shape: BoxShape.rectangle,
                          ),
                          // padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Text(
                              '${(widget.recentMsg!.seq ?? 0) - widget.readSeq}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFont.FontSize11),
                            ),
                          ),
                        )
                    ],
                  )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
