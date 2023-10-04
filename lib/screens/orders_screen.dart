import 'package:flutter/material.dart';
import '../provider/orders.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const routeName = '/orders_screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future ordersFuture;

  Future _getOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).getOrdersFomFirebase();
  }

  @override
  void initState() {
    ordersFuture = _getOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Buyurtmalar"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: ordersFuture,
        builder: (context, snapshotData) {
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshotData.error == null) {
            return Consumer<Orders>(
              builder: (context, orders, child) => orders.items.isEmpty
                  ? const Center(child: Text("Buyurtmalar mavjud emas"))
                  : ListView.builder(
                      itemCount: orders.items.length,
                      itemBuilder: (context, index) {
                        final order = orders.items[index];
                        return OrderItem(
                          totalPrice: order.totalPrice,
                          date: order.date,
                          products: order.products,
                        );
                      },
                    ),
            );
          } else {
            return const Center(child: Text("Xatolik sodir bo'ldi!"));
          }
        },
      ),
    );
  }
}
