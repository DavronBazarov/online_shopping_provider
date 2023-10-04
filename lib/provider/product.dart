import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping_provider/services/http_exeption.dart';
import '../models/product.dart';

class Products extends ChangeNotifier {
  List<ModelProduct> _list = [
    // ModelProduct(
    //   id: "p1",
    //   title: "16-inch MacBook Pro M2 Max",
    //   price: 599,
    //   description:
    //       "21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. "
    //       "No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | "
    //       "ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. "
    //       "Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. "
    //       "Vertical viewing angle-178 degree 75 hertz. Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
    //       "Pellentesque posuere lacinia enim, aliquam laoreet mi aliquam sit amet. Cras quam urna, lacinia a libero id, tempor facilisis quam. "
    //       "Praesent nec diam a risus posuere consectetur. Etiam quis placerat felis. Nam ultricies efficitur pretium. Duis non purus lobortis, consequat quam quis, accumsan dolor. "
    //       "Phasellus tempor scelerisque varius. Phasellus ornare, neque at congue egestas, risus nisi faucibus lectus, a tempus ex erat ut nulla. Nunc eget sollicitudin nunc. "
    //       "Suspendisse molestie maximus venenatis. Nam mollis leo dolor, aliquam euismod purus convallis eu"
    //       " Cras viverra luctus massa, eu hendrerit risus feugiat vel. "
    //       "Cras condimentum, metus eget gravida vulputate, lorem neque mollis ex, id faucibus turpis augue at enim. Proin a lacus molestie, tristique sem id, placerat urna. Mauris sit amet dolor diam. "
    //       "Cras sem ipsum, consectetur et elit non, venenatis ornare ante. Nam cursus est vitae orci venenatis, id commodo justo tempus. Vivamus a sem non velit imperdiet tempus. "
    //       "Curabitur pharetra at mi non hendrerit. Aliquam nibh arcu, facilisis et congue congue, blandit rutrum massa. Duis sed mattis lectus. Vivamus condimentum eu purus sed finibus. "
    //       "Etiam tempus nisi ac elementum tristique. Vestibulum vitae eros suscipit, varius magna id, mattis mauris. Maecenas facilisis lacus non elit semper fringilla.",
    //   imageUrl:
    //       "https://photos5.appleinsider.com/gallery/52635-105565-16-inch-MacBook-Pro-with-M2-Max-xl.jpg",
    // ),
    // ModelProduct(
    //   id: "p2",
    //   title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
    //   price: 109.95,
    //   description:
    //       "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
    //   imageUrl: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
    // ),
    // ModelProduct(
    //   id: "p3",
    //   title: "Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin",
    //   price: 599,
    //   description:
    //       "21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz",
    //   imageUrl: "https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg",
    // ),
    // ModelProduct(
    //   id: "p4",
    //   title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
    //   price: 109.95,
    //   description:
    //       "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
    //   imageUrl: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
    // ),
    // ModelProduct(
    //   id: "p5",
    //   title: "Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin",
    //   price: 599,
    //   description:
    //       "21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz",
    //   imageUrl: "https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg",
    // ),
    // ModelProduct(
    //   id: "p6",
    //   title: "16-inch MacBook Pro M2 Max",
    //   price: 599,
    //   description:
    //       "21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz",
    //   imageUrl:
    //       "https://photos5.appleinsider.com/gallery/52635-105565-16-inch-MacBook-Pro-with-M2-Max-xl.jpg",
    // ),
  ];

  List<ModelProduct> get list {
    return [..._list];
  }

  List<ModelProduct> get showFavorites {
    return _list.where((element) => element.isFavorite).toList();
  }

  ModelProduct findById(String productId) {
    return _list.firstWhere((element) => element.id == productId);
  }

  Future<void> updateProduct(ModelProduct updatedProduct) async {
    final indexProduct =
    _list.indexWhere((product) => product.id == updatedProduct.id);
    if (indexProduct >= 0) {
      final url = Uri.parse(
        'https://online-shopp-provider-default-rtdb.firebaseio.com/products/${updatedProduct
            .id}.json',
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

  Future<void> getDateFromFirebase() async {
    final url = Uri.parse(
      'https://online-shopp-provider-default-rtdb.firebaseio.com/products.json',
    );
    try {
      final response = await http.get(url);

      if (jsonDecode(response.body) != null) {
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
              isFavorite: productData['isFavorite'],
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

  Future<void> addProduct(ModelProduct product) async {
    final url = Uri.parse(
      'https://online-shopp-provider-default-rtdb.firebaseio.com/products.json',
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
            'isFavorite': product.isFavorite,
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

  Future <void> deleteProduct(String productId) async {
    final url = Uri.parse(
      'https://online-shopp-provider-default-rtdb.firebaseio.com/products/$productId.json',
    );
    try {
      var deletingProduct =
      _list.firstWhere((product) => product.id == productId);
      final productIndex = _list.indexWhere((product) =>
      product.id == productId);
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
