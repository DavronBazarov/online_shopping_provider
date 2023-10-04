import 'package:flutter/material.dart';
import 'package:online_shopping_provider/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../provider/product.dart';

class ProductsGrid extends StatefulWidget {
  final bool showOnlyFavorites;

  const ProductsGrid({
    super.key,
    required this.showOnlyFavorites,
  });

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  late Future productsFuture;

  Future _getProductsFuture() {
    return Provider.of<Products>(context, listen: false).getDateFromFirebase();
  }

  @override
  void initState() {
    productsFuture = _getProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: productsFuture,
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (dataSnapshot.error == null) {
          return Consumer<Products>(
            builder: (ctx, products, child) {
              final pc = widget.showOnlyFavorites
                  ? products.showFavorites
                  : products.list;
              return pc.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 3 / 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                      ),
                      itemCount: pc.length,
                      itemBuilder: (context, i) {
                        return ChangeNotifierProvider<ModelProduct>.value(
                          value: pc[i],
                          child: const ProductItem(),
                        );
                      },
                    )
                  : const Center(
                      child: Text("Mahsulot mavjud emas!!!"),
                    );
            },
          );
        } else {
          return const Center(child: Text("Xatolik sodir bo'ldi"));
        }
      },
    );
  }
}
