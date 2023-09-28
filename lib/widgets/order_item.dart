import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_shopping_provider/models/cart_item.dart';


class OrderItem extends StatefulWidget {
  final double totalPrice;
  final DateTime date;
  final List<CartItem> products;

  const OrderItem({
    super.key,
    required this.totalPrice,
    required this.date,
    required this.products,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expandItem = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.totalPrice}"),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.date),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expandItem = !_expandItem;
                });
              },
              icon: Icon(_expandItem ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_expandItem)
            Container(
              padding: const EdgeInsets.all(5),
              height: min(widget.products.length *20 + 40, 100),
              child: ListView.builder(
                itemExtent: 40,
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  return ListTile(
                    title: Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      "${product.quantity} x \$${product.price}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
