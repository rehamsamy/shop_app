import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart 'as http;

class Products with ChangeNotifier{
 List<Product> products=[];
 String userId;
 String token;
 List<Product> _items=[];
 List<Product> _userProducts=[];


 getData(String tokenn,String id,List<Product> prods){
   print('idddd ${prods.length}');
   token=tokenn;
   userId=id;
   _items=prods;
   notifyListeners();
 }


 List<Product> get userProducts => _userProducts;

  Future fetchProducts()async{
    String url='https://shop-93ba9-default-rtdb.firebaseio.com/products.json?auth=$token';
    _items.clear();
    products.clear();

    try{
      var res= await http.get(url) ;
      var x=json.decode(res.body) as Map<String,dynamic>;
      print(res.statusCode);

      if(res.statusCode==200){
        x.forEach((key, value) {
          products.add(Product.fromJson(key,value));
            //_items.add(Product.fromJson(key,value));
        });
        _items=products;
        print('22222 ${_items.length}');
        notifyListeners();
      }else{
        print('fail');
      }
    }catch(err){
      print(err);
    }
}

 List<Product> get items => _items;


Product findById(String id){
  Product product= products.firstWhere((element) => id==element.id);
  return product;
}


Future fetchProductsByUserId(String userId)async{
  _userProducts.clear();
  String filter='orderBy="id"&equalTo="$userId"';
  String url='https://shop-93ba9-default-rtdb.firebaseio.com/products.json?auth=${AuthProvider.token}&$filter';

  var res=await http.get(url);
  Map<String,dynamic> map=json.decode(res.body) as Map<String,dynamic>;
if(res.statusCode==200){
  map.forEach((key, value) {
    _userProducts.add(Product.fromJson(key,value));
    print('my mmmmmmm ${_userProducts.length}');
  });

  notifyListeners();
}else{
  print('fail');
}

}

Future editProduct(String id,Map<String ,Object> map)async{
 int index= products.indexWhere((element) => id==element.id);

  String url='https://shop-93ba9-default-rtdb.firebaseio.com/products/$id.json?auth=${AuthProvider.token}';


  var response=await http.patch(url,body: json.encode(map));
  _userProducts[index]=Product.fromJson(id,map) as Product;

 print(response.body) ;
 notifyListeners();
}

 Future createProduct(Map<String,dynamic> map)async{
   print('111');
   String url='https://shop-93ba9-default-rtdb.firebaseio.com/products.json?auth=${AuthProvider.token}';
   var response=await http.post(url,body: json.encode(map));
   print('222');
   print(response.body);
   notifyListeners();
 }
 
 Future deleteProduct(String id)async{
   String url='https://shop-93ba9-default-rtdb.firebaseio.com/products/$id.json?auth=${AuthProvider.token}';
   var res= await http.delete(url);
   int index=userProducts.indexWhere((element) => id==element.id);
   _items.removeAt(index);
   userProducts.removeAt(index);
   print(res.body);
   notifyListeners();
 }


 Future toggleFav(String id,Map<String,Object> map)async{
  int index=products.indexWhere((element) => element.id==id);
  String url='https://shop-93ba9-default-rtdb.firebaseio.com/products/$id.json?auth=${AuthProvider.token}';


  var response=await http.patch(url,body: json.encode(map));
  products[index]=Product.fromJson(id,map) as Product;

  print(response.body) ;
  notifyListeners();
 }


}