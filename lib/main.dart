import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './provider/cart.dart';
import './provider/orders.dart';
import './provider/product.dart';
import './screens/cart_screen.dart';
import './screens/home_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_details_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/manage_products_screen.dart';
import './styles/my_shop_style.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData theme = MyShopStyle.theme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(create: (context) => Products()),
        ChangeNotifierProvider<Cart>(create: (context) => Cart()),
        ChangeNotifierProvider<Orders>(create: (context) => Orders()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: theme,
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName :(context) => const HomeScreen(),
          ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
          CartScreen.routeName :( context) => const CartScreen(),
          OrdersScreen.routeName : (context) => const OrdersScreen(),
          ManageProductsScreen.routeName : (context) => const ManageProductsScreen(),
          EditProductScreen.routeName : (context) => const EditProductScreen(),
        },
      ),
    );
  }
}
