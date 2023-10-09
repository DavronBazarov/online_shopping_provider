import 'package:flutter/material.dart';
import 'package:online_shopping_provider/screens/orders_screen.dart';
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
                        "\$$totalPrice".substring(0, 10),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart, totalPrice: totalPrice),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
    required this.totalPrice,
  });

  final Cart cart;
  final double totalPrice;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.items.isEmpty || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addToOrders(
                  widget.cart.items.values.toList(), widget.totalPrice);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearItems();
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Text("BUYURTMA QILISH"),
    );
  }
}
