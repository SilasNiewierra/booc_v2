import 'package:booc/services/authenticate.dart';
import 'package:booc/services/colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final AuthenticationService authenticationService =
      new AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: RaisedButton(
          onPressed: () {
            authenticationService.signOut();
          },
          child: Text(
            "Sign Out",
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: ColorService().getLightTextColor(),
                ),
          )),
    ));
  }
}
