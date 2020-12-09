import 'package:booc/models/book_model.dart';
import 'package:booc/models/variables.dart';
import 'package:booc/services/authenticate.dart';
import 'package:booc/services/colors.dart';
import 'package:booc/services/database.dart';
import 'package:booc/views/add_item.dart';
import 'package:booc/views/book_item.dart';
import 'package:booc/views/bucket.dart';
import 'package:booc/views/menu.dart';
import 'package:booc/views/search_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthenticationService authenticationService =
      new AuthenticationService();

  final DatabaseService _db = new DatabaseService();
  ValueNotifier<PageContext> pageContextNotifier =
      new ValueNotifier<PageContext>(PageContext.read);

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MenuScreen()));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
              icon: Icon(Icons.bookmark_border,
                  color: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BucketScreen()));
              })
        ],
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: _buildBody(context, size)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddBookScreen()));
        },
        child: Icon(
          Icons.add,
          color: ColorService().getLightTextColor(),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Size size) {
    User user = Provider.of<User>(context);
    String userMail = user.email.split('@').elementAt(0);
    String userName = userMail == null
        ? 'Bookworm'
        : "${userMail[0].toUpperCase()}${userMail.substring(1)}";

    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hi " + userName,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline3),
            Text("Check out all the books you've read",
                style: Theme.of(context).textTheme.headline5),
            SearchBar(callback: (val) => setState(() => searchQuery = val)),
            ValueListenableBuilder(
                valueListenable: pageContextNotifier,
                builder: (context, PageContext pageContext, wdgt) {
                  return StreamBuilder(
                      stream: _selectStreamData(pageContext, user),
                      builder: (context, AsyncSnapshot<List<Book>> snapshot) {
                        return Expanded(
                          child: snapshot.data.length > 0
                              ? GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.61,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 5,
                                  children: List.generate(
                                    snapshot.data.length,
                                    (index) => BookItem(
                                      book: snapshot.data[index],
                                      pageContext: PageContext.read,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Image.asset(
                                    'assets/images/no_books.png',
                                    width: size.width - 100,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                        );
                      });
                })
          ],
        ));
  }

  Stream<List<Book>> _selectStreamData(PageContext pageContext, User user) {
    switch (pageContext) {
      case PageContext.read:
        return searchQuery == null || searchQuery == ""
            ? _db.streamReadBooks(context, user)
            : _db.searchQueryInBooks(
                context, user, searchQuery, PageContext.read);
        break;
      case PageContext.bucket:
        return _db.streamRecommendedBooks(context, user);
        break;
      default:
        return _db.streamReadBooks(context, user);
    }
  }
}
