import 'package:booc/services/authenticate.dart';
import 'package:booc/services/database.dart';
import 'package:booc/views/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class HomePage extends StatelessWidget {
  final AuthenticationService authenticationService =
      new AuthenticationService();

  final DatabaseService _databaseService = new DatabaseService();
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
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    User user = Provider.of<User>(context);
    String userName = user.displayName ?? 'Bookworm';
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi " + userName,
                style: Theme.of(context).textTheme.headline3),
            Text("Check out all the books you've read",
                style: Theme.of(context).textTheme.headline5),
            Container(
              color: Colors.red,
              height: 40.0,
            ),
            RaisedButton(
              onPressed: () {
                _databaseService.oneTimeTransfer(user.uid);
              },
              child: Text("Transfer"),
            ),
            CustomRadioButton(
              defaultSelected: "READ",
              elevation: 0,
              enableShape: true,
              absoluteZeroSpacing: true,
              unSelectedColor: Theme.of(context).canvasColor,
              buttonLables: [
                'Read',
                'Bucket',
                'Explore',
              ],
              buttonValues: [
                "READ",
                "BUCKET",
                "EXPLORE",
              ],
              buttonTextStyle: ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16)),
              radioButtonValue: (value) {
                print(value);
              },
              selectedColor: Theme.of(context).accentColor,
            ),
          ],
        ));
  }
}
