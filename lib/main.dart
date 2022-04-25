// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import './providers/products.dart';

void main() => runApp(const MyApp());

// 2022.03.20
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(
            Provider.of<Auth>(ctx, listen: false).token as String,
            Provider.of<Auth>(ctx, listen: false).userId as String,
          ),
          update: (ctx, auth, previousProducts) => Products(
            auth.token as String,
            auth.userId as String,
          ),
        ),
        // ChangeNotifierProxyProvider<Auth, Products>(
        //   builder: (ctx, auth, previousProducts) =>
        //       Products(auth.token as String),
        // ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(
            Provider.of<Auth>(ctx, listen: false).token as String,
            Provider.of<Auth>(ctx, listen: false).userId as String,
          ),
          update: (ctx, auth, previousProducts) => Orders(
            auth.token as String,
            auth.userId as String,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routedName: (ctx) => ProductDetailScreen(),
            CartScreen.routedName: (ctx) => const CartScreen(),
            OrdersScreen.routedName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routedName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
