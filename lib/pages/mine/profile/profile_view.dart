import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/pages/mine/profile/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        ImageView(
          controller.userInfo.avatar!,
          width: 100,
          height: 100,
        ),
        Text(controller.userInfo.nickName!),
      ],
    ));
  }
}
