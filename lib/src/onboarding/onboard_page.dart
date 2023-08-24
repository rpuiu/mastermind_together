import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';

class OnboardPage extends StatelessWidget {
  final Color color;
  final String urlImage;
  final String title;
  final String subtitle;

  const OnboardPage({Key? key, required this.color, required this.urlImage, required this.title, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            urlImage,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          xxxxSpace,
          Text(
            title,
            style: TextStyle(
              color: Colors.teal.shade700,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          xHalfSpace,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              subtitle,
              style: TextStyle(color: Colors.black45),
            ),
          )
        ],
      ),
    );
  }
}
