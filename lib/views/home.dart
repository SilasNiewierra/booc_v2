import 'package:booc/services/authenticate.dart';
import 'package:booc/views/menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final AuthenticationService authenticationService =
      new AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MenuScreen()));
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container());
  }
}
