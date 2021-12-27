import 'package:flutter/material.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/shared/decorations.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool hidePassword = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
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
                          image: AssetImage('assets/images/newLogoFull.gif'),
                          width: 150,
                          fit: BoxFit.cover),
                      Text('Welcome back, Log In!',
                          style: theme.textTheme.headline5,
                          textAlign: TextAlign.center)
                    ],
                  ),
                  SizedBox(height: 60),
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
                              onChanged: (val) => setState(() => email = val)
                          ),
                          Text('Password', style: theme.textTheme.headline6),
                          TextFormField(
                            initialValue: '',
                            decoration: formFieldDecoration.copyWith(
                                suffixIcon: IconButton(
                                    onPressed: () => setState(() => hidePassword = !hidePassword),
                                    icon: Icon(Icons.visibility)),
                                hintText: 'Password'),
                            validator: (val) => val.isEmpty ? 'Enter Password' : null,
                            onChanged: (val) => setState(() => password = val),
                            obscureText: hidePassword,
                          ),
                          TextButton(
                              onPressed: () => {}, child: Text('Forgot Password?')),
                        ]),
                  ),
                  SizedBox(height: 60),
                  ElevatedButton(onPressed: () async {
                    if(_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      //TODO: Implement Loading Indication
                      String result = await _auth.signInEmail(email, password);
                      print(result);
                      if(result != 'SUCCESS') {
                        setState(() {
                          loading = false;
                        });
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
                      } else {
                        Navigator.pop(context);
                      }
                    } else {
                      final snackBar = SnackBar(
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        content: Text('Fill up all the fields'),
                        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }, child: Text('Log In'),
                    style: buttonDecoration
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
