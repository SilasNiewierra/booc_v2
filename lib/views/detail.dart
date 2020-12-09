import 'package:booc/models/book_model.dart';
import 'package:booc/models/variables.dart';
import 'package:booc/services/colors.dart';
import 'package:booc/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final Book bookItem;
  final PageContext pageContext;

  DetailScreen({@required this.bookItem, @required this.pageContext});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final DatabaseService _db = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: size.height),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              // Title and Author
              _buildHeading(),
              // Content
              _buildContent(size),
              // Cover Image
              _buildCover(size.height),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: ColorService().getLightTextColor(),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [],
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  Widget _buildHeading() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bookItem.author,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: ColorService().getLightTextColor(),
                ),
          ),
          Text(
            widget.bookItem.title,
            style: Theme.of(context).textTheme.headline4.copyWith(
                color: ColorService().getLightTextColor(),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: ((size.height / 2.7) + (size.height * 0.15) - 50)),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.bookItem.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            // Category and Like
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category: " + enumToTitle(widget.bookItem.category),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Theme.of(context).accentColor,
                    size: 35.0,
                  ),
                  onPressed: () {
                    // widget.bookItem.updateLiked(!like);
                  },
                ),
              ],
            ),
            // Bottom Buttons
            Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: SizedBox(
                width: size.width,
                child: RaisedButton(
                    color: Theme.of(context).backgroundColor,
                    child: Text(
                      widget.pageContext == PageContext.read
                          ? "I haven't read that book".toUpperCase()
                          : "I have read that book".toUpperCase(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 3.0)),
                    onPressed: () async {
                      // remove book from read list
                      if (widget.pageContext == PageContext.read) {
                        dynamic result = await _db.deleteReadBook(
                            Provider.of<User>(context, listen: false),
                            widget.bookItem);
                        if (result != null) {
                          Fluttertoast.showToast(
                              msg: "Removed from your read list",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              fontSize: 20.0);
                          Navigator.pop(context);
                        }
                      }
                      // add book to read list and if bucketed remove from bucket list
                      else {
                        dynamic result = await _db.connectReadBook(
                            Provider.of<User>(context, listen: false),
                            widget.bookItem);
                        if (result != null) {
                          Fluttertoast.showToast(
                              msg: "Added to your read list",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              fontSize: 20.0);
                          Navigator.pop(context);
                        }
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(double height) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.15),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: (height / 2.7),
            width: (height / 2.7) * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Hero(
                tag: widget.bookItem.uId,
                child: Image.network(
                  widget.bookItem.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
