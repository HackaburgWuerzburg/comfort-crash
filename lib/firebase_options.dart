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
    apiKey: 'AIzaSyBDKmd5w-kg7iALfnroFyVdunWpWnYkpac',
    appId: '1:940772918986:web:7885240aac32c25fec5633',
    messagingSenderId: '940772918986',
    projectId: 'comfortcrash',
    authDomain: 'comfortcrash.firebaseapp.com',
    storageBucket: 'comfortcrash.firebasestorage.app',
    measurementId: 'G-277GHJPBLK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBHsXrE0tI4wLb89PwH1RD4ipLCzejTeMQ',
    appId: '1:940772918986:android:8778ce806a47f14eec5633',
    messagingSenderId: '940772918986',
    projectId: 'comfortcrash',
    storageBucket: 'comfortcrash.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClOOGBvOZe8J67EYmJ4h9qp4FPS8NSAfI',
    appId: '1:940772918986:ios:a0b50a39e27a48c6ec5633',
    messagingSenderId: '940772918986',
    projectId: 'comfortcrash',
    storageBucket: 'comfortcrash.firebasestorage.app',
    iosBundleId: 'com.example.comfortCrash',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyClOOGBvOZe8J67EYmJ4h9qp4FPS8NSAfI',
    appId: '1:940772918986:ios:a0b50a39e27a48c6ec5633',
    messagingSenderId: '940772918986',
    projectId: 'comfortcrash',
    storageBucket: 'comfortcrash.firebasestorage.app',
    iosBundleId: 'com.example.comfortCrash',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBDKmd5w-kg7iALfnroFyVdunWpWnYkpac',
    appId: '1:940772918986:web:7e4d1a736cdb1ecdec5633',
    messagingSenderId: '940772918986',
    projectId: 'comfortcrash',
    authDomain: 'comfortcrash.firebaseapp.com',
    storageBucket: 'comfortcrash.firebasestorage.app',
    measurementId: 'G-D5R38WFGDK',
  );
}
