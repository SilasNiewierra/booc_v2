import 'package:booc/models/book_model.dart';
import 'package:booc/models/variables.dart';
import 'package:booc/services/colors.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Book bookItem;

  DetailScreen({@required this.bookItem});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    Size queryData = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: queryData.height),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              // Title and Author
              _buildHeading(),
              // Content
              _buildContent(queryData.height),
              // Cover Image
              _buildCover(queryData.height),
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

  Widget _buildContent(double height) {
    return Container(
      margin: EdgeInsets.only(top: ((height / 2.7) + (height * 0.15) - 50)),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
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
            // Category and Like
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category: " + enumToTitle(widget.bookItem.category),
                  style: Theme.of(context).textTheme.headline5,
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
            // Description
            Container(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                widget.bookItem.description,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            // Bottom Buttons
            Container(
              margin: EdgeInsets.only(bottom: 30.0),
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 30.0),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        onPressed: null,
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).accentColor,
                            size: 30,
                          ),
                        ),
                      )),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        color: Theme.of(context).accentColor,
                        onPressed: null,
                        child: Text(
                          "Unread".toUpperCase(),
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              color: ColorService().getLightTextColor()),
                        ),
                      ),
                    ),
                  ),
                ],
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
