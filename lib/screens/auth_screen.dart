import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/widgets/auth_card.dart';


class AuthScreen extends StatelessWidget {
  static String AUTH_ROUTE='auth';

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255,1).withOpacity(0.5),
                Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
                stops:[0,1]
            )
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              child: Text(
                'My Shop',
                style: TextStyle(
                    color: Theme.of(context).accentTextTheme.headline6.color,
                    fontSize: 50,
                    fontFamily: 'Anton'),
              ),
              decoration: BoxDecoration(
                  color: Colors.deepOrange.shade900,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black54, offset: Offset(0, 2))
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              transform: Matrix4.rotationZ(-8 * pi / 180)
                ..translate(-10.0),
            ),
            Flexible(flex:size.width>600?2:1,
                child:AuthCard() )
          ],
        ),

      ]
      ),
    );
  }
}
