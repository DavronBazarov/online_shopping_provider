import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping_provider/provider/auth.dart';
import 'package:online_shopping_provider/provider/cart.dart';
import 'package:timer_snackbar/timer_snackbar.dart';
import '../models/product.dart';
import '../screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ModelProduct>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<ModelProduct>(
            builder: (context, pro, child) {
              return IconButton(
                onPressed: () {
                  pro.toggleFavorite(auth.token!, auth.userId!);
                },
                icon: Icon(
                  pro.isFavorite
                      ? Icons.favorite_outlined
                      : Icons.favorite_border_outlined,
                  color: Colors.teal,
                ),
              );
            },
          ),
          trailing: IconButton(
            onPressed: () {
              timerSnackbar(
                context: context,
                contentText: "A snackbar with live timer.",
                afterTimeExecute: () {
                  cart.addToCart(
                      productId: product.id,
                      title: product.title,
                      image: product.imageUrl,
                      price: product.price);
                },
                second: 2,
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor,
            ),
          ),
          backgroundColor: Colors.black87,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: CachedNetworkImage(
            imageUrl: product.imageUrl,
            key: UniqueKey(),
            placeholder: (context, url) => const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
