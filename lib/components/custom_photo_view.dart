import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:solitary_meet/common/values/font.dart';
import 'package:solitary_meet/components/custom_image_provider.dart';
import 'package:solitary_meet/utils/screen_device.dart';

import '../common/colors/colors.dart';
import '../config.dart';

class CustomPhotoView extends StatefulWidget {
  List<String> imgList;
  int selected = 0;

  CustomPhotoView({required this.imgList, this.selected = 0, super.key});

  @override
  State<CustomPhotoView> createState() => _CustomPhotoViewState();
}

class _CustomPhotoViewState extends State<CustomPhotoView> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.selected);
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      widget.selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoViewGallery.builder(
          scrollPhysics: const ClampingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CustomImageProvider(
                  '$STATIC_ASSETS_URL${widget.imgList[index]}'),
              initialScale: PhotoViewComputedScale.contained,
              // heroAttributes: PhotoViewHeroAttributes(tag: widget.imgList[index].id),
            );
          },
          itemCount: widget.imgList.length,
          loadingBuilder: (context, event) => const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                color: Color(0xFF1C212A),
                strokeWidth: 2,
              ),
            ),
          ),
          //backgroundDecoration: widget.backgroundDecoration,
          pageController: pageController,
          onPageChanged: onPageChanged,
        ),
        if (widget.imgList.length > 1)
          Positioned(
            bottom: 0,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: getDeviceWidth(context),
              child: Center(
                child: Text(
                  '${widget.selected + 1}/${widget.imgList.length}',
                  style: const TextStyle(
                      color: AppColors.primaryGreyText, fontSize: AppFont.FontSize12),
                ),
              ),
            ),
          )
      ],
    );
  }
}
