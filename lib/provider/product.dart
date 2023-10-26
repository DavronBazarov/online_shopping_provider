import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping_provider/services/http_exeption.dart';
import '../models/product.dart';

class Products extends ChangeNotifier {
  List<ModelProduct> _list = [];


  List<ModelProduct> get list {
    return [..._list];
  }

  List<ModelProduct> get showFavorites {
    return _list.where((element) => element.isFavorite).toList();
  }

  ModelProduct findById(String productId) {
    return _list.firstWhere((element) => element.id == productId);
  }

  String? _authToken;
  String? _userId;

  void setParams(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  Future<void> getDateFromFirebase([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"':"";
    final url = Uri.parse(
      'https://online-shopp-provider-default-rtdb.firebaseio.com/products.json?&auth=$_authToken&$filterString',
    );
    try {
      final response = await http.get(url);
      log("======${response.body}");
      if (jsonDecode(response.body) != null) {
        ///get favorite for user
        final favoriteUrl = Uri.parse(
            'https://online-shopp-provider-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken');
        final favoriteResponse = await http.get(favoriteUrl);
        final favoriteData = jsonDecode(favoriteResponse.body);

        ///
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<ModelProduct> loadedProducts = [];
        data.forEach((productId, productData) {
          loadedProducts.add(
            ModelProduct(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              imageUrl: productData['imageUrl'],
              isFavorite: favoriteData == null
                  ? false
                  : favoriteData[productId] ?? false,
            ),
          );
        });
        _list = loadedProducts;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(ModelProduct updatedProduct) async {
    final indexProduct =
        _list.indexWhere((product) => product.id == updatedProduct.id);
    if (indexProduct >= 0) {
      final url = Uri.parse(
        'https://online-shopp-provider-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json?auth=$_authToken',
      );
      try {
        await http.patch(url,
            body: jsonEncode({
              'title': updatedProduct.title,
              'description': updatedProduct.description,
              'price': updatedProduct.price,
              'imageUrl': updatedProduct.imageUrl,
            }));
        _list[indexProduct] = updatedProduct;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> addProduct(ModelProduct product) async {
    final url = Uri.parse(
      'https://online-shopp-provider-default-rtdb.firebaseio.com/products.json?auth=$_authToken',
    );
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': _userId,
          },
        ),
      );
      final name = (jsonDecode(response.body) as Map<String, dynamic>)['name'];
      final newProduct = ModelProduct(
        id: name,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _list.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
      'https://online-shopp-provider-default-rtdb.firebaseio.com/products/$productId.json?auth=$_authToken',
    );
    try {
      var deletingProduct =
          _list.firstWhere((product) => product.id == productId);
      final productIndex =
          _list.indexWhere((product) => product.id == productId);
      _list.removeWhere((product) => product.id == productId);
      notifyListeners();

      final response = await http.delete(url);
      print("product deleting statusCode ========= ${response.statusCode}");

      if (response.statusCode >= 400) {
        _list.insert(productIndex, deletingProduct);
        notifyListeners();
        throw HttpException("Kechirasiz, o'chirishda xatolik");
      }
    } catch (e) {
      rethrow;
    }
  }
}
