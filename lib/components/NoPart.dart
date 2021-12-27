import 'package:flutter/material.dart';

class NoPart extends StatelessWidget {
  final bool isValid;
  const NoPart({Key key, this.isValid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Part Viewer'),
      ),
      body: Container(
        child: Center(
          child: Text(
          isValid ? 'No Part Exist' : 'Invalid Part QR Code',
          style: theme.textTheme.headline4),
        ),
      ),
    );
  }
}
