import 'package:booc/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // stream read books
  Stream<List<Book>> streamReadBooks(User user) {
    return _db
        .collection('read_books')
        .doc(user.uid)
        .collection('books')
        .snapshots()
        .map(
            (list) => list.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }

  // stream searched by query in read books
  Stream<List<Book>> searchReadBooks(User user, String query) {
    String cleanQuery = query.replaceAll(new RegExp(r"\s+"), "");

    return _db
        .collection('read_books')
        .doc(user.uid)
        .collection('books')
        // .where("search_keywords", arrayContains: cleanQuery)
        .where('title', isGreaterThanOrEqualTo: cleanQuery.toUpperCase())
        .where('title', isLessThan: cleanQuery.toLowerCase() + 'z')
        .snapshots()
        .map(
            (list) => list.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }

  // stream bucket books
  Stream<List<Book>> streamBucketBooks(User user) {
    return _db
        .collection('bucket_books')
        .doc(user.uid)
        .collection('books')
        .snapshots()
        .map(
            (list) => list.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }

  // stream recommended books
  Stream<List<Book>> streamRecommendedBooks(User user) {
    return _db
        .collection('books')
        .doc(user.uid)
        .collection('books')
        .snapshots()
        .map(
            (list) => list.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }

  // upload a new book to user read section
  Future addBook(User user, Book book) async {
    try {
      List<String> keywords = [];
      // for (int i = 0; i < book.title.length; i++) {
      //   String word = book.title.substring(0, i);
      //   keywords.add(word);
      // }
      dynamic result = await _db
          .collection('read_books')
          .doc(user.uid)
          .collection('books')
          .add({
        'author': book.author,
        'category': book.category,
        'description': book.description,
        'img_url': book.imageUrl,
        'title': book.title,
        'search_keywords': keywords
      });
      return result;
    } catch (e) {
      print(e);
      return null;
    }
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
          // update(user, book, doc.id);
          delete(user, doc.id);
        });
      }
      print("data is empty");
    });
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
