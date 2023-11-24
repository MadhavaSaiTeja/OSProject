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
    apiKey: 'AIzaSyCIWW9gf73WFUBYakye5ec1gc-dQU8u7lw',
    appId: '1:431042372447:web:ed59df259d5c995ccb8cea',
    messagingSenderId: '431042372447',
    projectId: 'prior-397b0',
    authDomain: 'prior-397b0.firebaseapp.com',
    storageBucket: 'prior-397b0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCp_5R67EQajNyFFNNrtz0yJw1-thVKHmc',
    appId: '1:431042372447:android:d426bd5f0f94d532cb8cea',
    messagingSenderId: '431042372447',
    projectId: 'prior-397b0',
    storageBucket: 'prior-397b0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7SMHdSkQFBKBi2GttTqvWKhSQ2Vg0NNs',
    appId: '1:431042372447:ios:a1e1fd888f197289cb8cea',
    messagingSenderId: '431042372447',
    projectId: 'prior-397b0',
    storageBucket: 'prior-397b0.appspot.com',
    iosBundleId: 'com.example.prior',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC7SMHdSkQFBKBi2GttTqvWKhSQ2Vg0NNs',
    appId: '1:431042372447:ios:399680c3bc5b1baecb8cea',
    messagingSenderId: '431042372447',
    projectId: 'prior-397b0',
    storageBucket: 'prior-397b0.appspot.com',
    iosBundleId: 'com.example.prior.RunnerTests',
  );
}