import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  String resetEmailMessage = '';

  Future<void> signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user != null) {
        Navigator.pushNamed(context, '/home_login');
      }
    } on FirebaseAuthException catch (e) {
      // Firebase Auth 오류 메시지 처리
      setState(() {
        switch (e.code) {
          case 'wrong-password':
            errorMessage = '잘못된 비밀번호입니다.';
            break;
          case 'invalid-email':
            errorMessage = '유효하지 않은 이메일 형식입니다.';
            break;
          default:
            errorMessage = '사용자를 찾을 수 없습니다.';
        }
      });
    } catch (e) {
      // 기타 일반 예외 처리
      setState(() {
        errorMessage = '알 수 없는 오류가 발생했습니다.';
      });
    }
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      setState(() {
        resetEmailMessage = '비밀번호 재설정 이메일을 보냈습니다.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalid-email':
            resetEmailMessage = '유효하지 않은 이메일 형식입니다.';
            break;
          case 'user-not-found':
            resetEmailMessage = '등록되지 않은 이메일입니다.';
            break;
          default:
            resetEmailMessage = '비밀번호 재설정 이메일을 보내는 데 실패했습니다!';
        }
      });
    } catch (e) {
      setState(() {
        resetEmailMessage = '알 수 없는 오류가 발생했습니다';
      });
    }
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
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          if (resetEmailMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                resetEmailMessage,
                style: const TextStyle(color: Colors.green),
              ),
            ),
          Form(
            child: Container(
              padding: const EdgeInsets.all(40.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        fillColor: Color.fromARGB(255, 199, 195, 195),
                        filled: true,
                        hintText: 'Your email address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        fillColor: Color.fromARGB(255, 199, 195, 195),
                        filled: true,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                    const SizedBox(height: 35),
                    Row(
                      children: [
                        TextButton(
                          onPressed: signInWithEmailAndPassword,
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
                        const Text(" / "),
                        TextButton(
                          onPressed: resetPassword,
                          child: const Text(
                            '비밀번호를 찾고 싶어요',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
