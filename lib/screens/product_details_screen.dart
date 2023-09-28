import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping_provider/provider/cart.dart';
import 'package:online_shopping_provider/provider/product.dart';
import 'package:online_shopping_provider/screens/cart_screen.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = '/product_detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments;
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(product.description),
            ),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        height: 80,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Narxi:",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                Text(
                  "\$${product.price}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Consumer<Cart>(builder: (context, cart, child) {
              final isProductAdded = cart.items.containsKey(productId);
              if (isProductAdded) {
                return ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, CartScreen.routeName),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                  ),
                  label: const Text(
                    "Savatchaga borish",
                    style: TextStyle(color: Colors.black),
                  ),
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black,
                    size: 16,
                  ),
                );
              } else {
                return ElevatedButton(
                  onPressed: () => cart.addToCart(
                    productId: productId.toString(),
                    title: product.title,
                    image: product.imageUrl,
                    price: product.price,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                  ),
                  child: const Text("Savatchaga qo'shish"),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
