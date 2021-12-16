import 'package:flutter/material.dart';
import 'package:mech_track/shared/decorations.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

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
                    image: AssetImage('assets/images/logoFull.png'),
                    width: 100,
                    fit: BoxFit.cover),
                Text('Welcome back, Log In!',
                    style: theme.textTheme.headline5,
                    textAlign: TextAlign.center)
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Username', style: theme.textTheme.headline6),
                    TextFormField(
                        initialValue: '',
                        decoration:
                            formFieldDecoration.copyWith(hintText: 'Email'),
                        validator: (val) => val.isEmpty ? 'Enter Email' : null,
                        onChanged: (val) => {}),
                    Text('Password', style: theme.textTheme.headline6),
                    TextFormField(
                      initialValue: '',
                      decoration: formFieldDecoration.copyWith(
                          suffixIcon: IconButton(
                              onPressed: () => {},
                              icon: Icon(Icons.visibility)),
                          hintText: 'Password'),
                      validator: (val) => val.isEmpty ? 'Enter Password' : null,
                      onChanged: (val) => setState(() => {}),
                      obscureText: true,
                    ),
                    TextButton(
                        onPressed: () => {}, child: Text('Forgot Password?')),
                  ]),
            ),
            ElevatedButton(onPressed: () => {}, child: Text('Log In')),
          ],
        ),
      )),
    );
  }
}
