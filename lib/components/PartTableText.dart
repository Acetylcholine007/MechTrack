import 'package:flutter/material.dart';

class PartTableText extends StatelessWidget {
  final String text;
  final String colType;

  const PartTableText(this.text, this.colType, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if(colType == 'LABEL')
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: theme.textTheme.headline6),
      );
    else
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: theme.textTheme.headline6.copyWith(fontWeight: FontWeight.normal)),
      );
  }
}
