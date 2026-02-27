import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyCBBc6R4IyVdPh-iBPG2scqxEV1W8bvVxs',
    appId: '1:658654205753:web:34a9a487d6db9755387ae8',
    messagingSenderId: '658654205753',
    projectId: 'expenses-tracker-53370',
    authDomain: 'expenses-tracker-53370.firebaseapp.com',
    storageBucket: 'expenses-tracker-53370.firebasestorage.app',
    measurementId: 'G-FVWBVQNSE8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQdbZx-D7-Bzsdy-iKZLhYjTMgICyWQ5Y',
    appId: '1:658654205753:android:20421c7dbc8c30e3387ae8',
    messagingSenderId: '658654205753',
    projectId: 'expenses-tracker-53370',
    storageBucket: 'expenses-tracker-53370.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2vMfpSg0dAYzDwMbxDB5MJ7tzcC6kMxg',
    appId: '1:658654205753:ios:8a9a307618547431387ae8',
    messagingSenderId: '658654205753',
    projectId: 'expenses-tracker-53370',
    storageBucket: 'expenses-tracker-53370.firebasestorage.app',
    iosBundleId: 'com.example.expensesTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA2vMfpSg0dAYzDwMbxDB5MJ7tzcC6kMxg',
    appId: '1:658654205753:ios:8a9a307618547431387ae8',
    messagingSenderId: '658654205753',
    projectId: 'expenses-tracker-53370',
    storageBucket: 'expenses-tracker-53370.firebasestorage.app',
    iosBundleId: 'com.example.expensesTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCBBc6R4IyVdPh-iBPG2scqxEV1W8bvVxs',
    appId: '1:658654205753:web:0bc9c7a13ff326d9387ae8',
    messagingSenderId: '658654205753',
    projectId: 'expenses-tracker-53370',
    authDomain: 'expenses-tracker-53370.firebaseapp.com',
    storageBucket: 'expenses-tracker-53370.firebasestorage.app',
    measurementId: 'G-MBHC7FHNR0',
  );
}
