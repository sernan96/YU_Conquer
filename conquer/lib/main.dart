import 'package:conquer/pages/home_page_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:conquer/pages/home_page.dart';
import 'package:conquer/pages/home_page_login.dart';
import 'package:conquer/pages/login_page.dart';
import 'package:conquer/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //비동기방식
  //await Firebase.initializeApp();
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
            color: Colors.black, // 여기에서 색상을 원하는 색상으로 변경하세요.
          ),
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFF376860)),
      ),
      initialRoute: '/Home_Page', // 초기 화면 설정
      routes: {
        '/Home_Page': (context) => const HomePage(), // Home 페이지
        '/Home_Page_login': (context) => const HomePage_login(), // Home 페이지
        '/login': (context) => const LoginApp(),
        '/register': (context) => const RegisterApp(), // LoginPage로 이동
      },
    );
  }
}
