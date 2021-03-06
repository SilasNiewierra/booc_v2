import 'package:booc/models/book_model.dart';
import 'package:booc/models/variables.dart';
import 'package:booc/services/colors.dart';
import 'package:booc/services/database.dart';
import 'package:booc/views/detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BookItem extends StatelessWidget {
  final Book book;
  final PageContext pageContext;
  final DatabaseService db;

  BookItem(
      {@required this.book, @required this.pageContext, @required this.db});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => DetailScreen(
                      bookItem: book,
                      pageContext: pageContext,
                    )));
      },
      child: Container(
        height: size.height / 2.7,
        width: (size.height / 2.7) * 0.75,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Hero(
                tag: book.uId,
                child: Image.network(
                  book.imageUrl,
                  height: size.height / 3.5,
                  width: (size.height / 2.7) * 0.75,
                  fit: BoxFit.fill,
                ),
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
                IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => SingleChildScrollView(
                          controller: ModalScrollController.of(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 50.0, horizontal: 50.0),
                            color: ColorService().getBackgroundColor(),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FlatButton.icon(
                                      icon: Icon(Icons.clear),
                                      onPressed: () async {
                                        dynamic result;
                                        if (pageContext == PageContext.read) {
                                          result = await db.deleteReadBook(
                                              Provider.of<User>(context,
                                                  listen: false),
                                              book);
                                        } else if (pageContext ==
                                            PageContext.bucket) {
                                          result = await db.deleteBucketBook(
                                              Provider.of<User>(context,
                                                  listen: false),
                                              book);
                                        }

                                        if (result != null) {
                                          Fluttertoast.showToast(
                                              msg: pageContext ==
                                                      PageContext.read
                                                  ? "Removed from your read list"
                                                  : "Removed from your bucket list",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 3,
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              textColor: Colors.white,
                                              fontSize: 20.0);
                                          Navigator.pop(context);
                                        }
                                      },
                                      label: Text(
                                          pageContext == PageContext.read
                                              ? "Remove from read list"
                                              : "Remove from bucket list",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5)),
                                  // FlatButton.icon(
                                  //     icon: Icon(Icons.favorite_outline),
                                  //     onPressed: null,
                                  //     label: Text("Like this book",
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .headline5)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
