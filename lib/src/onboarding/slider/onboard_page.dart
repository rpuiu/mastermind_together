import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class OnboardPage extends StatelessWidget {
  final Color color;
  final String urlImage;
  final String title;
  final String subtitle;

  const OnboardPage({
    Key? key,
    required this.color,
    required this.urlImage,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: color,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Center(
                  child: Image.asset(
                    urlImage,
                    width: constraints.maxWidth,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SizedBox(
              width: screenWidth / 1.5,
              child: Column(
                children: [
                  xxSpace,
                  Text(title, style: welcomeTextStyle, textAlign: TextAlign.left),
                  xSpace,
                  Text(subtitle, style: subtitleTextStyle, textAlign: TextAlign.left),
                  xxxSpace
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
