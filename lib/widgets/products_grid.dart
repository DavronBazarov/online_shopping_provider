import 'package:flutter/material.dart';
import 'package:online_shopping_provider/models/product.dart';
import 'package:online_shopping_provider/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;
  const ProductsGrid({
    super.key, required this.showOnlyFavorites,
  });

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showOnlyFavorites ? productsData.showFavorites : productsData.list;
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        return ChangeNotifierProvider<ModelProduct>.value(
          value: products[i],
          child: const ProductItem(),
        );
      },
    );
  }
}
