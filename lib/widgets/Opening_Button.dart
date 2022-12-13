import 'package:flutter/material.dart';

class openingbutton extends StatelessWidget {
  String text;
  final VoidCallback func;
  openingbutton({Key key, this.text , this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:Container(
        color: Colors.white,
        padding: EdgeInsets.all(5),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(12.0),
          textColor: Colors.white,
          onPressed: func,
          child: Text(
            text,
            textScaleFactor: 1.2,
          ),
          color: Colors.blue,
        ),
      ),
    );
  }
}
