import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage('assets/images/logoHalf.png'),
                    width: 100,
                    fit: BoxFit.cover),
                Text('Mechanical Equipment Inventory',
                    style: theme.textTheme.headline5,
                    textAlign: TextAlign.center)
              ],
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () => {}, child: Text('CREATE ACCOUNT')),
                  ElevatedButton(onPressed: () => {}, child: Text('SIGN IN')),
                  ElevatedButton(
                      onPressed: () => {}, child: Text('Enter as Guest')),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.facebook),
                    // icon: Icon(Icons.android),
                    iconSize: 50,
                    color: Colors.blueAccent,
                    onPressed: () {},
                  ),
                  Text('Find us on Facebook',
                      style: theme.textTheme.subtitle1,
                      textAlign: TextAlign.center)
                ])
          ],
        ),
      )),
    );
  }
}
