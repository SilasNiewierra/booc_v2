import 'package:booc/models/analytics_model.dart';
import 'package:booc/models/variables.dart';
import 'package:booc/services/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Book {
  final String uId;
  final String author;
  final BookCategories category;
  final String description;
  final String imageUrl;
  // final bool liked;
  final String title;

  Book(
      {this.uId,
      this.author,
      this.category,
      this.description,
      this.imageUrl,
      // this.liked,
      this.title});

  factory Book.fromFirestore(BuildContext context, DocumentSnapshot data) {
    // add category to analytics
    final analyticsModel = Provider.of<AnalyticsModel>(context, listen: false);
    BookCategories category;
    if (data['category'] != null) {
      category = enumFromString(data['category'].toString());
    } else {
      category = BookCategories.novel;
    }
    analyticsModel.addBookToAnalytics(category);

    // add color palette
    final colorService = Provider.of<ColorService>(context, listen: false);
    colorService.addPallete(data['img_url'], data.id);

    // Map data to book model
    return Book(
        uId: data.id ?? '',
        author: data['author'] ?? 'Michael Scott',
        category: category,
        description: data['description'] ??
            'Just a man trying to make it in the paper business',
        imageUrl: data['img_url'] ?? 'https://i.redd.it/e3e34m66mip01.png',
        // liked: data['liked'] ?? false,
        title: data['title'] ?? 'The One and Only');
  }
}
