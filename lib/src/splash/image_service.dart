import 'dart:async';

import 'package:flutter/material.dart';

class ImageService {
  Future<Size> cacheImage(BuildContext context, String url) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.network(url);
    await precacheImage(image.image, context);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          final Size size = Size(image.image.width.toDouble(), image.image.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }
}
