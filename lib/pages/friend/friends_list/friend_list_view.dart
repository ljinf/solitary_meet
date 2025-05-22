import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/pages/friend/friends_list/friend_list_controller.dart';

import '../../../utils/conts.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({Key? key}) : super(key: key);

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  var controller = Get.find<FriendListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('好友列表'),
      ),
      body: Obx(() => ListView.builder(
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  controller.toProfilePage(index);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageView(
                        controller.friendList[index].avatar!,
                        width: defaultWidth,
                        height: defaultHeight,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          controller.friendList[index].remark!,
                          style: const TextStyle(fontSize: defaultFontSize),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: controller.friendList.length,
          )),
    );
  }
}
