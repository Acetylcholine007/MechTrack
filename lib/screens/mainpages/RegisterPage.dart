import 'package:flutter/material.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/shared/decorations.dart';

import 'SignInPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool showPassword = true;
  AccountData accountData = AccountData();

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
                      Text('Create your Account',
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
                          Text('Full Name', style: theme.textTheme.headline6),
                          TextFormField(
                              initialValue: '',
                              decoration:
                                  formFieldDecoration.copyWith(hintText: 'Full Name'),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter Full Name' : null,
                              onChanged: (val) => setState(() => accountData.fullName = val)
                              ),
                          Text('Username', style: theme.textTheme.headline6),
                          TextFormField(
                              initialValue: '',
                              decoration:
                                  formFieldDecoration.copyWith(hintText: 'Username'),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter Username' : null,
                              onChanged: (val) => setState(() => accountData.username = val)
                          ),
                          Text('Email', style: theme.textTheme.headline6),
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
                                    onPressed: () => setState(() => showPassword = !showPassword),
                                    icon: Icon(Icons.visibility)),
                                hintText: 'Password'),
                            validator: (val) => val.isEmpty ? 'Enter Password' : null,
                              onChanged: (val) => setState(() => password = val),
                              obscureText: showPassword,
                            ),
                          TextButton(
                              onPressed: () =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignInPage()),
                                  ),
                              child: Text('Already have account? Sign In')),
                        ]),
                  ),
                  SizedBox(height: 60),
                  ElevatedButton(onPressed: () async {
                    //TODO: Implement Loading Indication, validation and dialogs
                    if(_formKey.currentState.validate()) {
                      // setState(() => loading = true);
                      String result = await _auth.register(
                          accountData, email, password);
                      if (result == 'SUCCESS') {
                        setState(() {
                          // loading = false;
                          // verifying = true;
                        });
                      } else {
                        setState(() {
                          // error = result;
                          // loading = false;
                        });
                        // showDialog(
                        //     context: context,
                        //     builder: (context) => AlertDialog(
                        //       title: Text('Sign In'),
                        //       content: Text(error),
                        //       actions: [
                        //         TextButton(
                        //             onPressed: () => Navigator.pop(context),
                        //             child: Text('OK')
                        //         )
                        //       ],
                        //     )
                        // );
                      }
                    } else {
                      print('Fill all the fields');
                    }
                  }, child: Text('Register'),
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
