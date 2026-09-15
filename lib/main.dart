import 'package:flutter/cupertino.dart';
import 'app.dart';
import 'core/di/injection.dart';
import 'shared/widgets/baby_safe_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  enterFullScreen();
  runApp(const BabyFlashApp());
}