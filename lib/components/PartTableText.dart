import 'package:flutter/material.dart';

class PartTableText extends StatelessWidget {
  final String text;
  final String colType;

  const PartTableText(this.text, this.colType, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if(colType == 'LABEL')
      return Text(text, style: theme.textTheme.headline5);
    else
      return Text(text, style: theme.textTheme.headline6);
  }
}
