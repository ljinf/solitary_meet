import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:solitary_meet/pages/login/login_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var controller = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
          child: Text("登录", style: TextStyle(fontSize: 25.0)),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 0.15))),
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 25.0),
                child: const Text(
                  "邮箱",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
              ),
              Expanded(
                  child: TextField(
                controller: controller.emailController,
                maxLines: 1,
                style: const TextStyle(textBaseline: TextBaseline.alphabetic),
                decoration: const InputDecoration(
                    hintText: "请填写邮箱", border: InputBorder.none),
                onChanged: (text) {},
              ))
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 0.15))),
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 25.0),
                child: const Text(
                  "密码",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
              ),
              Expanded(
                  child: TextField(
                controller: controller.pwdController,
                maxLines: 1,
                obscureText: true,
                style: const TextStyle(textBaseline: TextBaseline.alphabetic),
                decoration: const InputDecoration(
                    hintText: "请填写密码", border: InputBorder.none),
                onChanged: (text) {},
              ))
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.1,
        ),
        BrnSmallMainButton(
          title: '登录',
          bgColor: const Color(0xFF0099CC),
          onTap: () {
            controller.login();
          },
        )
      ],
    ));
  }
}
