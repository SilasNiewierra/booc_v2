import 'dart:io';

import 'package:booc/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // stream read books
  Stream<List<Book>> streamReadBooks(BuildContext context, User user) {
    return _db
        .collection('read_books')
        .doc(user.uid)
        .collection('books')
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => Book.fromFirestore(context, doc)).toList());
  }

  // stream searched by query in read books
  Stream<List<Book>> searchReadBooks(
      BuildContext context, User user, String query) {
    String cleanQuery = query.toLowerCase();

    return _db
        .collection('read_books')
        .doc(user.uid)
        .collection('books')
        .where("search_keywords", arrayContains: cleanQuery)
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => Book.fromFirestore(context, doc)).toList());
  }

  // stream bucket books
  Stream<List<Book>> streamBucketBooks(BuildContext context, User user) {
    return _db
        .collection('bucket_books')
        .doc(user.uid)
        .collection('books')
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => Book.fromFirestore(context, doc)).toList());
  }

  // stream recommended books
  Stream<List<Book>> streamRecommendedBooks(BuildContext context, User user) {
    return _db
        .collection('recommended_books')
        .doc(user.uid)
        .collection('books')
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => Book.fromFirestore(context, doc)).toList());
  }

  // upload a new book to user read section
  Future addBook(User user, Book book, File _image) async {
    try {
      String downloadURL = await uploadFile(_image);
      List<String> keywords =
          createKeywords(book.title); // + " " + book.author);
      dynamic result = await _db
          .collection('read_books')
          .doc(user.uid)
          .collection('books')
          .add({
        'author': book.author,
        'category': book.category.toString(),
        'description': book.description,
        'img_url': downloadURL ??= book.imageUrl,
        'title': book.title,
        'search_keywords': keywords
      });
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Upload image file to firestorage
  Future<String> uploadFile(File _image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    var downloadURL;
    Reference ref =
        storage.ref().child("book_covers/image_" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);
    await uploadTask.whenComplete(() {
      downloadURL = ref.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });
    return downloadURL;
  }

  // Move a book from bucket to read
  Future connectReadBook(User user, Book book) async {
    try {
      dynamic downloadResult = await _db
          .collection('bucket_books')
          .doc(user.uid)
          .collection('books')
          .doc(book.uId)
          .get()
          .then((data) async {
        if (data != null) {
          print(data);
          dynamic uploadResult = await _db
              .collection('read_books')
              .doc(user.uid)
              .collection('books')
              .add(data.data());
          if (uploadResult != null) {
            data.reference.delete();
            return uploadResult;
          } else {
            return null;
          }
        } else {
          print("data is empty");
        }
      });
      return downloadResult;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Move a book from read to general for test purposes !!! IMPORTANT  ( later just delete the book)
  Future deleteReadBook(User user, Book book) async {
    try {
      dynamic downloadResult = await _db
          .collection('read_books')
          .doc(user.uid)
          .collection('books')
          .doc(book.uId)
          .get()
          .then((data) async {
        if (data != null) {
          print(data);
          dynamic uploadResult = await _db
              .collection('general_books')
              .doc(user.uid)
              .collection('books')
              .add(data.data());
          if (uploadResult != null) {
            data.reference.delete();
            return uploadResult;
          } else {
            return null;
          }
        } else {
          print("data is empty");
        }
      });
      return downloadResult;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Create keywords for search
  List<String> createKeywords(String keywordString) {
    keywordString = keywordString.toLowerCase();
    List<String> keywords = keywordString.split(' ');
    String curName = '';
    keywordString.split(' ').forEach((word) {
      curName += word + " ";
      List<String> curWords = [];
      String tempWord = "";
      curName.split('').forEach((letter) {
        tempWord += letter;
        curWords.add(tempWord);
      });
      tempWord = "";
      word.split('').forEach((letter) {
        tempWord += letter;
        curWords.add(tempWord);
      });
      keywords.addAll(curWords);
    });
    return keywords.toSet().toList();
  }

  // HELPER: return all read books and call other helper functions
  void updateDocs(User user) {
    _db
        .collection('read_books')
        .doc(user.uid)
        .collection('books')
        .get()
        .then((data) {
      if (data != null) {
        data.docs.forEach((doc) {
          // Book book = Book.fromFirestore(doc);
          // delete(user, doc.id);
          // addKeywords(user, doc.id, book.title);
        });
      } else {
        print("data is empty");
      }
    });
  }

  // HELPER: add keywords to books
  void addKeywords(User user, String bookId, String searchString) {
    List<String> keywords = createKeywords(searchString);
    _db
        .collection('read_books')
        .doc(user.uid)
        .collection('books')
        .doc(bookId)
        .update({
          'search_keywords': keywords,
        })
        .then((val) => print("Document successfully updated!"))
        .catchError((error) => print("Error removing document: $error"));
  }

  // HELPER: add keywords to books
  void update(User user, Book book, String bookId) {
    List<String> keywords = book.title.split(" ");

    for (int i = 0; i < book.title.length; i++) {
      String word = book.title.substring(0, i);
      keywords.add(word);
    }
    _db
        .collection('read_books')
        .doc(user.uid)
        .collection('books')
        .doc(bookId)
        .update({
          'search_keywords': keywords,
        })
        .then((val) => print("Document successfully updated!"))
        .catchError((error) => print("Error removing document: $error"));
  }

  // HELPER: delete keywords from books
  void delete(User user, String bookId) {
    _db
        .collection('read_books')
        .doc(user.uid)
        .collection('books')
        .doc(bookId)
        .update({'search_keywords': FieldValue.delete()}).whenComplete(() {
      print('Field Deleted');
    });
  }
}
