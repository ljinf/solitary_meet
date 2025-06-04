import 'package:flutter/material.dart';

class CustomExpandableText extends StatefulWidget {
  int maxLine; // 最大显示行数
  bool isExpand; // 全文、收起 的状态
  String text;
  TextStyle? style;
  Color? linkColor;

  CustomExpandableText({
    this.maxLine = 3,
    this.isExpand = false,
    required this.text,
    this.style,
    this.linkColor = Colors.grey,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomExpandableText> createState() => _RichTextState();
}

class _RichTextState extends State<CustomExpandableText> {
  @override
  Widget build(BuildContext context) {
    if (isExpansion(context, widget.text)) {
      if (widget.isExpand) {
        //展开时
        return Column(
          children: <Widget>[
            Text(
              widget.text,
              textAlign: TextAlign.left,
              style: widget.style,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  _isShowText();
                },
                child: Text(
                  "收起",
                  style: TextStyle(color: widget.linkColor),
                ),
              ),
            ),
          ],
        );
      }
      //收起时
      return Column(
        children: <Widget>[
          Text(
            widget.text,
            maxLines: widget.maxLine,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: widget.style,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                _isShowText();
              },
              child: Text(
                "展开",
                style: TextStyle(color: widget.linkColor),
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        widget.text,
        maxLines: widget.maxLine,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: widget.style,
      );
    }
  }

  ///判断文本是否需要截断
  bool isExpansion(BuildContext context, String text) {
    TextPainter _textPainter = TextPainter(
        maxLines: widget.maxLine,
        text: TextSpan(text: text, style: widget.style),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: MediaQuery.of(context).size.width * 0.8);
    return _textPainter.didExceedMaxLines;
  }

  void _isShowText() {
    ///点击时状态取反；关闭 或 打开
    setState(() {
      widget.isExpand = !widget.isExpand;
    });
  }
}
