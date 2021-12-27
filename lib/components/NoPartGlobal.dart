import 'package:flutter/material.dart';

class NoPartGlobal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
      ),
      child: Center(
        child: Text(
        'No Part data in your Global Database',
        style: theme.textTheme.headline4),
      ),
    );
  }
}
