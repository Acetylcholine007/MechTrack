import 'package:flutter/material.dart';

class GuessHelpPage extends StatelessWidget {
  const GuessHelpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Page'),
      ),
      body: Container(
        child: Text('Help'),
      ),
    );
  }
}
