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
    apiKey: 'AIzaSyBwEkntAYqi8Sfks4DshlxpLpKLmyRwjEs',
    appId: '1:589055146477:web:608eaa7d8713e3f3030fe4',
    messagingSenderId: '589055146477',
    projectId: 'pos-sanbercode',
    authDomain: 'pos-sanbercode.firebaseapp.com',
    storageBucket: 'pos-sanbercode.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANfb7s_6JAGA2_8t0rKewCpyWNK2E6EJU',
    appId: '1:589055146477:android:ccb73c797ed998b1030fe4',
    messagingSenderId: '589055146477',
    projectId: 'pos-sanbercode',
    storageBucket: 'pos-sanbercode.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJT33lKdzkzMvsX_1iRuv2hjRgvYwE_08',
    appId: '1:589055146477:ios:9b5d20d99aad01c6030fe4',
    messagingSenderId: '589055146477',
    projectId: 'pos-sanbercode',
    storageBucket: 'pos-sanbercode.appspot.com',
    iosBundleId: 'com.example.finalProjectSanbercode',
  );
}
