import 'package:flutter/cupertino.dart';

class CustomGridView extends StatelessWidget {
  ///每行显示的列数
  int crossAxisCount;

  ///垂直间距
  double mainAxisSpacing;

  ///水平间距
  double crossAxisSpacing;

  int itemCount;

  Function(BuildContext context, int index) itemBuilder;

  CustomGridView({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        double parentWidth = constraints.maxWidth;
        // debugPrint('LayoutBuilder width $parentWidth');
        double width =
            (parentWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
                crossAxisCount;
        // debugPrint('item width $width');
        double height = width;
        return Wrap(
          spacing: crossAxisSpacing, // 水平间距
          runSpacing: mainAxisSpacing, // 垂直间距
          children: List.generate(itemCount, (index) {
            return SizedBox(
              width: width, // 每行n个项目
              height: height, // 固定高度
              child: itemBuilder(context, index),
            );
          }),
        );
      },
    );
  }
}
