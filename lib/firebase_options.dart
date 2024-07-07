// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
// import 'firebase_options.dart';
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
///
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
    apiKey: 'AIzaSyBAGuSC_UWNCixzXXTCYz6r0IblIwOs0rc',
    appId: '1:294654348592:web:50fb484d7358e839388cf5',
    messagingSenderId: '294654348592',
    projectId: 'push-library-7396d',
    authDomain: 'push-library-7396d.firebaseapp.com',
    storageBucket: 'push-library-7396d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCr5aPYfxFro_6aUli5TYFNdmkGkrIB-UI',
    appId: '1:294654348592:android:5148283e6ea2a8da388cf5',
    messagingSenderId: '294654348592',
    projectId: 'push-library-7396d',
    storageBucket: 'push-library-7396d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAll7XXAHnsKE2TYlXRIO64hW8HKMzByWQ',
    appId: '1:294654348592:ios:75727c6472fe9039388cf5',
    messagingSenderId: '294654348592',
    projectId: 'push-library-7396d',
    storageBucket: 'push-library-7396d.appspot.com',
    iosBundleId: 'com.example.pustaka',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAll7XXAHnsKE2TYlXRIO64hW8HKMzByWQ',
    appId: '1:294654348592:ios:75727c6472fe9039388cf5',
    messagingSenderId: '294654348592',
    projectId: 'push-library-7396d',
    storageBucket: 'push-library-7396d.appspot.com',
    iosBundleId: 'com.example.pustaka',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBAGuSC_UWNCixzXXTCYz6r0IblIwOs0rc',
    appId: '1:294654348592:web:30d7e60196f4f9eb388cf5',
    messagingSenderId: '294654348592',
    projectId: 'push-library-7396d',
    authDomain: 'push-library-7396d.firebaseapp.com',
    storageBucket: 'push-library-7396d.appspot.com',
  );
}
