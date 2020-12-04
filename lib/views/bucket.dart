import 'package:booc/models/book_model.dart';
import 'package:booc/services/authenticate.dart';
import 'package:booc/services/database.dart';
import 'package:booc/views/book_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BucketScreen extends StatefulWidget {
  @override
  _BucketScreenState createState() => _BucketScreenState();
}

class _BucketScreenState extends State<BucketScreen> {
  final AuthenticationService authenticationService =
      new AuthenticationService();

  final DatabaseService _db = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    User user = Provider.of<User>(context);
    String userName = user.displayName == null || user.displayName.length <= 0
        ? 'Bookworm'
        : user.displayName;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hi " + userName,
                style: Theme.of(context).textTheme.headline3),
            Text("These are the books you marked for future readings",
                style: Theme.of(context).textTheme.headline5),
            Container(
              color: Colors.red,
              margin: EdgeInsets.symmetric(vertical: 5.0),
              height: 40.0,
            ),
            StreamBuilder(
                stream: _db.streamBucketBooks(user),
                builder: (context, AsyncSnapshot<List<Book>> snapshot) {
                  return Expanded(
                    child: snapshot.data.length > 0
                        ? AnimatedSwitcher(
                            duration: Duration(seconds: 1),
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: (240 / 390),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5,
                              children: List.generate(
                                snapshot.data.length,
                                (index) => BookItem(book: snapshot.data[index]),
                              ),
                            ),
                          )
                        : Container(), // Empty
                  );
                })
          ],
        ));
  }
}
