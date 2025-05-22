import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    // Controla o fade da logo
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000), // 2s fade-in + 2s fade-out
    );

    _logoOpacity = TweenSequence([
      // Fade-in: 0 → 1 nos primeiros 2 segundos
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
      // Fade-out: 1 → 0 nos próximos 2 segundos
      TweenSequenceItem(
        tween: Tween(begin: 3.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(_logoController);

    _logoController.forward();

    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco fixo
      body: Center(
        child: FadeTransition(
          opacity: _logoOpacity,
          child: Image.asset(
            'assets/logo.png',
            width: 180,
            height: 180,
          ),
        ),
      ),
    );
  }
}
