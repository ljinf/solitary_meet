import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/pages/search/search_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var pageController = Get.find<FindController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrnSearchAppbar(
        leading: '搜索',
        leadClickCallback: (controller, update) {
          BrnToast.show(controller.text, context);
        },
        //输入框 文本内容变化的监听
        searchBarInputChangeCallback: (input) {
          // BrnToast.show(input, context);
        },
        //输入框 键盘确定的监听
        searchBarInputSubmitCallback: (input) {
          pageController.search();
        },
        //为输入框添加 文本控制器，如果不传则使用默认的
        controller: pageController.textEditingController,
        //为输入框添加 焦点控制器，如果不传则使用默认的
        focusNode: pageController.focusNode,
        dismissClickCallback: (controller, update) {
          Get.back();
        },
      ),
      body: Container(
        color: Colors.white,
        child: Obx(() => ListView.builder(
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    pageController.toProfilePage(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf9f7f7),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageView(pageController.list[index].avatar!),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(pageController.list[index].account!),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: pageController.list.length,
            )),
      ),
    );
  }
}
