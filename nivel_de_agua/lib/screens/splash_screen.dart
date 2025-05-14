import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nivel_de_agua/main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: Lottie.asset(
              "assets/animations/loadinganimation.json", // Caminho da animação na assets
            ),
          ),
        ],
      ),
      nextScreen: const HomeScreen(), // Tela que vem após o splash
      splashIconSize: 400, // Tamanho do ícone do splash
      backgroundColor: Colors.transparent, // Cor de fundo
      duration: 3000, // Duração em milissegundos
    );
  }
}
