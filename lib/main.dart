import 'package:booc/services/authenticate.dart';
import 'package:booc/views/home.dart';
import 'package:booc/views/landing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
          return Text("Something went wrong with Firebase Init");
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
              title: 'booc',
              home: Provider.of<User>(context) != null
                  ? HomePage()
                  : LandingPage(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text("Loading Firebase ...");
      },
    );
  }
}
