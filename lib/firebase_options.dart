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
    apiKey: 'AIzaSyDCNoBRA8XDPSojJNT8DMVf1vC26V0uh20',
    appId: '1:1024179909703:web:79b441f21f95e750822d62',
    messagingSenderId: '1024179909703',
    projectId: 'parkapp-6b22d',
    authDomain: 'parkapp-6b22d.firebaseapp.com',
    storageBucket: 'parkapp-6b22d.appspot.com',
    measurementId: 'G-F80ZRNEJL3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCx_R9XQZhrFa0r2YcVDwhTmV8BnZPtZ9I',
    appId: '1:1024179909703:android:e49cc442d874b7e3822d62',
    messagingSenderId: '1024179909703',
    projectId: 'parkapp-6b22d',
    storageBucket: 'parkapp-6b22d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjbuqZZc7xq-P7_gBXEBIPEgZHhV1p330',
    appId: '1:1024179909703:ios:00d31fbe6af8688d822d62',
    messagingSenderId: '1024179909703',
    projectId: 'parkapp-6b22d',
    storageBucket: 'parkapp-6b22d.appspot.com',
    iosBundleId: 'com.example.parkApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjbuqZZc7xq-P7_gBXEBIPEgZHhV1p330',
    appId: '1:1024179909703:ios:dc2a5031b7fdf76a822d62',
    messagingSenderId: '1024179909703',
    projectId: 'parkapp-6b22d',
    storageBucket: 'parkapp-6b22d.appspot.com',
    iosBundleId: 'com.example.parkApp.RunnerTests',
  );
}