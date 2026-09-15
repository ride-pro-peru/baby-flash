import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class BabySafeScaffold extends StatelessWidget {
  final Widget child;

  const BabySafeScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      child: SafeArea(child: child),
    );
  }
}

void enterFullScreen() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void exitFullScreen() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}