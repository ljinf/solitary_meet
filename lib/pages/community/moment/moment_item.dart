import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/model/community.dart';
import 'package:solitary_meet/utils/screen_device.dart';

import '../../../common/colors/colors.dart';
import '../../../common/values/font.dart';

class MomentItemView extends StatefulWidget {
  MomentModel moment;

  MomentItemView(this.moment, {super.key});

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
    return Container(
      width: getDeviceWidth(context),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ImageView(
            widget.moment.userInfo!.avatar ?? '',
            circular: true,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.moment.userInfo!.nickName ?? '',
                  style: const TextStyle(
                    fontSize: AppFont.defaultFontSize,
                    color: AppColors.defaultFontColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  convertDate((widget.moment.createdAt ?? 0) * 1000),
                  style: const TextStyle(
                    fontSize: AppFont.defaultFontSize,
                    color: AppColors.defaultFontColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                txtView(widget.moment.content ?? ''),
                if ((widget.moment.attachment ?? []).isNotEmpty)
                  imgListView(context, widget.moment.attachment ?? [])
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget txtView(String txt) {
    return Text(
      txt,
      style: const TextStyle(
          fontSize: AppFont.FontSize16,
          color: AppColors.defaultFontColor,
          height: 1.5,
          letterSpacing: 2.0),
    );
  }

  Widget imgListView(BuildContext context, List<String> list) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Expanded(child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 设置每行显示的列数
            ),
            itemCount: 10, // 设置网格项的数量
            itemBuilder: (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.green[100 * (index % 9 + 1)],
                child: Text(
                  'Item $index',
                  style: TextStyle(fontSize: 20),
                ),
              );
            },
          )),
        ],
      ),
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
