import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:solitary_meet/utils/local_storage.dart';
import 'dart:io';
import '../utils/conts.dart';

class ImageView extends StatelessWidget {
  String img;
  double? width;
  double? height;
  BoxFit? fit;

  ///是否圆角
  bool isRadius;

  ///是否圆形 ，默认方形
  bool circular;

  ImageView(
    this.img, {
    super.key,
    this.height = defaultWidth,
    this.width = defaultHeight,
    this.fit = BoxFit.cover,
    this.isRadius = true,
    this.circular = false,
  });

  bool isNetWorkImg(String img) {
    if (img.startsWith("http")) {
      return true;
    }
    return false;
  }

  bool isAssetsImg(String img) {
    if (img.startsWith("assets")) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (isNetWorkImg(img)) {
      image = CachedNetworkImage(
        imageUrl: img,
        width: width,
        height: height,
        fit: fit,
        cacheManager: LocalStorage.getCacheManager(),
      );
    } else if (File(img).existsSync()) {
      image = Image.file(
        File(img),
        width: width,
        height: height,
        fit: fit,
      );
    } else if (isAssetsImg(img)) {
      image = Image.asset(
        img,
        width: width,
        height: height,
        fit: width != null && height != null ? BoxFit.fill : fit,
      );
    } else {
      image = Container(
        decoration: BoxDecoration(
            color: Colors.black26.withOpacity(0.1),
            border:
                Border.all(color: Colors.black.withOpacity(0.2), width: 0.3)),
        child: Image.asset(
          defIcon,
          width: width! - 1,
          height: height! - 1,
          fit: width != null && height != null ? BoxFit.fill : fit,
        ),
      );
    }
    if (circular) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        child: image,
      );
    } else if (isRadius) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
        child: image,
      );
    }
    return image;
  }
}
