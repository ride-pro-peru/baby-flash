import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/responsive_layout.dart';

class SwipeableCard extends StatefulWidget {
  final String word;
  final String imagePath;
  final String? nextWord;
  final String? nextImagePath;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onTap;
  final Color cardColor;

  const SwipeableCard({
    super.key,
    required this.word,
    required this.imagePath,
    this.nextWord,
    this.nextImagePath,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onTap,
    this.cardColor = CupertinoColors.white,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragExtent = 0;
  bool _isAnimating = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.animationDuration,
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (_isAnimating) return;
    setState(() {
      _isPressed = true;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    setState(() {
      _dragExtent += details.primaryDelta ?? details.delta.dx;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isAnimating) return;
    setState(() {
      _isPressed = false;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * AppConstants.swipeThreshold;
    final velocity = details.primaryVelocity ?? details.velocity.pixelsPerSecond.dx;

    final isFling = velocity.abs() >= AppConstants.minFlingVelocity;
    final isPastThreshold = _dragExtent.abs() >= threshold;

    if (isFling || isPastThreshold) {
      // Determine swipe direction
      final direction = isFling
          ? (velocity > 0 ? 1.0 : -1.0)
          : (_dragExtent > 0 ? 1.0 : -1.0);

      HapticFeedback.lightImpact();
      _animateOut(direction);
    } else {
      _snapBack();
    }
  }

  void _onHorizontalDragCancel() {
    if (_isAnimating) return;
    setState(() {
      _isPressed = false;
    });
    _snapBack();
  }

  void _animateOut(double direction) {
    _isAnimating = true;
    final screenWidth = MediaQuery.of(context).size.width;
    final targetEnd = direction * screenWidth * 1.25;

    _animation = Tween<double>(
      begin: _dragExtent,
      end: targetEnd,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );

    _controller.forward(from: 0).then((_) {
      if (mounted) {
        if (direction > 0) {
          widget.onSwipeRight?.call();
        } else {
          widget.onSwipeLeft?.call();
        }
        setState(() {
          _dragExtent = 0;
          _isAnimating = false;
        });
        _controller.reset();
      }
    });
  }

  void _snapBack() {
    _isAnimating = true;
    _animation = Tween<double>(
      begin: _dragExtent,
      end: 0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _dragExtent = 0;
          _isAnimating = false;
        });
        _controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = ResponsiveLayout.cardWidth(context);
    final cardHeight = ResponsiveLayout.cardHeight(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Background card preview for stacked deck effect
        if (widget.nextWord != null && widget.nextImagePath != null)
          AnimatedBuilder(
            animation: _isAnimating
                ? _animation
                : AlwaysStoppedAnimation(_dragExtent),
            builder: (context, child) {
              final currentOffset =
                  _isAnimating ? _animation.value : _dragExtent;
              final dragProgress =
                  (currentOffset.abs() / (screenWidth * 0.5)).clamp(0.0, 1.0);

              final scale = 0.94 + (0.06 * dragProgress);
              final opacity = 0.75 + (0.25 * dragProgress);
              final offsetY = 12.0 * (1.0 - dragProgress);

              return Transform.translate(
                offset: Offset(0, offsetY),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: _buildCardContent(
                      context,
                      cardWidth,
                      cardHeight,
                      word: widget.nextWord!,
                      imagePath: widget.nextImagePath!,
                      isBackground: true,
                    ),
                  ),
                ),
              );
            },
          ),

        // Foreground interactive card
        GestureDetector(
          onHorizontalDragStart: _onHorizontalDragStart,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          onHorizontalDragCancel: _onHorizontalDragCancel,
          onTap: () {
            HapticFeedback.selectionClick();
            widget.onTap?.call();
          },
          child: AnimatedBuilder(
            animation: _isAnimating
                ? _animation
                : AlwaysStoppedAnimation(_dragExtent),
            builder: (context, child) {
              final value = _isAnimating ? _animation.value : _dragExtent;
              final rotation = (value / screenWidth) * 0.18;
              final opacity =
                  (1.0 - (value.abs() / (screenWidth * 1.3))).clamp(0.0, 1.0);
              final pressScale = _isPressed ? 0.98 : 1.0;

              return Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.translationValues(value, 0.0, 0.0)
                  ..rotateZ(rotation),
                child: Transform.scale(
                  scale: pressScale,
                  child: Opacity(
                    opacity: opacity,
                    child: child,
                  ),
                ),
              );
            },
            child: _buildCardContent(
              context,
              cardWidth,
              cardHeight,
              word: widget.word,
              imagePath: widget.imagePath,
              isBackground: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent(
    BuildContext context,
    double width,
    double height, {
    required String word,
    required String imagePath,
    bool isBackground = false,
  }) {
    final isTablet = ResponsiveLayout.isTablet(context);
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;
    final cardBorderRadius = BorderRadius.circular(isTablet ? 36 : 28);
    final imageBorderRadius = BorderRadius.circular(isTablet ? 26 : 20);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: cardBorderRadius,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withValues(
              alpha: isDark ? (isBackground ? 0.25 : 0.4) : (isBackground ? 0.06 : 0.12),
            ),
            blurRadius: isBackground ? 12 : 24,
            offset: Offset(0, isBackground ? 6 : 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 20 : 14,
                isTablet ? 20 : 14,
                isTablet ? 20 : 14,
                isTablet ? 12 : 8,
              ),
              child: ClipRRect(
                borderRadius: imageBorderRadius,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.cardImageBackgroundFor(brightness),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Iconsax.gallery_slash,
                        size: isTablet ? 120 : 80,
                        color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey3,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveLayout.horizontalPadding(context),
              4,
              ResponsiveLayout.horizontalPadding(context),
              isTablet ? 20 : 14,
            ),
            child: Text(
              word,
              style: TextStyle(
                fontSize: ResponsiveLayout.wordFontSize(context),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryFor(brightness),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}