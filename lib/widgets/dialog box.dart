import 'package:flutter/material.dart';
import 'package:mark/constants.dart';

class dialogbox extends StatelessWidget {
  String text, content;
  VoidCallback func;
  dialogbox({Key key, this.text, this.content, this.func}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all( Radius.circular(10.0))),
            title: Text(
              text,
              style: Textstyles.bodytext2,
            ),
            content: Text(content,
                style: Textstyles.bodytext1),
            actions: <Widget>[
              TextButton(
                child: const Text("Done",
                    style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.of(context).pop();
                  func;
                },
              ),
            ],
          );
    }


  }


