import 'package:booc/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Book>> streamReadBooks(User user) {
    return _db
        .collection('read_books')
        .doc(user.uid)
        .collection('books')
        .snapshots()
        .map(
            (list) => list.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }

  Stream<List<Book>> streamBucketBooks(User user) {
    return _db
        .collection('bucket_books')
        .doc(user.uid)
        .collection('books')
        .snapshots()
        .map(
            (list) => list.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }

  Stream<List<Book>> streamRecommendedBooks(User user) {
    return _db
        .collection('books')
        .doc(user.uid)
        .collection('books')
        .snapshots()
        .map(
            (list) => list.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }
}
