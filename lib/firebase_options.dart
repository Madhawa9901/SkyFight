// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAe6YkgRyekjBY-O-sPaa8tQoTdJ6bkuyI',
    appId: '1:890863162342:web:ebcf410b1df723dd7f7c27',
    messagingSenderId: '890863162342',
    projectId: 'skyfight-f9fb6',
    authDomain: 'skyfight-f9fb6.firebaseapp.com',
    storageBucket: 'skyfight-f9fb6.firebasestorage.app',
    measurementId: 'G-WZHX912BG7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCnwKUdLTdoWPzA_-MaDRFMhx8_p87YCtc',
    appId: '1:890863162342:android:6462b785d8ad51547f7c27',
    messagingSenderId: '890863162342',
    projectId: 'skyfight-f9fb6',
    storageBucket: 'skyfight-f9fb6.firebasestorage.app',
  );
}