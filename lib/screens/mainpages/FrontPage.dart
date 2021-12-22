import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mech_track/screens/mainpages/SignInPage.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/shared/decorations.dart';

import 'RegisterPage.dart';

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final AuthService _auth = AuthService();

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
                    image: AssetImage('assets/images/newLogoHalf.gif'),
                    width: 200,
                    fit: BoxFit.cover),
                Text('Mechanical Equipment Inventory',
                    style: theme.textTheme.headline4,
                    textAlign: TextAlign.center)
              ],
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage())
                        ),
                      style: buttonDecoration,
                      child: Text('CREATE ACCOUNT')),
                  ElevatedButton(onPressed: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    ),
                    style: buttonDecoration,
                    child: Text('SIGN IN')),
                  ElevatedButton(
                      onPressed: () async {
                        dynamic result = await _auth.signInAnon();
                        print(result);
                      },
                    style: buttonDecoration,
                    child: Text('Enter as Guest')),
                  SizedBox(height: 60),
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
                ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

              ],
            )
          ],
        ),
      )),
    );
  }
}
