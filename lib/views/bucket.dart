import 'package:booc/models/book_model.dart';
import 'package:booc/models/variables.dart';
import 'package:booc/services/authenticate.dart';
import 'package:booc/services/database.dart';
import 'package:booc/views/book_item.dart';
import 'package:booc/views/search_field.dart';
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
    Size size = MediaQuery.of(context).size;
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
        body: _buildBody(context, size));
  }

  Widget _buildBody(BuildContext context, Size size) {
    User user = Provider.of<User>(context);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Bucketlist",
                style: Theme.of(context).textTheme.headline3),
            Text("Books you marked for future readings",
                style: Theme.of(context).textTheme.headline5),
            SearchBar(),
            StreamBuilder(
                stream: _db.streamBucketBooks(context, user),
                builder: (context, AsyncSnapshot<List<Book>> snapshot) {
                  return Expanded(
                    child: snapshot.data.length > 0
                        ? GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: (240 / 390),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5,
                            children: List.generate(
                              snapshot.data.length,
                              (index) => BookItem(
                                book: snapshot.data[index],
                                pageContext: PageContext.bucket,
                              ),
                            ),
                          )
                        : Center(
                            child: Image.asset(
                              'assets/images/no_bucket.png',
                              width: size.width - 100,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                  );
                })
          ],
        ));
  }
}
