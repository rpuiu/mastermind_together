import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Cannot launch $url';
    }
  } catch (e) {
    rethrow;
  }
}
