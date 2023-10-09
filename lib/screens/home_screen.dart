import 'package:flutter/material.dart';
import 'package:online_shopping_provider/provider/cart.dart';
import 'package:online_shopping_provider/widgets/app_drawer.dart';
import 'package:online_shopping_provider/widgets/custom_cart.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';

enum FiltersOptions {
  Favorites,
  All,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mening Do'konim"),
        actions: [
          PopupMenuButton(onSelected: (FiltersOptions filter) {
            setState(() {
              if (filter == FiltersOptions.All) {
                /// Barchasini ko'rsat
                _showOnlyFavorites = false;
              } else {
                /// Sevimlilarni ko'rsat
                _showOnlyFavorites = true;
              }
            });
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: FiltersOptions.All,
                child: Text("Barchasi"),
              ),
              const PopupMenuItem(
                value: FiltersOptions.Favorites,
                child: Text("Sevimli"),
              ),
            ];
          }),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return CustomCart(
                number: cart.cartCount().toString(),
                child: child!,
              );
            },
            child: const Icon(Icons.shopping_cart),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(
        showOnlyFavorites: _showOnlyFavorites,
      ),
    );
  }
}
