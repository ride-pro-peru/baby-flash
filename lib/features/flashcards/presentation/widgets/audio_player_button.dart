import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';

class AudioPlayerButton extends StatefulWidget {
  final String word;
  final double size;

  const AudioPlayerButton({
    super.key,
    required this.word,
    this.size = 56,
  });

  @override
  State<AudioPlayerButton> createState() => _AudioPlayerButtonState();
}

class _AudioPlayerButtonState extends State<AudioPlayerButton>
    with SingleTickerProviderStateMixin {
  FlutterTts? _flutterTts;
  bool _isPlaying = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initTts();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initTts() async {
    final tts = FlutterTts();
    await tts.setLanguage('es-ES');
    await tts.setSpeechRate(0.45);
    await tts.setVolume(1.0);
    await tts.setPitch(1.1);
    _flutterTts = tts;
  }

  Future<void> _speak() async {
    if (_isPlaying || _flutterTts == null) return;

    setState(() => _isPlaying = true);
    _animationController.repeat(reverse: true);

    await _flutterTts?.speak(widget.word);

    if (mounted) {
      _animationController.stop();
      _animationController.reset();
      setState(() => _isPlaying = false);
    }
  }

  @override
  void dispose() {
    _flutterTts?.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;
    return GestureDetector(
      onTap: _speak,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _isPlaying
                ? AppColors.primary
                : AppColors.cardBackgroundFor(brightness),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: isDark ? 0.35 : 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Iconsax.volume_high,
            size: widget.size * 0.5,
            color: _isPlaying ? CupertinoColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}