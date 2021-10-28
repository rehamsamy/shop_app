import 'package:flutter/cupertino.dart';

class CartItem{
  String id;
  String title;
  String  price;
  int  quantity;

  CartItem({@ required this.id,@ required this.title,@ required this.price, @ required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String,CartItem> _cartsList={};
  int quantity=0;
  Map<String, CartItem> get cartsList => _cartsList;

  int get itemCount{
    return _cartsList.length;
  }

  double get getTotal{


    double _total = 0.0;
    _cartsList.forEach((key, cart) {
      _total+=cart.quantity * double.parse(cart.price);
    });
     return _total;
  }


 Future  addCartItem(String id,double pricee,String titlee){
   if(_cartsList.containsKey(id)){
   _cartsList.update(id, (oldCart) =>
       CartItem(id: oldCart.id,
           title: oldCart.title,
           price: oldCart.price,
           quantity: oldCart.quantity+1)
   );
   print('addeddddd');
   }else{
     _cartsList.putIfAbsent(id, () =>
         CartItem(id: DateTime.now().toString(), title: titlee, price: pricee.toString(), quantity: 1)
     );
    // print('not addeddddd ${_cartsList['id'].title}');
   }
   notifyListeners();
  }

  void removeItem(String id){
    _cartsList.remove(id);
    print('removeee');
    notifyListeners();
  }

  void removeSingleItem(String id){
    if(_cartsList[id].quantity>1){
    _cartsList.update(id, (oldCart) =>
    CartItem(id: oldCart.id,
        title: oldCart.title,
        price: oldCart.price,
        quantity: oldCart.quantity-1));
    }else{
      _cartsList.remove(id);
    }
  notifyListeners();
  }

  void clearAll(){
    _cartsList.clear();
    notifyListeners();
  }

}