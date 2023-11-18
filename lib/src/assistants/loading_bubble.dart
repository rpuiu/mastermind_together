import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class LoadingBubble extends StatefulWidget {
  const LoadingBubble({super.key});

  @override
  LoadingBubbleState createState() => LoadingBubbleState();
}

class LoadingBubbleState extends State<LoadingBubble> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 4.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.2 * index,
            0.6 + 0.2 * index,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) => _buildDot(_animations[index])),
      ),
    );
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Transform.translate(
            offset: Offset(0, -animation.value),
            child: child,
          ),
        );
      },
      child: Container(
        height: 8.0,
        width: 8.0,
        decoration: const BoxDecoration(
          color: hoverMenuIconColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
