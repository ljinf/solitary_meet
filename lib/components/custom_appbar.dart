import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solitary_meet/common/colors/colors.dart';
import 'package:solitary_meet/common/values/image.dart';

/// appbar 返回按钮类型
enum AppBarBackType { Back, Close, None }

const double kNavigationBarHeight = 56.0;

// 自定义 AppBar
class CustomAppBar extends AppBar implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    Widget? title,
    AppBarBackType? leadingType,
    WillPopCallback? onWillPop,
    Widget? leading,
    Brightness? brightness,
    Color? backgroundColor,
    List<Widget>? actions,
    bool centerTitle = true,
    double? elevation,
  }) : super(
          key: key,
          title: title,
          centerTitle: centerTitle,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: brightness ?? Brightness.light),
          backgroundColor: backgroundColor ?? AppColors.primaryBackground,
          surfaceTintColor: backgroundColor ?? AppColors.primaryBackground,
          leading: leading ??
              (leadingType == AppBarBackType.None
                  ? Container()
                  : AppBarBack(
                      leadingType ?? AppBarBackType.Back,
                      onWillPop: onWillPop,
                    )),
          actions: actions,
          elevation: elevation ?? 0.5,
        );

  @override
  get preferredSize => Size.fromHeight(kNavigationBarHeight);
}

// 自定义返回按钮
class AppBarBack extends StatelessWidget {
  final AppBarBackType _backType;
  final Color? color;
  final WillPopCallback? onWillPop;

  AppBarBack(this._backType, {this.onWillPop, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final willBack = onWillPop == null ? true : await onWillPop!();
        if (!willBack) return;
        Navigator.pop(context);
      },
      child: _backType == AppBarBackType.Close
          ? Container(
              child: Icon(Icons.close,
                  color: color ?? const Color(0xFF222222), size: AppImage.ImageSize20),
            )
          : Container(
              padding: const EdgeInsets.only(right: 15),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: AppImage.ImageSize20, color: Color(0xFF222222)),
            ),
    );
  }
}

class CustomTitle extends StatelessWidget {
  final String _title;
  final Color? color;

  CustomTitle(this._title, {this.color});

  @override
  Widget build(BuildContext context) {
    return Text(_title,
        style: TextStyle(
            color: color ?? Color(0xFF222222),
            fontSize: 18,
            fontWeight: FontWeight.w500));
  }
}
