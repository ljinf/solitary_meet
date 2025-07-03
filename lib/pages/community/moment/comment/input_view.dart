import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/colors/colors.dart';
import '../../../../common/values/font.dart';
import '../../../../utils/callback.dart';
import '../../../../utils/message.dart';

class InputView extends StatefulWidget {
  late String inputHint;

  OnCallback? callback;

  InputView(this.inputHint, {this.callback, super.key});

  @override
  State<InputView> createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  var txtController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    txtController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F8FA),
              // borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 12, top: 8, bottom: 8, right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      focusNode: _focusNode,
                      controller: txtController,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(0),
                        hintText: widget.inputHint,
                        hintStyle: const TextStyle(
                            color: Color(0xFF83909D),
                            fontSize: AppFont.FontSize14),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        // border: InputBorder.none,
                      ),
                      style: const TextStyle(
                          color: Color(0xFF83909D),
                          fontSize: AppFont.FontSize14),
                      cursorColor: const Color(0xFF83909D),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    var content = txtController.text;
                    if (content.isEmpty) {
                      Message.showToast('请输入内容');
                      return;
                    }
                    widget.callback!(content);
                    Get.back();
                  },
                  child: Container(
                    width: 56,
                    height: 35,
                    decoration: BoxDecoration(
                      color: AppColors.defaultFontColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Center(
                      child: Text(
                        '发表',
                        style: TextStyle(
                            color: Colors.white, fontSize: AppFont.FontSize14),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
