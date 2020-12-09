import 'package:booc/models/book_model.dart';
import 'package:booc/models/variables.dart';
import 'package:booc/views/detail.dart';
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final Book book;
  final PageContext pageContext;

  BookItem({@required this.book, @required this.pageContext});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Hero(
                tag: book.uId,
                child: Image.network(
                  book.imageUrl,
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
      ),
    );
  }
}
