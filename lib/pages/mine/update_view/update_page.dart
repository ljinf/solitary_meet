import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/colors/colors.dart';
import '../../../common/values/font.dart';
import '../../../components/custom_appbar.dart';
import '../../../utils/message.dart';
import '../../../utils/screen_device.dart';

class UpdatePage extends StatefulWidget {
  late String title;
  late String content;
  late int limit;
  late Function(String inputTxt) submit;

  UpdatePage(
      {required this.title,
      required this.content,
      this.limit = 10,
      required this.submit,
      super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var contentController = TextEditingController();

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    contentController.text = widget.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: AppFont.FontSize14),
        ),
        leadingType: AppBarBackType.Back,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.only(
                  left: 12, top: 15, bottom: 15, right: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                //number是弹数字键盘，可以自己选者键盘弹出种类
                // keyboardType: TextInputType.number,
                controller: contentController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(widget.limit) //限制长度
                ],
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(0),
                  hintText: '请输入内容',
                  hintStyle: TextStyle(
                      color: Color(0xFF83909D), fontSize: AppFont.FontSize14),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  // border: InputBorder.none,
                ),
                style: const TextStyle(
                    color: Color(0xFF83909D), fontSize: AppFont.FontSize14),
                cursorColor: const Color(0xFF83909D),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50.0), // 这里设置圆角半径为按钮宽度的一半，以实现椭圆形效果
                    ),
                  ),
                  maximumSize: WidgetStateProperty.all(
                      Size(getDeviceWidth(context), 40)),
                  minimumSize: WidgetStateProperty.all(const Size(235, 40)),
                  backgroundColor:
                      WidgetStateProperty.all(AppColors.moderateCyan),
                ),
                onPressed: () async {
                  var content = contentController.text;
                  if (content == "") {
                    Message.showToast("请输入内容");
                    return;
                  }
                  widget.submit(content);
                  Get.back();
                },
                child: const Text(
                  '提交',
                  style: TextStyle(
                      fontSize: AppFont.FontSize14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
