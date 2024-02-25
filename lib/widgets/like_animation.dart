import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final VoidCallback? onEnd;
  final bool smallLike;
  final Duration duration;

  const LikeAnimation({
    super.key,
    required this.child,
    required this.isAnimating,
    this.onEnd,
    this.smallLike = false,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: widget.duration.inMilliseconds),
    );
    // scale = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    scale = Tween<double>(begin: 1, end: 1.3).animate(controller);
    // controller.repeat(reverse: false);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(
          milliseconds: 300,
        ),
      );

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
