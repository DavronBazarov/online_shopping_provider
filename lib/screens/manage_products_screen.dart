import 'package:flutter/material.dart';
import 'package:online_shopping_provider/provider/product.dart';
import 'package:online_shopping_provider/screens/edit_product_screen.dart';
import 'package:online_shopping_provider/widgets/app_drawer.dart';
import 'package:online_shopping_provider/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  static const routeName = '/manage-products';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getDateFromFirebase(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productProvider = Provider.of<Products>(context, listen: false);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mahsulotlarni Boshqarish"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (context, snapshotData) {
          if(snapshotData.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshotData.connectionState == ConnectionState.done){
            return RefreshIndicator(
              onRefresh: () => _refreshProduct(context),
              child: Consumer<Products>(
                builder: (c, productProvider, _) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: productProvider.list.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.list[index];
                      return ChangeNotifierProvider.value(
                        value: product,
                        child: const UserProductItem(),
                      );
                    },
                  );
                }
              ),
            );
          } else{
            return const Center(child: Text("Xatolik sodir bo'ldi..."));
          }
        },
      ),
    );
  }
}
