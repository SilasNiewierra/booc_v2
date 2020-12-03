import 'package:booc/models/book_model.dart';
import 'package:booc/services/authenticate.dart';
import 'package:booc/services/database.dart';
import 'package:booc/views/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticationService authenticationService =
      new AuthenticationService();

  final DatabaseService _db = new DatabaseService();

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
            Container(
              color: Colors.green,
              child: CustomRadioButton(
                defaultSelected: "READ",
                elevation: 0,
                enableShape: true,
                // absoluteZeroSpacing: true,
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
            ),
            StreamBuilder(
                stream: _db.streamReadBooks(user),
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
                              (index) => _buildBook(snapshot.data[index]),
                            ),
                          )
                        : Container(), // Empty
                  );
                })
          ],
        ));
  }

  Widget _buildBook(Book book) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              book.imageUrl,
              height: 340,
              width: 240,
              fit: BoxFit.fill,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(book.author,
                        style: Theme.of(context).textTheme.bodyText2)
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.more_vert), onPressed: null)
            ],
          ),
        ],
      ),
    );
  }
}
