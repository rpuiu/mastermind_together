import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/util/url_launcher.dart';

class LinkText {
  BuildContext context;
  // TextStyle textStyle;
  Color color;

  LinkText(this.context, this.color);

  Text buildTextWithLinks(String textToLink) => Text.rich(TextSpan(children: _linkify(textToLink)));

  WidgetSpan _buildLinkComponent(String text, String linkToOpen) {
    return WidgetSpan(
      child: InkWell(
        child: Text(
          text,
          style: labelText.copyWith(decoration: TextDecoration.underline, color: color),
        ),
        onTap: () => launchURL(linkToOpen),
      ),
    );
  }

  List<InlineSpan> _linkify(String text) {
    List<LinkifyElement> linkifyElements = linkify(text);
    final List<InlineSpan> widgetList = <InlineSpan>[];

    for (LinkifyElement e in linkifyElements) {
      if (e is UrlElement) {
        widgetList.add(_buildLinkComponent(e.url, e.url));
      } else {
        widgetList.add(TextSpan(text: e.text, style: TextStyle(color: color)));
      }
    }
    return widgetList;
  }
}
