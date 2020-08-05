import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './screens/product_overview.dart';
import 'package:google_fonts/google_fonts.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
          child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.amberAccent,
            fontFamily: GoogleFonts.lato().fontFamily),
        home: ProductsOverview(),
        routes: {
          ProductDetailScreen.routeName : (ctx) => ProductDetailScreen()
        },
      ),
    );
  }
}
