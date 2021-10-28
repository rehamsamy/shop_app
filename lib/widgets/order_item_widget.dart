import 'package:flutter/material.dart';
import 'package:shop_app/providers/Orders.dart';

class OrderItemWidget extends StatelessWidget {
OrderItem item;


OrderItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(title: Text(' \$ ${item.totalAmount.toString()} ',),
    subtitle:Text(' \$ ${item.dateTime.toString()} ',) ,
    children: [
     Column(
       children: item.orders.map((cart) =>
           Container(
             padding: EdgeInsets.all(10),
             margin: EdgeInsets.all(10),
             width: MediaQuery.of(context).size.width*0.5,
             decoration: BoxDecoration(
               color: Colors.yellow,
               borderRadius: BorderRadius.circular(15),
             ),
             child: Column(children:[
               Text(cart.title),
               Divider(color: Colors.green,),
               Text('Price = \$${cart.price}'),
               Divider(color: Colors.green,),
               Text('quantity = ${cart.quantity.toString()} x')
             ],),
           )
       ).toList()
     )
    ],);
  }
}
