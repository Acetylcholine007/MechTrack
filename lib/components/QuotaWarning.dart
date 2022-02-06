import 'package:flutter/material.dart';

class QuotaWarning extends StatelessWidget {
  const QuotaWarning({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
      ),
      child: Center(
        child: Text(
          'Quota Reached.\nRetry the following day.',
          style: theme.textTheme.headline4,
          textAlign: TextAlign.center,),
      ),
    );
  }
}
