import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:booc/root.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booc/services/authenticate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
              body: Text("Something went wrong with Firebase Init"));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
              providers: [
                // Make user stream available
                StreamProvider<User>.value(value: AuthenticationService().user),
              ],

              // All data will be available in this child and descendents
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'booc',
                home: Root(),
              ));
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(body: Text("Loading Firebase ..."));
      },
    );
  }
}
