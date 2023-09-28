import 'package:flutter/material.dart';
import '../provider/cart.dart';
import '../provider/orders.dart';
import '../widgets/cart_list_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final totalPrice = Provider.of<Cart>(context).totalPrices;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sizning Savatchangiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Umumiy:",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        "\$$totalPrice",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      child: const Text("BUYURTMA QILISH"),
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addToOrders(
                            cart.items.values.toList(), totalPrice);
                        cart.clearItems();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) {
                  final cartItem = cart.items.values.toList()[i];
                  return CartListItem(
                    productId: cart.items.keys.toList()[i],
                    imageUrl: cartItem.image,
                    title: cartItem.title,
                    price: cartItem.price,
                    quantity: cartItem.quantity,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
