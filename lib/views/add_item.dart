import 'dart:io';

import 'package:booc/models/book_model.dart';
import 'package:booc/models/variables.dart';
import 'package:booc/services/colors.dart';
import 'package:booc/services/database.dart';
import 'package:booc/views/components/dropdown_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final DatabaseService _db = new DatabaseService();

  bool uploadInProgress = false;

  final _formKey = GlobalKey<FormState>();
  String author = '';
  String category = '';
  String description = '';
  String imageUrl = '';
  String title = '';
  String error = '';
  String imageError = '';

  List<String> categories;

  File _image;
  final picker = ImagePicker();

  Future getImage(bool fromGallery) async {
    var pickedFile;

    if (fromGallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    } else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    categories = [];
    BookCategories.values.forEach((name) {
      String value = name?.toString()?.split('.')?.elementAt(1);
      if (categories.contains(value)) {
        print('already inside: ' + value.toString());
      } else {
        categories.add(value.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(size),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [],
        backgroundColor: Colors.transparent);
  }

  Widget _buildBody(Size size) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add A Book!",
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20.0),
              Text(
                "Add a new book you've read",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: ColorService().getSecondaryColor()),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 20), // add padding to adjust text
                  isDense: true,
                  hintText: "Title",
                  prefixIcon: Padding(
                    padding:
                        EdgeInsets.only(top: 15), // add padding to adjust icon
                    child: Icon(
                      Icons.book,
                      size: 30.0,
                    ),
                  ),
                ),
                validator: (val) => val.isNotEmpty ? null : 'Enter a title',
                onChanged: (val) {
                  setState(() => title = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 20), // add padding to adjust text
                  isDense: true,
                  hintText: "Author",
                  prefixIcon: Padding(
                    padding:
                        EdgeInsets.only(top: 15), // add padding to adjust icon
                    child: Icon(
                      Icons.perm_identity_outlined,
                      size: 30.0,
                    ),
                  ),
                ),
                validator: (val) => val.isNotEmpty ? null : 'Enter an author',
                onChanged: (val) {
                  setState(() => author = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 20), // add padding to adjust text
                  isDense: true,
                  hintText: "Description",
                  prefixIcon: Padding(
                    padding:
                        EdgeInsets.only(top: 15), // add padding to adjust icon
                    child: Icon(
                      Icons.subject,
                      size: 30.0,
                    ),
                  ),
                ),
                validator: (val) =>
                    val.isNotEmpty ? null : 'Enter a short description',
                onChanged: (val) {
                  setState(() => description = val);
                },
              ),
              SizedBox(height: 20.0),
              DropDownFormField(
                  hintText: 'Category',
                  validator: (val) {
                    print(val);
                    if (val == null || val == '' || val.isEmpty) {
                      return "Select a category";
                    } else {
                      return null;
                    }
                  },
                  value: category,
                  onSaved: (value) {
                    setState(() {
                      category = value;
                    });
                  },
                  onChanged: (value) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      category = value;
                    });
                  },
                  dataSource: categories),
              SizedBox(height: 20.0),
              Center(
                child: _image == null
                    ? Column(
                        children: [
                          RaisedButton(
                            onPressed: () {
                              getImage(false);
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Upload from Camera",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    color: ColorService().getLightTextColor(),
                                  ),
                            ),
                          ),
                          Text(
                            "or",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          RaisedButton(
                            onPressed: () {
                              getImage(true);
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Upload from Gallery",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    color: ColorService().getLightTextColor(),
                                  ),
                            ),
                          ),
                          Text(
                            imageError,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.red),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Image.file(
                            _image,
                            width: 240,
                            height: 340,
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.close,
                                color: ColorService().getPrimaryColor(),
                              ),
                              onPressed: () {
                                setState(() => _image = null);
                              }),
                        ],
                      ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50.0),
                child: SizedBox(
                  width: size.width,
                  child: RaisedButton(
                      child: Text(
                        "Add Book".toUpperCase(),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: ColorService().getLightTextColor()),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () async {
                        if (_image == null) {
                          setState(() =>
                              imageError = "Upload or select a book cover");
                        }
                        if (_formKey.currentState.validate() &&
                            _image != null &&
                            !uploadInProgress) {
                          uploadInProgress = true;
                          String defaultImageUrl =
                              "https://source.unsplash.com/random/800x600";
                          Book addBook = new Book(
                              author: author,
                              title: title,
                              category: category,
                              description: description,
                              imageUrl: defaultImageUrl);
                          dynamic result = await _db.addBook(
                              Provider.of<User>(context, listen: false),
                              addBook,
                              _image);
                          uploadInProgress = false;
                          if (result == null) {
                            setState(() => error =
                                "Could not add the book. Please try again");
                          } else {
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Text(
                    error,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
