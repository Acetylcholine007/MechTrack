import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/screens/mainpages/SignInPage.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/shared/decorations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'RegisterPage.dart';

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return loading ? Loading('Signing as guess') : Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
          ),
          child: Center(
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
                        style: buttonDecoration.copyWith(
                          backgroundColor: MaterialStateProperty.all(Color(0xFF002060))
                        ),
                        child: Text('CREATE ACCOUNT')),
                    ElevatedButton(onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      ),
                      style: buttonDecoration.copyWith(
                          backgroundColor: MaterialStateProperty.all(Color(0xFFC55A11))
                      ),
                      child: Text('SIGN IN')),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() => loading = true);
                          dynamic result = await _auth.signInAnon();
                          setState(() => loading = false);
                          if(result != 'SUCCESS') {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Log In'),
                                  content: Text(result),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK')
                                    )
                                  ],
                                )
                            );
                          }
                        },
                      style: buttonDecoration.copyWith(
                          backgroundColor: MaterialStateProperty.all(Color(0xFF002060))
                      ),
                      child: Text('Enter as Guest')),
                    SizedBox(height: 60),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.facebook),
                      // icon: Icon(Icons.android),
                      iconSize: 50,
                      color: Colors.blueAccent,
                      onPressed: () => launch('https://www.facebook.com'),
                    ),
                    Text('Find us on Facebook',
                        style: theme.textTheme.subtitle1,
                        textAlign: TextAlign.center)
                  ]
                ),
            ],
        ),
      ),
          )),
    );
  }
}
