import 'package:flutter/material.dart';
import 'package:online_shopping_provider/provider/auth.dart';
import 'package:online_shopping_provider/screens/auth_screen.dart';
import 'package:online_shopping_provider/screens/splash_screen.dart';

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
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(),
          update: (context, auth, previousProducts) =>
              Products()..setParams(auth.token, auth.userId),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, auth, previousOrder) =>
              previousOrder!..setParams(auth.token, auth.userId!),
        ),
        ChangeNotifierProvider<Cart>(create: (context) => Cart()),
      ],
      child: Consumer<Auth>(builder: (context, authData, child) {
        print("Login is ${authData.isAuth}");
        return MaterialApp(
          title: "Online do'kon",
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: authData.isAuth
              ? const HomeScreen()
              : FutureBuilder(
                  future: authData.autoLogIn(),
                  builder: (ctx, autoLoginData) {
                    if (autoLoginData.connectionState ==
                        ConnectionState.waiting) {
                      return const SplashScreen();
                    } else {
                      return const AuthScreen();
                    }
                  }),
          routes: {
            AuthScreen.routeName: (context) => const AuthScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            ManageProductsScreen.routeName: (context) =>
                const ManageProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        );
      }),
    );
  }
}
