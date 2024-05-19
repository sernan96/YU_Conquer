import 'package:flutter/material.dart';

void main() {
  runApp(const HomePage_login());
}

class HomePage_login extends StatelessWidget {
  const HomePage_login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(
          Icons.home_filled,
          color: Colors.black,
          size: 40,
        ),
        title: const Flexible(
          child: Text(
            '영남이의 모험',
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              // Navigator.pushNamed(context, '/login');
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'MY',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/logo.jpg',
            width: 330,
            height: 330,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // 밝은 회색 배경
              borderRadius: BorderRadius.circular(10), // 둥근 사각형 모양
            ),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                '탐방 완료',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
