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
  Color? color;

  ///是否圆角
  bool isRadius;

  ///是否圆形 ，默认方形
  bool circular;

  ImageView(
    this.img, {
    super.key,
    this.height = defaultWidth,
    this.width = defaultHeight,
    this.color,
    this.fit = BoxFit.cover,
    this.isRadius = true,
    this.circular = false,
  });

  bool isNetWorkImg(String img) {
    return img.startsWith("http");
  }

  bool isAssetsImg(String img) {
    return img.startsWith("assets") || img.startsWith("/assets");
  }

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (isNetWorkImg(img)) {
      image = CachedNetworkImage(
        imageUrl: img,
        width: width,
        height: height,
        color: color,
        fit: fit,
        cacheManager: LocalStorage.getCacheManager(),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/placeholder.png',
          width: width,
          height: height,
        ),
      );
    } else if (File(img).existsSync()) {
      image = Image.file(
        File(img),
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, url, error) => Image.asset(
          'assets/images/placeholder.png',
          width: width,
          height: height,
        ),
      );
    } else if (isAssetsImg(img)) {
      image = Image.asset(
        img,
        width: width,
        height: height,
        color: color,
        fit: width != null && height != null ? BoxFit.fill : fit,
        errorBuilder: (context, url, error) => Image.asset(
          'assets/images/placeholder.png',
          width: width,
          height: height,
        ),
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
          color: color,
          fit: width != null && height != null ? BoxFit.fill : fit,
          errorBuilder: (context, url, error) => Image.asset(
            'assets/images/placeholder.png',
            width: width,
            height: height,
          ),
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
