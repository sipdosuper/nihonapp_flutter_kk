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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBgx6bsahXM7oEF7uLdhAT8plpR2NsLYTk',
    appId: '1:22797930593:web:f19225e64e7ff535389a20',
    messagingSenderId: '22797930593',
    projectId: 'dacn-8ecee',
    authDomain: 'dacn-8ecee.firebaseapp.com',
    storageBucket: 'dacn-8ecee.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbE7-baG1wEEZ2oEKhP6pYkMQ4Iq6gcro',
    appId: '1:22797930593:ios:777b0e2e86c3aa10389a20',
    messagingSenderId: '22797930593',
    projectId: 'dacn-8ecee',
    storageBucket: 'dacn-8ecee.firebasestorage.app',
    iosClientId: '22797930593-8jks7pln3fieimlhfshn33ni1l7u8lga.apps.googleusercontent.com',
    iosBundleId: 'com.example.duandemo',
  );
}
