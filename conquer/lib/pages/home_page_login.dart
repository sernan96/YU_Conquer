import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageLogin extends StatelessWidget {
  const HomePageLogin({Key? key}) : super(key: key);

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', (Route<dynamic> route) => false);
  }

  void _showLocationList(BuildContext context) async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('locationList').get();

    final List<DocumentSnapshot> documents = snapshot.docs;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: documents.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['locationName'] ?? 'Unknown Location'),
                  onTap: () => _showLocationDetails(context, data),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showLocationDetails(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                if (data['imageFileName'] != null)
                  Image.asset(
                    'assets/images/${data['imageFileName']}',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 8),
                Text(
                  "Exp: ${data['Exp'] ?? 'N/A'}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Address: ${data['locationAddress'] ?? 'No Address Provided'}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Information: ${data['locationInformation'] ?? 'No Information Provided'}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('현재 위치 파악이 불가능합니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
        title: const Text(
          '영남이의 모험',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.black,
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
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
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF73D7F7),
                ),
                onPressed: () => _showErrorDialog(context),
                child: const Text(
                  '탐방 완료',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              onPressed: () => _showLocationList(context),
              child: const Text(
                '탐방 장소 목록',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
