import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  Widget child;
  String value;
  Color color;


  Badge(this.child, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
         right: 10,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color!=null?color:Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(value),
          ),
            )
      ],
    );
  }
}
