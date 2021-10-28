import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class EditProductScreen extends StatefulWidget {
  static String Edit_Route='edit_route';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _titleControll = TextEditingController();
  var _descControll = TextEditingController();
  var _priceControll = TextEditingController();
  var _imageControll = TextEditingController();
  var _titleFocus = FocusNode();
  var _descFocus= FocusNode();
  var _priceFocus = FocusNode();
  var _imageFocus = FocusNode();
  bool _isLoading=false;
  Product product;
  var _formKey = GlobalKey<FormState>();
  String imageUrl;
  String defaultUrl;
  Map<String, Object> _productData ;


 String  newTitle;
  String  newDescription;
  String newPrice;
 String  newImageurl;




  getProductData(BuildContext context){
     product=ModalRoute.of(context).settings.arguments as Product;
     print('vvvvvv ${product.title}');
      _titleControll = TextEditingController(text:product.title);
      _descControll = TextEditingController(text:product.description);
    _priceControll = TextEditingController(text:product.price);
      _imageControll = TextEditingController(text:product.imageUrl);
    // _titleControll.text=product.title;
    // _descControll.text=product.description;
    // _priceControll.text=product.price;
    // _imageControll.text=product.imageUrl;
    imageUrl=product.imageUrl;
    //print(_titleControll.text);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product=ModalRoute.of(context).settings.arguments as Product;
  }

  @override
  Widget build(BuildContext context) {
   if(ModalRoute.of(context).settings.arguments !=null){
     getProductData(context);
   }

    return Provider<Product>(
      create: (_)=>Product(),
      builder: (context,_){
    return
      Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          centerTitle: true,
          actions: [
            IconButton(onPressed:()=> _saveNewProduct(context), icon: Icon(Icons.camera_alt))
          ],
        ),
        body: _isLoading?Center(child: CircularProgressIndicator(),)
            :Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleControll,
                    decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter Title:'
                    ),
                   // focusNode: _titleFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_){
                      FocusScope.of(context).requestFocus(_priceFocus);
                    },

                    validator: (val) {
                      if (val == null || val == '') {
                        return 'Please enter Title';
                      }
                    },
                    onSaved: (val) {
                      newTitle=val;
                    },
                  ),
                  TextFormField(
                    controller: _priceControll,
                   // initialValue: product.price,
                    focusNode:_priceFocus,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_){
                      FocusScope.of(context).requestFocus(_descFocus);
                    },
                    decoration: InputDecoration(
                        labelText: 'Price',
                        hintText: 'Enter Price:'
                    ),
                    validator: (val) {
                      if (val == null || val == '') {
                        return 'Please enter Price';
                      }
                      if (double.tryParse(val)==null){
                        return 'please enter valid price';
                      }
                    },
                    onSaved: (val) {
                     newPrice=val.toString();

                    },
                  ),
                  TextFormField(
                    controller: _descControll,
                   // initialValue: product.description,
                    textInputAction: TextInputAction.next,
                    focusNode: _descFocus,
                    keyboardType: TextInputType.multiline,
                    onFieldSubmitted: (_){
                      FocusScope.of(context).requestFocus(_imageFocus);
                    },

                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter Description:'
                    ),
                    validator: (val) {
                      if (val == null || val == '') {
                        return 'Please enter Description';
                      }
                    },
                    onSaved: (val) {
                    newDescription=val;
                    },
                  ),

                    SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(flex: 1, child: Container(
                        margin: EdgeInsets.only(right: 7),
                        width: 100,
                          height: 100,
                          child: getImageUrl(),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1,color: Theme.of(context).accentColor)
                        ),
                      )),
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          controller: _imageControll,
                          //initialValue: product.imageUrl,
                          decoration: InputDecoration(
                              labelText: 'ImageUrl',
                              hintText: 'Enter ImageUrl:'
                          ),
                          validator: (val) {
                            if (val == null || val == '') {
                              return 'Please enter ImageUrl';
                            }
                            if(!val.startsWith('http')&&!val.startsWith('https')){
                              return 'please enter image valid';
                            }if(!val.endsWith('.jpeg')&&!val.endsWith('.png')&&!val.endsWith('.jpg')){
                              return 'please enter image valid';
                            }
                          },
                          onSaved: (val) {
                            print('val = $val');
                            setState(() {
                              defaultUrl=val;
                             newImageurl=val;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );}
    );
  }

  _saveNewProduct(BuildContext context) async {
  var auth=  Provider.of<AuthProvider>(context,listen: false);
    if (_formKey.currentState.validate()) {

      _formKey.currentState.save();
     // _productData['id']=auth.userId;

      _productData={
        'id': auth.userId.toString(),
        'title': newTitle,
        'description':newDescription,
        'price': newPrice,
        'imageurl': newImageurl,
        'isFav':false
      };

      print('ccccccccccc ${_productData}  ${auth.userId}');

      if(imageUrl==null) {
        print('steppp 1');
        await Provider.of<Products>(context, listen: false).createProduct(
            _productData);
      }else{
        print('steppp 2');
        try{
          await Provider.of<Products>(context, listen: false).editProduct(product.id,_productData);
        }catch(err){
          showDialog(context: context, builder: (ctx)=>AlertDialog(
            content: Text('errror occured'),
            title: Text('error'),
            actions: [
              FlatButton(onPressed: (){
                Navigator.of(ctx).pop();
              }, child: Text('Ok'))
            ],
          ));
        }

      }

      Navigator.of(context).pushNamed(UserProductsScreen.User_Product_Screen_Route);
    }

    setState(() {
      _isLoading=false;
    });


  }

  @override
  void dispose() {
    super.dispose();

  }

 Widget  getImageUrl(){
    if(_imageControll.text.isEmpty||imageUrl==null){
     return Center(child: Text('Empty Url')) ;
    }if(_imageControll.text !=null){
      return Image.network(_imageControll.text);
    }if(imageUrl !=null){
       return Image.network(imageUrl);
   }
 }

}
