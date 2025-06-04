import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/components/custom_expandable_text.dart';
import 'package:solitary_meet/components/custom_grid_view.dart';
import 'package:solitary_meet/model/community.dart';
import 'package:solitary_meet/utils/screen_device.dart';

import '../../../common/colors/colors.dart';
import '../../../common/values/font.dart';
import '../../../common/values/image.dart';
import '../../../config.dart';
import '../../../utils/helper.dart';

class MomentItemView extends StatefulWidget {
  MomentModel moment;

  //点赞评论回调
  Function(int count)? likeCallBack;
  Function(int count)? commentCallBack;

  MomentItemView(this.moment,
      {this.likeCallBack, this.commentCallBack, super.key});

  @override
  State<MomentItemView> createState() => _MomentItemViewState();
}

class _MomentItemViewState extends State<MomentItemView>
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

  @override
  Widget build(BuildContext context) {
    debugPrint('total width ${getDeviceWidth(context)}');
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
      width: getDeviceWidth(context),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ImageView(
            widget.moment.userInfo!.avatar ?? '',
            circular: true,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 2,
                ),
                Text(
                  widget.moment.userInfo!.nickName ?? '',
                  style: const TextStyle(
                    fontSize: AppFont.FontSize18,
                    color: AppColors.defaultFontColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  convertDate((widget.moment.createdAt ?? 0) * 1000),
                  style: const TextStyle(
                    fontSize: AppFont.FontSize14,
                    color: AppColors.primaryGreyText,
                  ),
                ),

                /// 时刻内容
                if ((widget.moment.content ?? '') != '')
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      txtView(widget.moment.content ?? '')
                    ],
                  ),
                if ((widget.moment.attachment ?? []).isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      imgListView(context, widget.moment.attachment ?? [])
                    ],
                  ),

                ///评论点赞
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        //点赞
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  widget.moment.likeStatus == 1
                                      ? 'assets/icons/heart_fill.webp'
                                      : 'assets/icons/heart_line.webp',
                                  width: AppImage.ImageSize20,
                                  height: AppImage.ImageSize20,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  '${(widget.moment.likeCount ?? 0) - (widget.moment.likeCancelCount ?? 0)}',
                                  style: const TextStyle(
                                      fontSize: AppFont.FontSize12,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                        //评论
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/message_line.webp',
                                  width: AppImage.ImageSize20,
                                  height: AppImage.ImageSize20,
                                  // color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  '${widget.moment.commentCount}',
                                  style: const TextStyle(
                                      fontSize: AppFont.FontSize12,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget txtView(String txt) {
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

  Widget imgListView(BuildContext context, List<String> list) {
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

  String convertDate(int timestamp) {
    String formatStr = '';
    if (timestamp == 0) {
      return formatStr;
    }
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
}
