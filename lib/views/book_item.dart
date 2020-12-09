import 'package:booc/models/book_model.dart';
import 'package:booc/models/variables.dart';
import 'package:booc/services/colors.dart';
import 'package:booc/views/detail.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BookItem extends StatelessWidget {
  final Book book;
  final PageContext pageContext;

  BookItem({@required this.book, @required this.pageContext});

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
                                      onPressed: null,
                                      label: Text("Remove from list",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5)),
                                  FlatButton.icon(
                                      icon: Icon(Icons.favorite_outline),
                                      onPressed: null,
                                      label: Text("Like this book",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5)),
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
