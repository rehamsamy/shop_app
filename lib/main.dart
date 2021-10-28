import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Orders.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import './screens/auth_screen.dart';
import './providers/product.dart';

import 'screens/product_overview_screen.dart';

void main() {
 // Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider,Products>(create: (_)=>
            Products()
            ,update: (_,auth,prods)=>prods..getData(auth.auth_token, auth.userId, prods.items)),
        ChangeNotifierProvider.value(value: Product()),
      //  ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: Cart()),

        ChangeNotifierProxyProvider<AuthProvider,Orders>(create: (_)=>Orders(),
            update: (_,auth,ords)=>ords..getData(auth.auth_token, auth.userId, ords.ordersList))
      ],

      child: Consumer<AuthProvider>(
        builder: (ctx,auth,_)=>
         MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'
          ),
          home:
          // FutureBuilder<void>(future:auth.isAuth(),
          //     builder: (ctx,snap)=>EditProductScreen())
          auth.tryAutoLogin() ==true?ProductOverviewScreen():AuthScreen()
          // FutureBuilder(
          //   future: auth.tryAutoLogin(),
          //     builder: (ctx,snap) =>snap.connectionState==ConnectionState.waiting?ProductOverviewScreen():AuthScreen())
             ,
          routes: {
            AuthScreen.AUTH_ROUTE:(_)=>AuthScreen(),
            OrderScreen.Order_Screen_Route:(_)=>OrderScreen(),
            UserProductsScreen.User_Product_Screen_Route:(_)=>UserProductsScreen(),
            EditProductScreen.Edit_Route:(_)=>EditProductScreen(),
            CartScreen.Cart_Route:(_)=>CartScreen(),
            ProductDetailScreen.Product_Detail:(_)=>ProductDetailScreen()
          },
        ),
      ),
    );
  }
}


