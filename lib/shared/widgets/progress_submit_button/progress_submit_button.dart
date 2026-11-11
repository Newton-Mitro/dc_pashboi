import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pashboi/shared/widgets/progress_submit_button/half_circle_printer.dart';

class ProgressSubmitButton extends StatefulWidget {
  final VoidCallback? onSubmit;
  final String label;
  final double height;
  final double width;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? progressColor;
  final int duration;
  final bool enabled; // <-- new parameter

  const ProgressSubmitButton({
    super.key,
    required this.onSubmit,
    this.label = "Hold to Submit",
    this.height = 100,
    this.width = double.infinity,
    this.backgroundColor,
    this.foregroundColor,
    this.progressColor,
    this.duration = 1,
    this.enabled = true,
  });

  @override
  State<ProgressSubmitButton> createState() => _ProgressSubmitButtonState();
}

class _ProgressSubmitButtonState extends State<ProgressSubmitButton> {
  Timer? _timer;
  double _progress = 0.0;

  void _startTimer() {
    if (!widget.enabled) return;

    const tick = Duration(milliseconds: 50);
    int ticks = 0;
    final int maxTicks = (widget.duration * 1000) ~/ tick.inMilliseconds;

    _timer = Timer.periodic(tick, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        ticks++;
        _progress = ticks / maxTicks;
      });

      if (ticks >= maxTicks) {
        timer.cancel();
        widget.onSubmit?.call();
        if (mounted) {
          setState(() {
            _progress = 0.0;
          });
        }
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;

    if (mounted) {
      setState(() {
        _progress = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // just cancel the timer
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final backgroundColor = widget.backgroundColor ?? colors.primary;
    final foregroundColor = widget.foregroundColor ?? colors.onPrimary;
    final progressColor = widget.progressColor ?? colors.secondary;
    final effectiveBackgroundColor =
        widget.enabled
            ? backgroundColor
            : backgroundColor.withValues(alpha: 0.5);
    final effectiveForegroundColor =
        widget.enabled
            ? foregroundColor
            : foregroundColor.withValues(alpha: 0.5);

    return GestureDetector(
      onTapDown: (_) => _startTimer(), // <--- Fast trigger
      onTapUp: (_) => _cancelTimer(),
      onTapCancel: () => _cancelTimer(),
      child: Material(
        color: Colors.transparent,
        child: AbsorbPointer(
          absorbing: !widget.enabled,
          child: Opacity(
            opacity: widget.enabled ? 1.0 : 0.6,
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomPaint(
                    size: Size(widget.width, widget.height),
                    painter: HalfCirclePainter(
                      progress: _progress,
                      backgroundColor: effectiveBackgroundColor,
                      progressColor: progressColor,
                    ),
                  ),
                  Positioned(
                    bottom: widget.height / 4,
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: effectiveForegroundColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
