import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String author;
  final String category;
  final String description;
  final String imageUrl;
  final String title;

  Book(
      {this.author,
      this.category,
      this.description,
      this.imageUrl,
      this.title});

  factory Book.fromFirestore(DocumentSnapshot data) {
    data = data ?? {};
    return Book(
        author: data['author'] ?? 'Michael Scott',
        category: data['category'] ?? 'Novel',
        description: data['description'] ??
            'Just a man trying to make it in the paper business',
        imageUrl: data['img_url'] ?? 'https://i.redd.it/e3e34m66mip01.png',
        title: data['title'] ?? 'The One and Only');
  }
}
