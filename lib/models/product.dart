import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModelProduct with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ModelProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    var oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
      'https://online-shopp-provider-default-rtdb.firebaseio.com/products/$id.json',
    );
    try {
      final response = await http.patch(
        url,
        body: jsonEncode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldFavorite;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = oldFavorite;
      notifyListeners();
    }
  }
}
