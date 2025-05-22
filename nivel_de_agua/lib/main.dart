import 'package:flutter/material.dart';

// Importa com prefixo para evitar conflitos se houver mais de uma classe com o mesmo nome
import 'screens/splash_screen.dart' as splash;
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const splash.SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(), // <-- corrigido aqui
      },
    );
  }
}
