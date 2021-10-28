import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode{
  Login,Register
}

class _AuthCardState extends State<AuthCard>  with SingleTickerProviderStateMixin{
  GlobalKey<FormState> _key=GlobalKey();
  AuthMode _authMode=AuthMode.Register;
  var _passwordController=TextEditingController();
  var _emailController=TextEditingController();
  AnimationController animationController;
  Animation<Offset> _animationOffest;
  Animation<double> _opacityAnimation;
  Map<String,String> _userData={'email':'',
                                 'password':''};
  bool _isloading=false;
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    animationController=AnimationController(
      duration: Duration(seconds: 2),
      vsync: this
    );
    _animationOffest=Tween<Offset>(begin: Offset(-5,0.15),end: Offset(0,0))
    .animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOutExpo));

    _opacityAnimation=Tween<double>(begin: 0.0,end: 1.0)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn));
  }
  @override
  Widget build(BuildContext context) {
  var size=MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),

      ),
        color:Colors.white,
        child: AnimatedContainer(
          width: size.width *0.75,
          duration: Duration(microseconds: 300),
          curve: Curves.easeIn,
          padding: EdgeInsets.all(10),
        height: _authMode==AuthMode.Login?220:340,
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                     decoration: InputDecoration(
                       labelText: 'email',
                       hintText: 'enter email'
                     ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val){
                       if(val.isEmpty||!val.contains('@')){
                         return 'Invalid Email';
                       }return null;
                    },
                    onSaved: (val){
                      _userData['email']=val;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: 'password',
                        hintText: 'enter password'
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val){
                      if(val.isEmpty){
                        return 'Invalid password';
                      }else if(val.length<6){
                        return 'weak password';
                      }
                      return null;
                    },
                    onSaved: (val){
                        _userData['password']=val;
                    },
                  ),
                  Visibility(
                    visible: _authMode==AuthMode.Register?true:false,

                    child: AnimatedContainer(duration: Duration(seconds: 1),
                      curve: Curves.easeIn,
                     // height: _authMode==AuthMode.Register?800:0 ,
                     //  constraints: BoxConstraints(
                     //    minHeight: _authMode==AuthMode.Register?50:0,
                     //    maxHeight: _authMode==AuthMode.Register?100 :0
                     //  ),
                      child: TextFormField(
                        enabled: _authMode==AuthMode.Register,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: 'Match Password', hintText: 'enter password'),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Invalid password';
                          } else if (val.length < 6) {
                            return 'weak password';
                          }else if(val != _passwordController.text)
                          return 'password not match';
                        },
                        onSaved: (val) {
                          _userData['password'] = val;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  if(_isloading)
                    CircularProgressIndicator()
                  else
                  RaisedButton(onPressed:submitData,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_authMode==AuthMode.Login?'Login':'Sign Up',style: TextStyle(color: Colors.white),),
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 20,),
                  FlatButton(onPressed: switchMode,
            child: Text('${_authMode==AuthMode.Login?'Sign Up':'Login'} INSTEAD'),
                  textColor: Theme.of(context).primaryColor,)
                ],
              ),
            ),
          ),
    ),
    );
  }


  Future submitData()async{
  if(_key.currentState.validate()){
    setState(() {
      _isloading=true;
    });

  }
  _key.currentState.save();
  //Focus.of(context).unfocus();
  print('modeddddd  ${_authMode}');
  try{
    if( _authMode==AuthMode.Register){
    await  Provider.of<AuthProvider>(context,listen: false).signup(_userData['email'], _userData['password']);
    }else{
    await  Provider.of<AuthProvider>(context,listen: false).login(_userData['email'], _userData['password']);
    print('log oooo');
    }

    setState(() {
      _isloading=false;
    });

    //_showErrorMessage(context, 'message');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>ProductOverviewScreen()));

  } on HttpError catch(r){
    print('rrrr vvvvvv ${r.message}');
     String message='';
    if(r.message.contains('EMAIL_NOT_FOUND')){
      message='EMAIL_NOT_FOUND';
    }if(r.message.contains('INVALID_PASSWORD')){
      message='INVALID_PASSWORD';
    }if(r.message.contains('USER_DISABLED')){
      message='USER_DISABLED';
    }if(r.message.contains('EMAIL_EXISTS')){
       message='EMAIL_EXISTS';
     }if(r.message.contains('INVALID_EMAIL')){
      message='INVALID_EMAIL';
    }
    _showErrorMessage(context, message);
  }
  catch(r){
    String message;
    //print('rrrr ${r}');
    _showErrorMessage(context,r);
  }
  }


  void switchMode(){
  print('1');
      if( _authMode==AuthMode.Register){
        print(_authMode);
        print('2');
        setState(() {
          _isloading=false;
          _authMode=AuthMode.Login;
          animationController.forward();
        });

      }else{
        setState(() {
          print('3');
          print(_authMode);
          _isloading=false;
          _authMode=AuthMode.Register;
          animationController.reverse();
        });

      }
  }

  void _showErrorMessage(BuildContext context, String message) {
 showDialog(context: context, builder: (context)=>
 AlertDialog(
   title: Text('Authonication Failed'),
   content:Text(message) ,
   actions: [
     FlatButton(onPressed:()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>AuthScreen())),
         child: Text('OK!'))
   ],
 ));
  
  }
}
