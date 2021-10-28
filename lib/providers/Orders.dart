import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart 'as http;
import 'cart.dart';

import 'auth_provider.dart';


class OrderItem{
  String id;
  double totalAmount;
  List<CartItem> orders;
  DateTime  dateTime;

  OrderItem( {@required this.id,@required this.totalAmount,@required this.orders, @required this.dateTime});
  factory OrderItem.fromjson(Map<String,dynamic> map){
    return OrderItem(id: map['createdId'],
        totalAmount: map['totalAmount'],
      dateTime: map['dateTime'],
      orders:(map['orders'] as List<CartItem>).map((cartItem) =>
          CartItem(id: map['id'], title: map['title'], price: map['price'], quantity: map['quantity'])
      ).toList() );
  }
}

class Orders with ChangeNotifier{
List<OrderItem> _ordersList=[];
String token;
String userId;


getData(String tokenn,String id,List<OrderItem> prods){
  print('idddd $id');
  token=tokenn;
  userId=id;
  _ordersList=prods;
  notifyListeners();
}

List<OrderItem> get ordersList => _ordersList;

Future<void> fetchOrdersData()async{
  _ordersList=[];
  List<OrderItem> ordered=[];
  String url='https://shop-93ba9-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
  try{
    var res= await http.get(url);

    print(res.body.toString());
    Map<String,dynamic> list=json.decode(res.body) as Map<String,dynamic> ;
   list.forEach((key, order) {
     ordered.add(OrderItem(id: order['id'],
                         totalAmount: order['totalAmount'],
                          dateTime: DateTime.parse(order['dateTime']),
                          orders: (order['orders'] as List<dynamic>).map((cart) =>
                              CartItem(id: cart['id'], title: cart['title'], price: cart['price'], quantity: cart['quantity'])
                          ).toList() ));
   });
   _ordersList=ordered;

  }catch(err){
    print(err);
throw err;
  }

notifyListeners();

}


Future addOrder(List<CartItem> carts,double total_amount)async{
  print(carts[0].title);
  Map<String,dynamic> map={
    'createdId':userId,
     'totalAmount':total_amount,
      'dateTime' :DateTime.now().toIso8601String(),
      'orders':carts.map((cart) => {
        'id':cart.id,
        'title':cart.title,
        'quantity':cart.quantity,
        'price':cart.price.toString()
      }).toList()};

  print('111');
  String url='https://shop-93ba9-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
  var response=await http.post(url,body: json.encode(map));
  print('222');
  print(response.body);
  notifyListeners();
}

}