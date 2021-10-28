import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart 'as http;
import 'package:shop_app/providers/auth_provider.dart';

class Product with ChangeNotifier{
 String id;
 String title;
 String  description;
 String  price;
 String  imageUrl;
 bool isFav=false;
 String token;

 Product({@required this.id,@required this.title,@required this.description,@required this.price,@required this.imageUrl,this.isFav});

 Future<bool>  isAuth()async{
   return token !=null;
 }

 void setFav(bool fav){
   isFav=fav;
   notifyListeners();
 }

 factory Product.fromJson(String idd,Map<String,Object> map){
  return Product(
    id:idd,
 title: map['title'],
  description: map['description'],
  price: map['price'],
  imageUrl: map['imageurl'],
  isFav: map['isFav']);
}




 Future editProduct(Map<String,Object> map)async{
   print('111');
   String url='https://shop-93ba9-default-rtdb.firebaseio.com/products.json?auth=${AuthProvider.token}';
   var response=await http.patch(url,body: json.encode(map));
   print('222');
   print(response.body);
   notifyListeners();


 }

// Future toggleFavorites(String auth_token,String auth_id) async{
//    var oldFav=isFav;
//    isFav=!isFav;
//    print('cccccccc ${id}');
//    String url='https://shop-93ba9-default-rtdb.firebaseio.com/userFav/${auth_id}/${id}.json?auth=${auth_token}';
//    var res=await http.post(url,body: json.encode(isFav));
//    setFav(oldFav);
//    print(res.body);
//    notifyListeners();
// }


}