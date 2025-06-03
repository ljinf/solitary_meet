import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../common/colors/colors.dart';
import '../common/values/font.dart';

class PullDownHeader extends StatelessWidget {
  const PullDownHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return WaterDropHeader(
      refresh: SizedBox(
        width: 25.0,
        height: 25.0,
        child: defaultTargetPlatform == TargetPlatform.iOS
            ? const CupertinoActivityIndicator(
                color: AppColors.defaultFontColor,
              )
            : const CircularProgressIndicator(
                strokeWidth: 2.0,
                color: AppColors.defaultFontColor,
              ),
      ),
      complete: const Text(
        '刷新已完成',
        style: TextStyle(color: AppColors.defaultFontColor, fontSize: AppFont.FontSize13),
      ),
      waterDropColor: const Color(0xFF1C212A),
    );
  }
}
