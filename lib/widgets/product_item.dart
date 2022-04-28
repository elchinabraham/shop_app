import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routedName,
            arguments: product.id,
          );
        },
        child: GridTile(
          child: FadeInImage(
            placeholder:
                const AssetImage('assets/images/product-placeholder.png'),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                onPressed: () {
                  product.toggleFavoiteStatus(
                      authData.token as String, authData.userId);
                },
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Added item to cart!'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
