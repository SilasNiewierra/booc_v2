import 'package:booc/models/book_model.dart';
import 'package:booc/models/variables.dart';
import 'package:booc/services/authenticate.dart';
import 'package:booc/services/database.dart';
import 'package:booc/views/book_item.dart';
import 'package:booc/views/bucket.dart';
import 'package:booc/views/menu.dart';
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
            Text("Check out all the books you've read",
                style: Theme.of(context).textTheme.headline5),
            Container(
              color: Colors.red,
              margin: EdgeInsets.symmetric(vertical: 5.0),
              height: 40.0,
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10.0),
            //   child: CustomRadioButton(
            //     buttonLables: [
            //       'Read',
            //       'Bucket',
            //       'For Your',
            //     ],
            //     buttonValues: [
            //       PageContext.read,
            //       PageContext.bucket,
            //       PageContext.recommend,
            //     ],
            //     radioButtonValue: (value) {
            //       print(value);
            //       pageContextNotifier.value = value;
            //     },
            //     defaultSelected: PageContext.read,
            //     elevation: 0,
            //     enableShape: true,
            //     wrapAlignment: WrapAlignment.spaceAround,
            //     buttonTextStyle: ButtonTextStyle(
            //         selectedColor: Colors.white,
            //         unSelectedColor: Colors.black,
            //         textStyle: Theme.of(context).textTheme.subtitle1),
            //     unSelectedColor: Theme.of(context).canvasColor,
            //     selectedColor: Theme.of(context).accentColor,
            //   ),
            // ),
            ValueListenableBuilder(
                valueListenable: pageContextNotifier,
                builder: (context, PageContext pageContext, wdgt) {
                  return StreamBuilder(
                      stream: _selectStreamData(pageContext, user),
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
                                      (index) =>
                                          BookItem(book: snapshot.data[index]),
                                    ),
                                  ),
                                )
                              : Container(), // Empty
                        );
                      });
                })
          ],
        ));
  }

  Stream<List<Book>> _selectStreamData(PageContext pageContext, User user) {
    switch (pageContext) {
      case PageContext.read:
        return _db.streamReadBooks(user);
        break;
      case PageContext.bucket:
        return _db.streamRecommendedBooks(user);
        break;
      default:
        return _db.streamReadBooks(user);
    }
  }
}
