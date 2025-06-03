import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../common/colors/colors.dart';
import '../common/values/font.dart';

class PullUpHeader extends StatelessWidget {
  const PullUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body =
              const Text("上拉加载更多", style: TextStyle(color: AppColors.defaultFontColor, fontSize: AppFont.FontSize13));
        } else if (mode == LoadStatus.loading) {
          body = const CupertinoActivityIndicator(
            color: AppColors.defaultFontColor,
          );
        } else if (mode == LoadStatus.failed) {
          body = const Text("加载失败，点击重试！",
              style: TextStyle(color: AppColors.defaultFontColor, fontSize: AppFont.FontSize13));
        } else if (mode == LoadStatus.canLoading) {
          body =
              const Text("释放执行加载", style: TextStyle(color: AppColors.defaultFontColor, fontSize: AppFont.FontSize13));
        } else {
          body =
              const Text("我是有底线的！", style: TextStyle(color: AppColors.defaultFontColor, fontSize: AppFont.FontSize13));
        }
        return SizedBox(
          height: 50,
          child: Center(child: body),
        );
      },
    );
  }
}
