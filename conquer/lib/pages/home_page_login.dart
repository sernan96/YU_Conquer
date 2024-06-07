import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePageLogin extends StatelessWidget {
  const HomePageLogin({Key? key}) : super(key: key);

  // 위치 권한 요청 및 현재 위치 가져오기
  Future<void> _getLocationAndCompareWithPlaces(BuildContext context) async {
    // 위치 서비스 사용 가능 여부 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog(context, '위치 서비스가 비활성화되었습니다. 위치 서비스를 활성화해주세요.');
      return;
    }

    // 위치 권한 요청 및 확인
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.request();
    if (permissionStatus.isGranted) {
      try {
        // 현재 위치 정보 가져오기
        Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // 탐방 장소 목록 가져오기
        QuerySnapshot placeSnapshot =
            await FirebaseFirestore.instance.collection('locationList').get();
        List<DocumentSnapshot> places = placeSnapshot.docs;

        DocumentSnapshot? closestPlace;
        double closestDistance = double.infinity;

        // 모든 장소와의 거리 계산
        for (DocumentSnapshot place in places) {
          Map<String, dynamic> data = place.data() as Map<String, dynamic>;
          double latitude = data['latitude'];
          double longitude = data['longitude'];

          double distance = Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            latitude,
            longitude,
          );

          if (distance < closestDistance) {
            closestDistance = distance;
            closestPlace = place;
          }
        }

        // 가장 가까운 장소가 100미터 이내인지 확인
        if (closestDistance <= 100 && closestPlace != null) {
          Map<String, dynamic> placeData =
              closestPlace.data() as Map<String, dynamic>;
          int placeExp = placeData['Exp'];

          // 사용자 Exp 업데이트
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
            Map<String, dynamic>? userData =
                userSnapshot.data() as Map<String, dynamic>?;
            if (userData != null) {
              int currentExp = userData['Exp'] ?? 0;
              int updatedExp = currentExp + placeExp;

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({
                'Exp': updatedExp,
              });

              // 성공 메시지 표시
              _showSuccessDialog(context, placeExp, updatedExp);
            }
          }
        } else {
          // 실패 메시지 표시
          _showFailureDialog(context);
        }
      } catch (e) {
        // 위치 정보 가져오기 실패 시 오류 팝업 창 띄우기
        _showErrorDialog(context, '위치 정보를 가져올 수 없습니다. 위치 서비스를 확인해주세요.');
      }
    } else {
      // 권한 거부 시 오류 팝업 창 띄우기
      _showErrorDialog(context, '위치 권한이 필요합니다. 설정에서 권한을 허용해주세요.');
    }
  }

  // 성공 팝업 창 표시
  void _showSuccessDialog(BuildContext context, int placeExp, int updatedExp) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('탐방 성공!'),
          content: Text(
            '축하합니다! 탐방에 성공하셨습니다. \n장소의 Exp: $placeExp\n업데이트된 Exp: $updatedExp',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 실패 팝업 창 표시
  void _showFailureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('탐방 실패'),
          content: const Text(
            '현재 위치에서 100미터 이내의 탐방 장소를 찾지 못했습니다.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 오류 팝업 창 표시
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('오류'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
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
        leading: TextButton(
          onPressed: () => _showUserDetailsDialog(context),
          child: const Text(
            'MY',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
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
                onPressed: () => _getLocationAndCompareWithPlaces(context),
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

  // 사용자 정보 팝업 창 표시
  void _showUserDetailsDialog(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
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
                    Text(
                      "Username: ${userData['username'] ?? 'N/A'}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Email: ${user.email ?? 'N/A'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Exp: ${userData['Exp'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Level: ${userData['Level'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  // 로그아웃 함수
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', (Route<dynamic> route) => false);
  }

  // 탐방 장소 목록 표시 함수
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

  // 탐방 장소 상세 정보 표시 함수
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
}
