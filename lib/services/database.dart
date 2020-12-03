import 'package:booc/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Book>> streamReadBooks(User user) {
    var ref = _db.collection('read_books').doc(user.uid).collection('books');

    return ref
        .snapshots()
        .map((list) => list.docs.map((doc) => Book.fromFirestore(doc)));
  }

  void oneTimeTransfer(String uId) {
    print("calling firestore");
    // var ref = FirebaseFirestore.instance.collection('books');

    // ref.snapshots().map((list) {
    //   return list.docs.map((doc) {
    //     Book book = Book.fromFirestore(doc);
    //     addUser(book, uId);
    //     return book;
    //   });
    // });

    FirebaseFirestore.instance
        .collection('books')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                Book book = Book.fromFirestore(doc);
                addUser(book, uId);
              })
            });
  }

  Future<void> addUser(Book book, String uId) {
    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance
        .collection('bucket_books')
        .doc(uId)
        .collection('books')
        .add({
          'author': book.author,
          'category': book.category,
          'description': book.description,
          'img_url': book.imageUrl,
          'title': book.title
        })
        .then((value) => print("Book Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
