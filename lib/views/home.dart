import 'package:booc/services/authenticate.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final AuthenticationService authenticationService =
      new AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: RaisedButton(onPressed: () {
        authenticationService.signOut();
      }),
    ));
  }
}
