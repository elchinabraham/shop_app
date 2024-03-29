import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // ...
              Navigator.of(context).pushNamed(EditProductScreen.routedName);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => RefreshIndicator(
          onRefresh: () {
            return _refreshProducts(context);
          },
          child: Consumer<Products>(
            builder: (ctx, productsData, _) => Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    UserProductItem(
                      productsData.items[i].id,
                      productsData.items[i].title,
                      productsData.items[i].imageUrl,
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
