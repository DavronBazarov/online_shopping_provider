

import 'package:flutter/widgets.dart';
import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int cartCount() {
    return _items.length;
  }

  double get totalPrices {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addToCart({
    required String productId,
    required String title,
    required String image,
    required double price,
  }) {
    if (_items.containsKey(productId)) {
      ///sonini ko'paytirsin
      _items.update(
        productId,
        (currentProduct) => CartItem(
          id: currentProduct.id,
          title: currentProduct.title,
          quantity: currentProduct.quantity + 1,
          price: currentProduct.price,
          image: currentProduct.image,
        ),
      );
    } else {
      ///yangi mahsulot savatchaga qo'shsin
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: UniqueKey().toString(),
          title: title,
          quantity: 1,
          price: price,
          image: image,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (currentProduct) => CartItem(
            id: currentProduct.id,
            title: currentProduct.title,
            quantity: currentProduct.quantity-1,
            price: currentProduct.price,
            image: currentProduct.image),
      );
    }
    notifyListeners();
  }
  void removeItem({required String productId}){
    _items.remove(productId);
    notifyListeners();
  }

  void clearItems(){
    _items.clear();
    notifyListeners();
  }
}
