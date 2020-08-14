import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/product_form_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview.dart';
import 'package:google_fonts/google_fonts.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';
import './helpers/custom_fade_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (_) => Products(null, null, []),
              update: (ctx, auth, previousProducts) => Products(
                  auth.token,
                  auth.userId,
                  previousProducts == null ? [] : previousProducts.items)),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (_) => Orders(null, null, []),
              update: (ctx, auth, previousorders) => Orders(
                  auth.token,
                  auth.userId,
                  previousorders == null ? [] : previousorders.orders)),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.pink,
                accentColor: Colors.amberAccent,
                fontFamily: GoogleFonts.lato().fontFamily,
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomFadeTransitionBuilder(),
                  TargetPlatform.iOS: CustomFadeTransitionBuilder()
                })),
            
            home: auth.isAuth ? ProductsOverview() : FutureBuilder(future: auth.tryAutoLogin(),builder: (ctx,authResultSnap) => authResultSnap.connectionState == ConnectionState.waiting? SplashScreen(): AuthScreen()) ,
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.route_name: (ctx) => OrdersScreen(),
              UserProductsScreen.route_name: (ctx) => UserProductsScreen(),
              ProductFormScreen.route_name: (ctx) => ProductFormScreen()
            },
          ),
        ));
  }
}
