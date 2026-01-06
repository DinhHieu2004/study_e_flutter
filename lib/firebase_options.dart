import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<FirebaseApp> initializeFirebase() async {
  if (kIsWeb) {
    return await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCjMHXgExNfnv05WtJKkJO15Ua5Lq25-0s",
        appId: "1:1046909285790:android:027ecc650b8bf9e0dc528f",
        messagingSenderId: "1046909285790",
        projectId: "studye-c83d0",
        authDomain: "studye-c83d0.firebaseapp.com",
        storageBucket: "studye-c83d0.appspot.com",
      ),
    );
  } else {
    return await Firebase.initializeApp();
  }
}
