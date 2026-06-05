import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../routes/router_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _ctrl.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.visibility_rounded,
                        size: 52,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'Smart Glasses',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text(
                      'Recommender',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'AI-powered eyewear personalization',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.75),
                        letterSpacing: 0.3,
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Loading dots
                    _LoadingDots(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  final List<AnimationController> _dotControllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
      _dotControllers.add(ctrl);
    }
  }

  @override
  void dispose() {
    for (final c in _dotControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _dotControllers[i],
          builder: (_, __) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8 + _dotControllers[i].value * 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5 + _dotControllers[i].value * 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
