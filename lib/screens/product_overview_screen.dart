import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_item.dart';

import 'cart_screen.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key key}) : super(key: key);

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}
enum dataList{AllProducts,OnlyFavorites}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {

  List<Product> favProds=[];
  List<Product> list=[];
  bool _isLoading=false;
  var _filtered=dataList.AllProducts;
  int flag=0;
 // @override
  // void initState() {
  //   setState(() {
  //     _isLoading=true;
  //   });
  //   Provider.of<Products>(context,listen: false).fetchProducts().then((value) {
  //     setState(() {
  //       _isLoading=false;
  //       // list.clear();
  //     });
  //   }
  //   );
  //   super.initState();
  //
  //
  // }



  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        centerTitle: true,
        actions: [
         PopupMenuButton(
           icon: Icon(Icons.more_vert),
           onSelected: (value){
             print(value);
             if(value==0){
               setState(() {
                 flag=0;
               });
             }else{
               setState(() {
                 flag=1;
               });
             }
             print(flag);
           },
           itemBuilder: (ctx)=>[PopupMenuItem(
             value: 0,
             child: Text(_filtered==dataList.AllProducts?'All Products':'Only Favorites'),),
             PopupMenuItem(
               value: 1,
               child: Text('Only Favorites'),)],
             ),
          Consumer<Cart>(child: IconButton(icon:Icon(Icons.shopping_cart,),
            onPressed: ()=>Navigator.of(context).pushNamed(CartScreen.Cart_Route),),
          builder: (_,cart,child)=>Badge(child, Provider.of<Cart>(context,listen: false).itemCount.toString(), Colors.red),),
         
        ],
      ),
      body:
          FutureBuilder(
            future: Provider.of<Products>(context,listen: false).fetchProducts(),
            builder: (_,snap){
            //  print(snap.data.toString());
              if(snap.connectionState==ConnectionState.waiting) {
                print('step1');
                return Center(child: CircularProgressIndicator());
              }
                // else if(snap.error){
                //   return Center(child: Text('error occured'),);
                // }
                else {
                print('step2');
                  return Consumer<Products>(builder: (ctx,prod,ch){
                      favProds=prod.products.where((element) => element.isFav==true).toList() ;
                    if(prod.items.length<=0){
                      return Center(child: Text('empty products'),);
                    }else{
                      print('ffff ${prod.items.length}');

                      if(flag==0){
                       // buildProductsFavGrid(ctx, prod.items);
                        return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 3 / 2,
                                crossAxisCount: 2),
                            padding: EdgeInsets.all(10),
                            itemCount: prod.items.length,
                            itemBuilder: (ctx, index) => ProductItem(prod.items[index]));
                      }
                      else{
                        //buildProductsFavGrid(ctx,favProds);
                        return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 3 / 2,
                                crossAxisCount: 2),
                            padding: EdgeInsets.all(10),
                            itemCount: favProds.length,
                            itemBuilder: (ctx, index) => ProductItem(favProds[index]));
                      }
                    }
                  });
              }
            }
          )
      ,
      drawer: AppDrawer(),
    );
  }

  Widget buildProductsFavGrid(BuildContext context, List<Product> prods) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2,
            crossAxisCount: 2),
        padding: EdgeInsets.all(10),
        itemCount: prods.length,
        itemBuilder: (context, index) => ProductItem(prods[index]));
  }
}
