import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Inicia a animação de fade-in
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Inicia a transição para a próxima tela com fade-out
    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      setState(() {
        _opacity = 0.0;
      });

      // Aguarda a animação de fade-out antes de navegar
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1), // Duração do fade-in e fade-out
          opacity: _opacity, // Define a opacidade do logotipo
          child: Image.asset(
            'assets/logo.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}