import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/shared/decorations.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String resetEmail = '';
  String email = '';
  String password = '';
  bool hidePassword = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return loading ? Loading('Logging In') : GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
          ),
          child: Center(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
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
                      key: _formKey1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text('Email', style: theme.textTheme.button),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,5,0,10),
                              child: TextFormField(
                                  initialValue: '',
                                  decoration:
                                      formFieldDecoration.copyWith(hintText: 'Email'),
                                  validator: (val) => val.isEmpty ? 'Enter Email' : null,
                                  onChanged: (val) => setState(() => email = val)
                              ),
                            ),
                            Text('Password', style: theme.textTheme.button),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,5,0,10),
                              child: TextFormField(
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
                            ),
                          ]),
                    ),
                    SizedBox(height: 60),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(onPressed: () async {
                          if(_formKey1.currentState.validate()) {
                            setState(() => loading = true);
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
                          style: buttonDecoration.copyWith(
                              backgroundColor: MaterialStateProperty.all(Color(0xFFC55A11))
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Reset Password'),
                                  content: Form(
                                    key: _formKey2,
                                    child: TextFormField(
                                        initialValue: resetEmail,
                                        decoration: formFieldDecoration.copyWith(hintText: 'Email'),
                                        validator: (val) => val.isEmpty ? 'Enter Email' : null,
                                        onChanged: (val) => setState(() => resetEmail = val)
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          if (_formKey2.currentState.validate()) {
                                            String result = await _auth.resetPassword(resetEmail);
                                            if (result == 'SUCCESS') {
                                              Navigator.pop(context);
                                              final snackBar = SnackBar(
                                                duration: Duration(seconds: 2),
                                                behavior: SnackBarBehavior.floating,
                                                content: Text('Password Reset sent to your email.'),
                                                action: SnackBarAction(label: 'OK',
                                                    onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            } else {
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text('Reset Password'),
                                                        content: Text(result),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(context),
                                                              child: Text('OK')
                                                          )
                                                        ],
                                                      )
                                              );
                                            }
                                          }
                                        },
                                        child: Text('RESET PASSWORD')
                                    )
                                  ],
                                )
                            );
                          }, child: Text('Forgot Password?'),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Color(0xFF0D0D0D))
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
