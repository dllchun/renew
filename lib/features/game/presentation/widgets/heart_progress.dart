import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';

class HeartProgress extends StatefulWidget {
  final double percentage;
  final int streakDays;
  final Color color;

  const HeartProgress({
    Key? key,
    required this.percentage,
    required this.streakDays,
    required this.color,
  }) : super(key: key);

  @override
  State<HeartProgress> createState() => _HeartProgressState();
}

class _HeartProgressState extends State<HeartProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Streak Badge (positioned above heart)
        if (widget.streakDays > 0)
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.shade400,
                                Colors.deepOrange.shade600,
                              ],
                              stops: const [0.3, 0.7],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 5),
                              ),
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                blurRadius: 25,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Animated Fire Icon
                              Transform.scale(
                                scale:
                                    1.0 + (_pulseAnimation.value - 1.0) * 0.5,
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      Colors.yellow.shade300,
                                      Colors.orange.shade500,
                                      Colors.deepOrange.shade600,
                                    ],
                                    stops: const [0.2, 0.5, 0.8],
                                  ).createShader(bounds),
                                  child: const Icon(
                                    Icons.local_fire_department,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.streakDays} Day${widget.streakDays == 1 ? '' : 's'}',
                                    style: TextStyle(
                                      color: Colors.yellow.shade100,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '🔥 Streak!',
                                    style: TextStyle(
                                      color: Colors.yellow.shade200,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),

        // Heart Container with Glow
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.favorite,
              size: 160,
              color: widget.color,
            ),
          ),
        ),

        // Percentage Text
        Text(
          '${(widget.percentage * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
