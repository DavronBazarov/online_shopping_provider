import 'package:flutter/material.dart';

class ModelProduct with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ModelProduct(
      {
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite(){
    isFavorite =! isFavorite;
    notifyListeners();
  }
}