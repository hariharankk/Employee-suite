import 'package:flutter/material.dart';

class listtile extends StatelessWidget {
  listtile({Key key, this.subtitle, this.text , this.icon }) : super(key: key);

  String text , subtitle;
  Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        text,
        textScaleFactor: 1.5,
      ),
      subtitle: Text(subtitle),
    );
  }
}
