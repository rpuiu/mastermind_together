import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CommonAuthLayout extends StatelessWidget {
  final Widget form;

  const CommonAuthLayout({required this.form, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(2 * fontSize),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3 * fontSize),
                      SvgPicture.asset(width: 308, height: 30, 'assets/images/logo/logo-small-black.svg'),
                      const SizedBox(height: 3 * fontSize),
                      form,
                      const SizedBox(height: 3 * fontSize),
                      Text(
                        '© 2023 ALL RIGHTS RESERVED MASTERMINDTOGETHER',
                        textAlign: TextAlign.center,
                        style: copyrightTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
