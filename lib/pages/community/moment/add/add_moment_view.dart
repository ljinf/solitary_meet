import 'dart:io';

import 'package:flutter/material.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/components/custom_grid_view.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddMomentPage extends StatefulWidget {
  const AddMomentPage({super.key});

  @override
  State<AddMomentPage> createState() => _AddMomentPageState();
}

class _AddMomentPageState extends State<AddMomentPage> {
  var imgList = <File>[];
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
          imgList.add(f);
        }
      }
      setState(() {});
    }
  }

  /*Future<MultipartFile> multipartFileFromAssetEntity(AssetEntity entity) async {

    MultipartFile mf;
    // Using the file path.
    final file = await entity.file;
    if (file == null) {
      throw StateError('Unable to obtain file of the entity ${entity.id}.');
    }
    mf = await MultipartFile.fromFile(file.path);
    // Using the bytes.
    final bytes = await entity.originBytes;
    if (bytes == null) {
      throw StateError('Unable to obtain bytes of the entity ${entity.id}.');
    }
    mf = MultipartFile.fromBytes(bytes);
    return mf;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('add'),
        actions: [
          IconButton(
              onPressed: () {
                pick();
              },
              icon: const Icon(Icons.add_rounded))
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              maxLines: 5,
            ),
            Container(
              margin: const EdgeInsets.all(4),
              child: CustomGridView(
                crossAxisCount: 3,
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
                        imgList[index].path,
                      );
                    }),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
