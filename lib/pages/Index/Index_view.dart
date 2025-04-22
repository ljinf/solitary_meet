import 'package:flutter/material.dart';
import 'package:solitary_meet/pages/Index/Index_controller.dart';
import 'package:solitary_meet/pages/splash/spalsh_view.dart';
import 'package:get/get.dart';

class IndexPage extends GetView<IndexController> {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<IndexController>();
    return const SplashPage();
  }
}
