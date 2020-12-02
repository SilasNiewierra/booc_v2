import 'package:booc/services/authenticate.dart';
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
              GestureDetector(
                onTap: () {
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => AnalyticsScreen(
                  //             dataBloc: dataBloc, animate: true)));
                },
                child: Text("Analytics",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Container(
                height: 2.0,
                width: 50,
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.symmetric(vertical: 10.0),
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             BucketListScreen(dataBloc: dataBloc)));
                },
                child: Text("Bucket List",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Container(
                height: 2.0,
                width: 50,
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.symmetric(vertical: 10.0),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await _authService.signOut();
                },
                child: Text("Logout",
                    style: Theme.of(context).textTheme.headline5),
              )
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
