import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static String User_Product_Screen_Route='r2';

  Future fetchMyProducts(BuildContext context)async{
    AuthProvider auth=Provider.of<AuthProvider>(context,listen: false);
    await Provider.of<Products>(context,listen: false).fetchProductsByUserId(auth.userId).then((value) =>
      //print('ssss');
        print(value)
    );
  }

  @override
  Widget build(BuildContext context) {
  //  Provider.of<Products>(context,listen: false).userProducts.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(onPressed: ()=>Navigator.of(context).pushNamed(EditProductScreen.Edit_Route)
              , icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: fetchMyProducts(context),
        builder: (_,snap)=>snap.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator()):
         RefreshIndicator( onRefresh:()=> fetchMyProducts(context),child: Consumer<Products>(
           builder: (ctx,prod,_)=>prod.userProducts.length<=0?Center(child: Text('empty products'),)
               :ListView.builder(
             itemCount: prod.userProducts.length,
               itemBuilder: (ctx,indx)=>prod.userProducts.length==0?Center(child:Text('empty')):
               UserProductItem(prod.userProducts[indx])
           ),
         ))
      ),
      drawer: AppDrawer(),
    );
  }
}
