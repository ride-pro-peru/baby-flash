import 'package:flutter/cupertino.dart';

class BabyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final double size;

  const BabyButton({
    super.key,
    this.onPressed,
    required this.child,
    this.color,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? CupertinoColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}