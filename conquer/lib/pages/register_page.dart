import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regUserNameController = TextEditingController();
  final TextEditingController regPWController = TextEditingController();
  final TextEditingController regPWConfirmController = TextEditingController();
  String errorMessage = '';

  Future<void> regSendData() async {
    setState(() {
      errorMessage = '';
    });

    // 이메일 형식의 타당성을 검사
    bool isValidEmail = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
        .hasMatch(regEmailController.text);
    if (!isValidEmail || regEmailController.text.trim().isEmpty) {
      setState(() {
        errorMessage = '이메일 형식이 유효하지 않습니다.';
      });
      return;
    }

    // 사용자 이름이 공백인지 검사
    if (regUserNameController.text.trim().isEmpty) {
      setState(() {
        errorMessage = '사용자 이름을 입력해주세요.';
      });
      return;
    }

    // 비밀번호와 비밀번호 확인이 일치하는지 검사
    if (regPWController.text != regPWConfirmController.text) {
      setState(() {
        errorMessage = '비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    // 비밀번호 타당성 검사 (예: 최소 8자 이상, 최소 하나의 숫자, 하나의 특수 문자 포함)
    bool isValidPassword = RegExp(
            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
        .hasMatch(regPWController.text);
    if (!isValidPassword) {
      setState(() {
        errorMessage = '비밀번호가 타당성 요구사항을 충족하지 않습니다.';
      });
      return;
    }

    try {
      // Firebase Authentication을 사용하여 이메일로 회원가입 시도
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: regEmailController.text,
        password: regPWController.text,
      );

      // Firestore에 사용자 정보 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': regUserNameController.text,
        'email': regEmailController.text,
      });

      // 사용자 이름을 업데이트
      await userCredential.user!.updateDisplayName(regUserNameController.text);

      // 회원가입이 성공적으로 완료되면 홈 페이지로 이동
      print('회원가입 성공: ${userCredential.user!.uid}');
      if (!mounted) return;
      setState(() {
        errorMessage = '회원가입 성공! 로그인하세요.';
      });

      // 500밀리초 대기 후 현재 페이지를 닫음
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      // Firebase Auth 오류 메시지 처리
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = '이미 사용 중인 이메일입니다.';
            break;
          case 'invalid-email':
            errorMessage = '유효하지 않은 이메일 형식입니다.';
            break;
          case 'operation-not-allowed':
            errorMessage = '이 작업은 허용되지 않습니다.';
            break;
          case 'weak-password':
            errorMessage = '비밀번호가 너무 약합니다.';
            break;
          default:
            errorMessage = '알 수 없는 Firebase Auth 오류가 발생했습니다: ${e.code}';
        }
      });
    } catch (e) {
      // 기타 일반 예외 처리
      setState(() {
        errorMessage = '알 수 없는 오류가 발생했습니다: ${e.toString()}';
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
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: const Text(
          "회원가입",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const Center(
              child: Text(
                "Email",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: TextField(
                expands: false,
                controller: regEmailController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 199, 195, 195),
                  filled: true,
                  hintText: '이메일 주소를 입력해주세요.',
                  hintStyle: TextStyle(fontSize: 13),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Username",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: TextField(
                expands: false,
                controller: regUserNameController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 199, 195, 195),
                  filled: true,
                  hintText: '사용하실 UserName을 입력해주세요.',
                  hintStyle: TextStyle(fontSize: 13),
                ),
                keyboardType: TextInputType.name,
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Password",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: TextField(
                expands: false,
                controller: regPWController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 199, 195, 195),
                  filled: true,
                  hintText: '규칙: 최소 8자 이상, 최소 하나의 숫자, 하나의 특수 문자 포함',
                  hintStyle: TextStyle(fontSize: 13),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Password(Confirm)",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: TextField(
                expands: false,
                controller: regPWConfirmController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 199, 195, 195),
                  filled: true,
                  hintText: '확인용 다시 한번 입력',
                  hintStyle: TextStyle(fontSize: 13),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: regSendData,
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
