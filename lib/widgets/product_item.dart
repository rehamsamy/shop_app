import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/widgets/badge.dart';


class ProductItem extends StatefulWidget {
  Product product;
  ProductItem(this.product);
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    // var product=Provider.of<Product>(context);
    var auth=Provider.of<AuthProvider>(context);
    int quantity=0;
    print('proddd valueeee ${widget.product}');
    IconData icon=Icons.favorite_border;
    print(widget.product.imageUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(ProductDetailScreen.Product_Detail,arguments: widget.product);
            print(widget.product.id);
          },
          child: Hero(
            tag: widget.product.id,
            child: FadeInImage(placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(widget.product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(icon:Icon(widget.product.isFav==false?icon:Icons.favorite),color: Theme.of(context).accentColor,
            onPressed: ()async{

            if(widget.product.isFav==true){
              toogleFav(false, Icons.favorite, auth);
            }else{
              toogleFav(true, Icons.favorite_border, auth);
            }


            },),
          trailing: IconButton(icon:Icon(Icons.shopping_cart,),onPressed: (){
            print('carttttttt ${widget.product.title}');
            Provider.of<Cart>(context,listen: false).addCartItem(widget.product.id, double.parse(widget.product.price), widget.product.title);

            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('added to cart'),duration: Duration(seconds: 3),
                  action:SnackBarAction(
                    label: 'UNDO',
                    onPressed: (){},
                  ) ,)
            );
          }),
          title: Text(widget.product.title,textAlign: TextAlign.center,),

        ),

      ) ,
    );
  }

  void toogleFav(bool isFav,IconData icon,var auth)async{

      Map<String,Object> map={
        'id': auth.userId.toString(),
        'title': widget.product.title,
        'description':widget.product.description,
        'price': widget.product.price,
        'imageurl': widget.product.imageUrl,
        'isFav':isFav
      };
      await  Provider.of<Products>(context,listen: false).toggleFav(widget.product.id,map).then((value) =>
          setState(() {
            icon=icon;
          })
      );



  }
}

