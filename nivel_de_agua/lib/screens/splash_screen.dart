import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nivel_de_agua/main.dart';

// classe do splash
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: Lottie.asset(
              "assets/animations/loadinganimation.json",
            ), //caminho da animacao na assets
          ),
        ],
      ),
      nextScreen: const HomeScreen(), //tela que vai apos o splash (inicial)
      splashIconSize: 400, // tamanho do icone do splash
      backgroundColor: Colors.transparent, // cor de fundo
      duration: 3000, // duracao em milisegundos
    );
  }
}
