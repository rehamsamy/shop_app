import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: Text('Hello World'),
          automaticallyImplyLeading: false,),
          Divider(color: Theme.of(context).primaryColor,),
          ListTile(
            title: Text('Shop'),
            leading: Icon(Icons.shop,color: Theme.of(context).primaryColor,),
            onTap: ()=>Navigator.pushReplacementNamed(context, '/'),
          ),
          Divider(color: Theme.of(context).primaryColor,),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.payment,color: Theme.of(context).primaryColor,),
            onTap: ()=> Navigator.pushReplacementNamed(context, OrderScreen.Order_Screen_Route),
          ),
          Divider(color: Theme.of(context).primaryColor,),
          ListTile(
            title: Text('Manage App'),
            leading: Icon(Icons.edit,color: Theme.of(context).primaryColor,),
            onTap: ()=>Navigator.pushReplacementNamed(context, UserProductsScreen.User_Product_Screen_Route),
          ),
          Divider(color: Theme.of(context).primaryColor,),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.logout,color: Theme.of(context).primaryColor,),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context,  '/');
              Provider.of<AuthProvider>(context,listen: false).logot();
            }
          ),
        ],
      ),
    );
  }
}
