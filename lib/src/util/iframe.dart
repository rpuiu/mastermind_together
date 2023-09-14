import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Iframe extends StatelessWidget {
  final String src;
  final double width;
  final double height;

  const Iframe({
    super.key,
    required this.src,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Unique ID to identify the HTML element
    final String uniqueId = UniqueKey().toString();

    // Create an IFrame element
    final html.IFrameElement iframeElement = html.IFrameElement()
      ..width = width.toInt().toString()
      ..height = height.toInt().toString()
      ..src = src
      ..style.border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      uniqueId,
      (int viewId) => iframeElement,
    );

    return SizedBox(
      width: width,
      height: height,
      child: HtmlElementView(
        viewType: uniqueId,
      ),
    );
  }
}
