import 'package:flutter/material.dart';
import 'package:online_shopping_provider/provider/auth.dart';
import 'package:online_shopping_provider/screens/home_screen.dart';
import 'package:online_shopping_provider/screens/manage_products_screen.dart';
import 'package:online_shopping_provider/screens/orders_screen.dart';
import 'package:provider/provider.dart';
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text("Drawer"),
          ),
           ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Magazin"),
            onTap: ()=> Navigator.pushReplacementNamed(context, HomeScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Buyurtmalar"),
            onTap: ()=> Navigator.pushReplacementNamed(context, OrdersScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Mahsulotlarni Boshqarish"),
            onTap: ()=> Navigator.pushReplacementNamed(context, ManageProductsScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Chiqish"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
