import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'core/theme/app_theme.dart';
import 'features/flashcards/presentation/pages/flashcards_page.dart';
import 'features/flashcards/presentation/bloc/flashcards_bloc.dart';
import 'core/di/injection.dart';

class BabyFlashApp extends StatelessWidget {
  const BabyFlashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'BabyFlash',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Builder(
        builder: (context) {
          final brightness = MediaQuery.of(context).platformBrightness;
          final theme = brightness == Brightness.dark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme;
          return CupertinoTheme(
            data: theme,
            child: BlocProvider(
              create: (context) => getIt<FlashcardsBloc>(),
              child: const FlashcardsPage(),
            ),
          );
        },
      ),
    );
  }
}
