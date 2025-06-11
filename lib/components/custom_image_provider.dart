import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomImageProvider extends ImageProvider<Object> {
  final String imageUrl;

  CustomImageProvider(this.imageUrl);



  @override
  ImageStreamCompleter loadBuffer(Object key, DecoderBufferCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
    );
  }

  Future<ui.Codec> _loadAsync(Object key, DecoderBufferCallback decode) async {
    final cacheManager = DefaultCacheManager();
    final file = await cacheManager.getSingleFile(imageUrl);
    final bytes = await file.readAsBytes();
    // 将 Uint8List 转换为 ImmutableBuffer
    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<Object>(imageUrl);
  }
}
