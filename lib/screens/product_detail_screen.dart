

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatefulWidget {
  static String Product_Detail='/product_detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Product product=ModalRoute.of(context).settings.arguments as Product;
  //  Product product=Provider.of<Products>(context).findById(id);
    return Scaffold(
     // appBar: AppBar(title: Text('Product Detail Screen'),),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
           pinned: true,
           flexibleSpace:FlexibleSpaceBar(
             title:Text(product.title,textAlign: TextAlign.center,) ,
             background: Hero(tag:product.id,child:Image.network(product.imageUrl,fit: BoxFit.fill,),)
           ) ,
          ),
         SliverList(delegate: SliverChildListDelegate(
           [
             SizedBox(height: 15),
             Text('\$ ${product.price}',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey),),
             SizedBox(height: 15),
             Container(
               width: double.infinity,
               padding: EdgeInsets.all(10),
               child: Text(product.description,textAlign: TextAlign.center,),
             ),


           ]
         ))
        ],
      ),
    );
  }
}
