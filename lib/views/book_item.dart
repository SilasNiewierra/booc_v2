import 'package:booc/models/analytics_model.dart';
import 'package:booc/models/book_model.dart';
import 'package:booc/views/detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookItem extends StatefulWidget {
  final Book book;

  BookItem({this.book});

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  @override
  Widget build(BuildContext context) {
    final analyticsModel = Provider.of<AnalyticsModel>(context, listen: false);
    analyticsModel.addBookToAnalytics(widget.book);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => DetailScreen(bookItem: widget.book)));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Hero(
                tag: widget.book.uId,
                child: Image.network(
                  widget.book.imageUrl,
                  height: 340,
                  width: 240,
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
                        widget.book.title,
                        style: Theme.of(context).textTheme.headline6,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(widget.book.author,
                          style: Theme.of(context).textTheme.bodyText2)
                    ],
                  ),
                ),
                IconButton(icon: Icon(Icons.more_vert), onPressed: null)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
