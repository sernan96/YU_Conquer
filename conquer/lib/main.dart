import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conquer/pages/home_page.dart';
import 'package:conquer/pages/home_page_login.dart';
import 'package:conquer/pages/login_page.dart';
import 'package:conquer/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'TmoneyRoundWind',
        primaryColor: const Color(0xFF376860),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF376860),
          selectionColor: Color(0xFF376860),
          selectionHandleColor: Color(0xFF376860),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF376860)),
          ),
          labelStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFF376860)),
      ),
      home: const InitialScreen(),
      routes: {
        '/home': (context) => const HomePage(),
        '/home_login': (context) => const HomePageLogin(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const HomePageLogin(); // 로그인된 상태라면 HomePageLogin으로 이동
        } else {
          return const HomePage(); // 로그인되지 않은 상태라면 HomePage로 이동
        }
      },
    );
  }
}
