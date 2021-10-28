import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Orders.dart';
import 'package:shop_app/providers/cart.dart';

class CartScreen extends StatelessWidget {
  static String Cart_Route='cart_screen';


  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
  Cart cart=  Provider.of<Cart>(context);
  var carts=cart.cartsList.values.toList();
  print('ssssss   ${cart.cartsList.length}  ');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            elevation: 15,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Total:',style: TextStyle(color: Colors.black87,fontSize: 20)),
                  Spacer(),
                  Chip(label: Text('\$${cart.getTotal.toStringAsFixed(2)}'
                    ,style: TextStyle(color: Colors.white),),
                    backgroundColor: Theme.of(context).primaryColor,),
                  OrderButton(cart)

   // ${cart.getTotal.toStringAsFixed(2)
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
                itemCount: cart.cartsList.length,itemBuilder: (_,index){
              return
                CartItemWidget(
                 carts[index].id,carts[index].title,carts[index].price,carts[index].quantity
             );
            }),
          )
        ],
      ),
    );
  }
}

class CartItemWidget  extends StatelessWidget{
  String id;
  String title;
  String  price;
  int  quantity;


  CartItemWidget(this.id, this.title, this.price,
      this.quantity); //CartItemWidget( this.id,this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
   return Dismissible(key: ValueKey(id),
   background: Container(
     margin: EdgeInsets.all(15),
     color: Theme.of(context).primaryColor,
     child: Text('Delete'),
   ),
       direction: DismissDirection.endToStart,
       confirmDismiss: (dir){
     showDialog(context: context, builder: (ctx)=>
         AlertDialog(title:Text('Delete Item'),content: Text('Are you Sure Delete this Item'),
         actions: [
           FlatButton(onPressed: (){
             Navigator.of(ctx).pop();
             Provider.of<Cart>(context,listen: false).removeItem(id);
           }, child: Text('OK'))
         ],)
     );
       },
       onDismissed: (dir){
     print('disssssss');
         Provider.of<Cart>(context,listen: false).removeItem(id);
       },
       child:  Card(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(10),
         ),
         elevation: 15,
         color: Colors.white,
         child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: ListTile(
             leading: CircleAvatar(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: FittedBox(child: Text('\$${price}',style: TextStyle(color: Colors.white),)),
               ),
               backgroundColor: Theme.of(context).primaryColor,
             ),
             trailing: Text('${quantity} x'),
             title: Text(title),
             subtitle: Text('Total \$${price* quantity}'),
           ),
         ),
       )
   );
  }
}

class OrderButton extends StatefulWidget {
  Cart cart;

  OrderButton(this.cart);

  @override
  State<StatefulWidget> createState() {
  return OrderButtonState();
  }
}

  class OrderButtonState extends State<OrderButton>{
  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
   return _isLoading?CircularProgressIndicator():
   FlatButton(
       onPressed:
     widget.cart.cartsList.length<0||_isLoading?null:()async{
     setState(() {
       _isLoading=true;
     });
   await  Provider.of<Orders>(context,listen: false).addOrder(widget.cart.cartsList.values.toList(), widget.cart.getTotal)
     .then((value) {
     setState(() {
       _isLoading=false;
     });
     widget.cart.clearAll();
   });


   }, child: Text('Order Now',style: TextStyle(color: Theme.of(context).primaryColor,
   fontSize: 15),));
  }

  }


