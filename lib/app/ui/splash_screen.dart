import 'package:flutter/material.dart';

class ScanningSplashScreen extends StatefulWidget {
  const ScanningSplashScreen({super.key});

  @override
  State<ScanningSplashScreen> createState() => _ScanningSplashScreenState();
}

class _ScanningSplashScreenState extends State<ScanningSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.repeat();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111111) : const Color(0xFFF2F0EB),
      body: Stack(
        children: [
          // Background "paper" effect
          Center(
            child: Opacity(
              opacity: 0.03,
              child: Icon(
                Icons.description_outlined,
                size: 240,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          // Centered Branding
          Center(
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2,
                        color: theme.colorScheme.onSurface,
                      ),
                      children: const [
                        TextSpan(
                          text: 'A',
                          style: TextStyle(color: Color(0xFFE53935)), // Red A
                        ),
                        TextSpan(text: 'PEX'),
                      ],
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Software for business.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Scanning Line
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * _animation.value,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4CAF50).withValues(alpha: 0),
                        const Color(0xFF4CAF50),
                        const Color(0xFF4CAF50).withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
