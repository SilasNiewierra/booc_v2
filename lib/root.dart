import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booc/views/home.dart';
import 'package:booc/views/landing.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider.of<User>(context) != null ? HomePage() : LandingPage();
  }
}
