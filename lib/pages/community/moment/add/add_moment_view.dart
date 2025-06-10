import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/components/custom_grid_view.dart';
import 'package:solitary_meet/pages/community/moment/add/add_moment_controller.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../common/values/font.dart';
import '../../../../utils/message.dart';

class AddMomentPage extends StatefulWidget {
  const AddMomentPage({super.key});

  @override
  State<AddMomentPage> createState() => _AddMomentPageState();
}

class _AddMomentPageState extends State<AddMomentPage> {
  var controller = Get.find<AddMomentController>();

  var imgList = <String>[];
  List<AssetEntity>? selectedAssets = [];

  @override
  void initState() {
    super.initState();
  }

  void pick() async {
    List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
          selectedAssets: selectedAssets,
          maxAssets: 9,
          themeColor: Color(0xff478384),
          textDelegate: AssetPickerTextDelegate()),
    );

    if (result != null && result.isNotEmpty) {
      selectedAssets!.clear();

      selectedAssets!.addAll(result);

      imgList.clear();
      for (var item in result) {
        var f = await item.file;
        if (f != null) {
          imgList.add(f.path);
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('add'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.textController,
              minLines: 3,
              maxLines: 5,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                isCollapsed: true,
                hintText: "说点什么呢...",
                contentPadding: EdgeInsets.all(10),
                hintStyle: TextStyle(
                    color: Color(0xFFB6C2D0), fontSize: AppFont.FontSize15),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusColor: Color(0xFFB6C2D0),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                  color: Colors.black, fontSize: AppFont.FontSize15),
              cursorColor: const Color(0xFFB6C2D0),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.all(4),
              child: CustomGridView(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: (imgList.length + 1),
                itemBuilder: (BuildContext context, int index) {
                  if (imgList.isEmpty || index == imgList.length) {
                    return GestureDetector(
                      onTap: pick,
                      child: Container(
                        color: Color(0xffe0e0e0),
                        child: Center(
                          child: Icon(Icons.add_rounded),
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: pick,
                    child: LayoutBuilder(
                        builder: (BuildContext ctx, BoxConstraints cs) {
                      return ImageView(
                        width: cs.maxWidth,
                        height: cs.maxWidth,
                        imgList[index],
                      );
                    }),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      if (imgList.isEmpty &&
                          controller.textController.text == '') {
                        Message.showToast('请输入内容！');
                        return;
                      }
                      Message.showLoading();
                      var result =
                          await controller.upload(selectedAssets ?? []);
                      Message.closeLoading();

                      if (result) {
                        setState(() {
                          controller.textController.clear();
                          imgList.clear();
                          selectedAssets!.clear();
                        });
                      }
                    },
                    child: Text('发布'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
