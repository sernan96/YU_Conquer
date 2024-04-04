import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LogIn();
  }
}

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController IDController = TextEditingController();
  final TextEditingController PWController = TextEditingController();
  Future<void> sendData() async {
    var response = await http.post(
      Uri.parse('http://localhost:3000/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': IDController.text,
        'password': PWController.text,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: InkResponse(
          onTap: () {
            Navigator.pop(context);
          },
          containedInkWell: false,
          highlightColor: Colors.grey,
          radius: 24,
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 40,
          ),
        ),
        title: const Text(
          '로그인',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Form(
            child: Container(
              padding: const EdgeInsets.all(40.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: IDController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        fillColor: Color.fromARGB(255, 199, 195, 195),
                        filled: true,
                        hintText: 'Your email address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: PWController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        fillColor: Color.fromARGB(255, 199, 195, 195),
                        filled: true,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: sendData,
                          child: const Text(
                            '로그인',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            '회원가입',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Text(
                          " / ",
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            '비밀번호를 찾고 싶어요',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
