import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrderScreen extends StatelessWidget {
  static String Order_Screen_Route='r4';
  const OrderScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context,listen: false).fetchOrdersData(),
          builder: (ctx,snap){
        if(snap.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }else{
          if(snap.error !=null){
            print(snap.error.toString());
            return Center(child: Text(snap.error.toString()),);

          }else{
            return Consumer<Orders>(
              builder: (ctx,ord,child)=>
               ListView.builder(
                itemCount: ord.ordersList.length,
                  itemBuilder: (ctx,index){
                  return
                    //Center(child: Text('ord.ordersList[index].id'));
                    OrderItemWidget(Provider.of<Orders>(context).ordersList[index]);
              }),
            );
          }
        }
      }),
    );
  }
}
