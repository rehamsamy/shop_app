import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatefulWidget {
Product prod;

UserProductItem(this.prod);

  @override
  _UserProductItemState createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  @override
  Widget build(BuildContext context) {
    Product product=widget.prod;
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 15,
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          leading: CircleAvatar(backgroundImage:NetworkImage(product.imageUrl),),
          title: Text(product.title),
          trailing: Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.Edit_Route,arguments: product);
                }, icon: Icon(Icons.edit)),
                SizedBox(width: 4,),
                IconButton(onPressed: (){
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Are you sure delete this product'),
                    action: SnackBarAction(onPressed: (){
                      Provider.of<Products>(context,listen: false).deleteProduct(product.id);
                    },label: 'YES',),
                  ));
                }, icon: Icon(Icons.delete),color: Colors.red,),
              ],
            ),
          )
        ),
      ),
    );
  }
}
