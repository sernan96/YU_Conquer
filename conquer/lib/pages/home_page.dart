import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
              Navigator.pushNamed(context, '/login');
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          TextButton(
            onPressed: () {},
            child: const Text(
              '시작하기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
