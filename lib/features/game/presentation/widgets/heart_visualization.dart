import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/features/game/domain/models/mental_health_state.dart';

class HeartVisualization extends StatefulWidget {
  final MentalHealthState state;
  final double size;
  final bool isInteractive;
  final VoidCallback? onTap;

  const HeartVisualization({
    Key? key,
    required this.state,
    this.size = 240,
    this.isInteractive = true,
    this.onTap,
  }) : super(key: key);

  @override
  State<HeartVisualization> createState() => _HeartVisualizationState();
}

class _HeartVisualizationState extends State<HeartVisualization>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _waveAnimation;
  late final Animation<double> _secondaryWaveAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _secondaryWaveAnimation = Tween<double>(
      begin: math.pi,
      end: 3 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.2,
      end: 0.4,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: HeartPainter(
                      progress: widget.state.percentage,
                      color: widget.state.heartColor,
                      wavePhase: _waveAnimation.value,
                      secondaryWavePhase: _secondaryWaveAnimation.value,
                      glowOpacity: _glowAnimation.value,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(widget.state.percentage * 100).toInt()}%',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontSize: widget.size * 0.2,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      if (widget.state.percentage > 0)
                        Text(
                          'Keep going!',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: widget.size * 0.08,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HeartPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double wavePhase;
  final double secondaryWavePhase;
  final double glowOpacity;

  HeartPainter({
    required this.progress,
    required this.color,
    required this.wavePhase,
    required this.secondaryWavePhase,
    required this.glowOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _createHeartPath(size);
    
    // Draw outer glow
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color.withOpacity(glowOpacity)
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, glowPaint);
    
    // Draw outline
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color.withOpacity(0.9)
      ..strokeWidth = 3;
    canvas.drawPath(path, outlinePaint);

    // Fill heart with base color
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withOpacity(0.15);
    canvas.drawPath(path, fillPaint);

    // Only draw liquid if there's progress
    if (progress > 0) {
      // Create wave clip path
      final wavePath = Path();
      final waveHeight = size.height * (0.03 + progress * 0.02);
      final baseHeight = size.height * (1 - progress);
      
      wavePath.moveTo(0, size.height);
      
      // Create double wave effect
      for (double i = 0; i <= size.width; i++) {
        final x = i;
        final normalizedX = x / size.width;
        final primaryWave = math.sin(wavePhase + normalizedX * 4 * math.pi) * waveHeight;
        final secondaryWave = math.sin(secondaryWavePhase + normalizedX * 6 * math.pi) * (waveHeight * 0.5);
        final y = baseHeight + primaryWave + secondaryWave;
        wavePath.lineTo(x, y);
      }
      
      wavePath.lineTo(size.width, size.height);
      wavePath.close();

      // Create vibrant liquid gradient
      final liquidPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          colors: [
            color.withOpacity(1.0),
            Color.lerp(color, Colors.white, 0.3)!.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
          stops: const [0.0, 0.4, 1.0],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      // Clip and fill liquid
      canvas.save();
      canvas.clipPath(path);
      canvas.drawPath(wavePath, liquidPaint);

      // Add shine effects
      final shinePath = Path();
      shinePath.moveTo(size.width * 0.2, baseHeight - size.height * 0.1);
      shinePath.quadraticBezierTo(
        size.width * 0.4, baseHeight - size.height * 0.15,
        size.width * 0.6, baseHeight - size.height * 0.1,
      );

      final shinePaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white.withOpacity(0.4)
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawPath(shinePath, shinePaint);
      
      canvas.restore();
    }
  }

  Path _createHeartPath(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    
    final centerX = width / 2;
    final centerY = height / 2;

    // Make heart slightly wider for better proportions
    final adjustedWidth = width * 1.1;
    final adjustedHeight = height * 1.05;

    // Start from bottom point
    path.moveTo(centerX, centerY + adjustedHeight * 0.35);

    // Left curve - smooth bottom to side
    path.cubicTo(
      centerX - adjustedWidth * 0.35, centerY + adjustedHeight * 0.25,
      centerX - adjustedWidth * 0.4, centerY + adjustedHeight * 0.05,
      centerX - adjustedWidth * 0.4, centerY - adjustedHeight * 0.05
    );

    // Left arc - top lobe
    path.cubicTo(
      centerX - adjustedWidth * 0.4, centerY - adjustedHeight * 0.3,
      centerX - adjustedWidth * 0.25, centerY - adjustedHeight * 0.35,
      centerX, centerY - adjustedHeight * 0.3
    );

    // Right arc - top lobe (mirrored)
    path.cubicTo(
      centerX + adjustedWidth * 0.25, centerY - adjustedHeight * 0.35,
      centerX + adjustedWidth * 0.4, centerY - adjustedHeight * 0.3,
      centerX + adjustedWidth * 0.4, centerY - adjustedHeight * 0.05
    );

    // Right curve - smooth side to bottom (mirrored)
    path.cubicTo(
      centerX + adjustedWidth * 0.4, centerY + adjustedHeight * 0.05,
      centerX + adjustedWidth * 0.35, centerY + adjustedHeight * 0.25,
      centerX, centerY + adjustedHeight * 0.35
    );

    return path;
  }

  @override
  bool shouldRepaint(covariant HeartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.color != color ||
           oldDelegate.wavePhase != wavePhase ||
           oldDelegate.secondaryWavePhase != secondaryWavePhase ||
           oldDelegate.glowOpacity != glowOpacity;
  }
} 