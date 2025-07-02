import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget getAvatarView(String avatar, double size) {
  if (avatar.isNotEmpty) {
    return CachedNetworkImage(
      width: size,
      height: size,
      imageUrl: avatar,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle, // 或者使用 CircleBorder()
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            color: Color(0xFF1C212A),
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/default_avatar.png',
        color: const Color(0xFFB6C2D0),
        width: size,
        height: size,
      ),
    );
  }
  return Image.asset(
    'assets/images/default_avatar.png',
    color: const Color(0xFFB6C2D0),
    width: size,
    height: size,
  );
}
