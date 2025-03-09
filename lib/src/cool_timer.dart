import 'dart:ui';

import 'package:cool_timer/src/animation_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CoolTimer extends StatefulWidget {
  final Duration duration;
  final AnimationType selectedAnimation;
  final VoidCallback onEnd;
  final bool isBlur;
  final double blurStrength;
  final TextStyle textStyle;
  final Color dividerColor;
  final Color backgroundColor;
  final bool showHours;
  final bool showMinutes;
  final bool showSeconds;
  final bool isReversed;
  final bool showUnitLabels;
  final Duration digitAnimationDuration;
  final Function(Duration remainingTime)? onTick;

  const CoolTimer({
    super.key,
    required this.duration,
    required this.selectedAnimation,
    required this.onEnd,
    this.isBlur = false,
    this.blurStrength = 10.0,
    this.textStyle = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    this.dividerColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.showHours = true,
    this.showMinutes = true,
    this.showSeconds = true,
    this.isReversed = false,
    this.showUnitLabels = true,
    this.digitAnimationDuration = const Duration(milliseconds: 500),
    this.onTick,
  });

  @override
  _CoolTimerState createState() => _CoolTimerState();
}

class _CoolTimerState extends State<CoolTimer>
    with SingleTickerProviderStateMixin {
  late Duration _remainingDuration;
  late Ticker _ticker;

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void initState() {
    super.initState();
    _remainingDuration = widget.isReversed ? Duration.zero : widget.duration;

    _ticker = Ticker((elapsed) {
      final secondsElapsed = elapsed.inSeconds;
      final totalSeconds =
          widget.isReversed
              ? secondsElapsed
              : widget.duration.inSeconds - secondsElapsed;

      if ((widget.isReversed && totalSeconds >= widget.duration.inSeconds) ||
          (!widget.isReversed && totalSeconds <= 0)) {
        _ticker.stop();
        widget.onEnd();
        setState(() {
          _remainingDuration =
              widget.isReversed ? widget.duration : Duration.zero;
        });
      } else {
        setState(() {
          _remainingDuration = Duration(seconds: totalSeconds);
        });

        if (widget.onTick != null) {
          widget.onTick!(_remainingDuration);
        }
      }
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = twoDigits(_remainingDuration.inHours);
    final minutes = twoDigits(_remainingDuration.inMinutes.remainder(60));
    final seconds = twoDigits(_remainingDuration.inSeconds.remainder(60));

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.isBlur ? widget.blurStrength : 0,
          sigmaY: widget.isBlur ? widget.blurStrength : 0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          width: MediaQuery.sizeOf(context).width * 0.7,
          decoration: BoxDecoration(
            color: widget.backgroundColor.withAlpha(
              ((widget.isBlur ? 0.4 : 1) * 255).toInt(),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.showHours) buildTimeUnit(hours, 'h'),
              if (widget.showHours && widget.showMinutes) buildDivider(),
              if (widget.showMinutes) buildTimeUnit(minutes, 'm'),
              if (widget.showMinutes && widget.showSeconds) buildDivider(),
              if (widget.showSeconds) buildTimeUnit(seconds, 's'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return SizedBox(
      height: 30,
      child: VerticalDivider(thickness: 2, color: widget.dividerColor),
    );
  }

  Widget buildTimeUnit(String value, String unit) {
    return Row(
      children: [
        ...value.split('').asMap().entries.map((entry) {
          int index = entry.key;
          String digit = entry.value;
          return buildAnimatedDigit(digit, '$unit$index');
        }),
        if (widget.showUnitLabels) Text(unit, style: widget.textStyle),
      ],
    );
  }

  Widget buildAnimatedDigit(String digit, String positionKey) {
    return AnimatedSwitcher(
      duration: widget.digitAnimationDuration,
      transitionBuilder: (child, animation) {
        switch (widget.selectedAnimation) {
          case AnimationType.scale:
            return ScaleTransition(scale: animation, child: child);
          case AnimationType.fade:
            return FadeTransition(opacity: animation, child: child);
          case AnimationType.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case AnimationType.rotate:
            return RotationTransition(turns: animation, child: child);
        }
      },
      child: Text(
        digit,
        key: ValueKey<String>('$positionKey$digit'),
        style: widget.textStyle,
      ),
    );
  }
}
