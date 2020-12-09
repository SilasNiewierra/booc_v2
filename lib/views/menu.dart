import 'package:booc/services/authenticate.dart';
import 'package:booc/views/analytics.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final AuthenticationService _authService = new AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2.0,
                width: 50,
                margin: EdgeInsets.symmetric(vertical: 10.0),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnalyticsScreen(animate: true),
                    ),
                  );
                },
                child: Text(
                  "Analytics",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 2.0,
                width: 50,
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.symmetric(vertical: 5.0),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _authService.signOut();
                },
                child: Text(
                  "Logout",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(Icons.close, color: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
