import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import './screens/product_detail_screen.dart';
import './screens/product_overview.dart';
import 'package:google_fonts/google_fonts.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.amberAccent,
            fontFamily: GoogleFonts.lato().fontFamily),
        home: ProductsOverview(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.route_name: (ctx) => OrdersScreen()
        },
      ),
    );
  }
}
