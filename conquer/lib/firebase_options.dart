// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDpvXvnPZ8VVEFuq_1eCD0QvMFQRgbEl6w',
    appId: '1:150098481921:web:2134c45289c885b8320100',
    messagingSenderId: '150098481921',
    projectId: 'yu-conquer',
    authDomain: 'yu-conquer.firebaseapp.com',
    storageBucket: 'yu-conquer.appspot.com',
    measurementId: 'G-0G2VLFYK46',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBB28x5-vgAjKPoaEoajXTEB_mHeRQMvrs',
    appId: '1:150098481921:android:f4b7d9e357b00176320100',
    messagingSenderId: '150098481921',
    projectId: 'yu-conquer',
    storageBucket: 'yu-conquer.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtoLHAhfMpHGhJet15IdXgEIwvjMSBT8c',
    appId: '1:150098481921:ios:848250dd0f58ffe6320100',
    messagingSenderId: '150098481921',
    projectId: 'yu-conquer',
    storageBucket: 'yu-conquer.appspot.com',
    iosBundleId: 'com.example.conquer',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtoLHAhfMpHGhJet15IdXgEIwvjMSBT8c',
    appId: '1:150098481921:ios:848250dd0f58ffe6320100',
    messagingSenderId: '150098481921',
    projectId: 'yu-conquer',
    storageBucket: 'yu-conquer.appspot.com',
    iosBundleId: 'com.example.conquer',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDpvXvnPZ8VVEFuq_1eCD0QvMFQRgbEl6w',
    appId: '1:150098481921:web:10428494f2218ea9320100',
    messagingSenderId: '150098481921',
    projectId: 'yu-conquer',
    authDomain: 'yu-conquer.firebaseapp.com',
    storageBucket: 'yu-conquer.appspot.com',
    measurementId: 'G-QM7KW9VE3J',
  );

}