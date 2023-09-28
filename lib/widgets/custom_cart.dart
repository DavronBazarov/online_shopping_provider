import 'package:flutter/material.dart';
import 'package:online_shopping_provider/screens/cart_screen.dart';

class CustomCart extends StatelessWidget {
  Widget child;
  String number;

  CustomCart({
    super.key,
    required this.number,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, CartScreen.routeName);
        },
        child: Badge(
          label: Text(number),
          child: child,
        ),
      ),
    );
  }
}
