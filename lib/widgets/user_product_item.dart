import 'package:flutter/material.dart';
import 'package:online_shopping_provider/models/product.dart';
import 'package:online_shopping_provider/provider/product.dart';
import 'package:online_shopping_provider/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({super.key});

  void _notifyUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Ishonchingiz komilmi?"),
            content: const Text('Bu mahsulot o\'chmoqda'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Bekor qilish" , style: TextStyle(color: Colors.black54),),
              ),
              ElevatedButton(
                onPressed: () {
                  removeItem();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('O\'chirish'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ModelProduct>(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName, arguments: product.id);
              },
              icon:  Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () {
                _notifyUserAboutDelete(context, () {
                  Provider.of<Products>(context, listen: false).deleteProduct(product.id);
                });
              },
              icon:  Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
