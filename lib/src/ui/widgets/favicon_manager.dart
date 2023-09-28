import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/ui/widgets/logo/logo_controller.dart';

class FaviconManager extends GetView<LogoController> {
  const FaviconManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final url = controller.faviconUrl.value;
      if (url.isNotEmpty) {
        _changeFavicon(url);
      }
      return const SizedBox.shrink(); // return an empty widget
    });
  }

  void _changeFavicon(String url) {
    final favicon = html.querySelector('link[rel="icon"]');
    if (favicon != null) {
      favicon.setAttribute('href', url);
    } else {
      final newFavicon = html.LinkElement()
        ..setAttribute('rel', 'icon')
        ..setAttribute('href', url);
      html.document.head!.append(newFavicon);
    }
  }
}
