import 'package:booc/services/colors.dart';
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
              builder: (context, child) {
                return new Theme(
                  data: _boocTheme(MediaQuery.of(context).size.height),
                  child: child,
                );
              },
              home: Root(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(body: Text("Loading Firebase ..."));
      },
    );
  }

  ThemeData _boocTheme(double height) {
    return ThemeData(
      primaryColor: ColorService().getPrimaryColor(),
      accentColor: ColorService().getPrimaryColor(),
      buttonColor: ColorService().getPrimaryColor(),
      backgroundColor: ColorService().getBackgroundColor(),
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: height / 15, color: ColorService().getPrimaryColor()),
        headline2: TextStyle(
            fontSize: height / 20, color: ColorService().getPrimaryColor()),
        headline3: TextStyle(
            fontSize: height / 30, color: ColorService().getPrimaryColor()),
        headline4: TextStyle(
            fontSize: height / 35, color: ColorService().getPrimaryColor()),
        headline5: TextStyle(
            fontSize: height / 50, color: ColorService().getPrimaryColor()),
        headline6: TextStyle(
            fontSize: height / 65, color: ColorService().getPrimaryColor()),
        bodyText1: TextStyle(
            fontSize: height / 70, color: ColorService().getPrimaryColor()),
        bodyText2: TextStyle(
            fontSize: height / 80, color: ColorService().getPrimaryColor()),
      ),
    );
  }
}
