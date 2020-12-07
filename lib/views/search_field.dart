import 'package:booc/services/colors.dart';
import 'package:flutter/material.dart';

typedef void StringCallback(String val);

class SearchBar extends StatefulWidget {
  final StringCallback callback;

  SearchBar({this.callback});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String searchQuery;
  ValueNotifier<bool> searching = new ValueNotifier(false);
  FocusNode _focus = new FocusNode();
  final queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    searching.value = _focus.hasFocus;
    debugPrint("Focus: " + _focus.hasFocus.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ValueListenableBuilder(
      valueListenable: searching,
      builder: (BuildContext context, bool isSearching, Widget wdg) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isSearching ? size.width - 90 : size.width - 40,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: TextField(
                controller: queryController,
                focusNode: _focus,
                style: Theme.of(context).textTheme.headline5,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  hintText: "Search ...",
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: ColorService().getSecondaryColor()),
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(
                    Icons.search,
                    color: ColorService().getSecondaryColor(),
                  ),
                ),
                onChanged: (val) {
                  widget.callback(val);
                },
              ),
            ),
            if (isSearching) ...[
              Container(
                width: 50,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      searchQuery = "";
                    });
                    queryController.clear();
                    widget.callback(searchQuery);
                    searching.value = false;
                    _focus.unfocus();
                  },
                ),
              ),
            ]
          ],
        );
      },
    );
  }
}
