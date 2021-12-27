import 'package:flutter/material.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/services/DatabaseService.dart';
import 'package:mech_track/shared/decorations.dart';

class ProfileEditor extends StatefulWidget {
  final AccountData account;

  ProfileEditor({this.account});

  @override
  _ProfileEditorState createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String fullName;
  String username;
  String newPassword;
  String confirmPassword;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    fullName = widget.account.fullName;
    username = widget.account.username;
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AuthService _auth = AuthService();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account Editor'),
        ),
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
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Form(
                      key: _formKey1,
                      child: Column(
                        children: [
                          Text('Account Info', style: theme.textTheme.headline5),
                          Text('Full Name',
                              style: theme.textTheme.button),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,5,0,10),
                            child: TextFormField(
                              initialValue: fullName,
                              decoration:
                              formFieldDecoration.copyWith(hintText: 'Full Name'),
                              validator: (val) => val.isEmpty ? 'Enter Full Name' : null,
                              onChanged: (val) => setState(() => fullName = val),
                            ),
                          ),
                          Text('Username',
                              style: theme.textTheme.button),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,5,0,10),
                            child: TextFormField(
                              initialValue: username,
                              decoration:
                              formFieldDecoration.copyWith(hintText: 'Username'),
                              validator: (val) => val.isEmpty ? 'Enter Username' : null,
                              onChanged: (val) => setState(() => username = val),
                            ),
                          ),
                          ElevatedButton(onPressed: () async {
                            if(_formKey1.currentState.validate()) {
                              String result = await DatabaseService.db.editAccount(fullName, username, widget.account.uid);
                              if(result == 'SUCCESS') {
                                final snackBar = SnackBar(
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('Account Info successfully changed'),
                                  action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Change Account Info'),
                                      content: Text(result),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK')
                                        )
                                      ],
                                    )
                                );
                              }
                            } else {
                              final snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                content: Text('Fill up both Full Name and Username fields'),
                                action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          }, child: Text('SAVE CHANGES'),
                            style: buttonDecoration,)
                        ],
                      ),
                    ),
                    SizedBox(height: 60),
                    Form(
                      key: _formKey2,
                      child: Column(
                        children: [
                          Text('Change Password', style: theme.textTheme.headline5),
                          Text('New Password',
                              style: theme.textTheme.button),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,5,0,10),
                            child: TextFormField(
                              initialValue: '',
                              decoration:
                              formFieldDecoration.copyWith(hintText: 'New Password',
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => hideNewPassword = !hideNewPassword),
                                  icon: Icon(Icons.visibility)),
                              ),
                              validator: (val) => val.isEmpty ? 'Enter New Password' : val.length < 6 ? 'Should be 6 or more characters in length' : null,
                              onChanged: (val) => setState(() => newPassword = val),
                              obscureText: hideNewPassword,
                            ),
                          ),
                          Text('Confirm Password',
                              style: theme.textTheme.button),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,5,0,10),
                            child: TextFormField(
                              initialValue: '',
                              decoration:
                              formFieldDecoration.copyWith(hintText: 'Confirm Password',
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => hideConfirmPassword = !hideConfirmPassword),
                                  icon: Icon(Icons.visibility)
                                ),
                              ),
                              validator: (val) => val.isEmpty ? 'Enter Confirm Password' : val.length < 6 ? 'Should be 6 or more characters in length' : null,
                              onChanged: (val) => setState(() => confirmPassword = val),
                              obscureText: hideConfirmPassword,
                            ),
                          ),
                          ElevatedButton(onPressed: () async {
                            if(_formKey2.currentState.validate() && newPassword == confirmPassword) {
                              String result = await _auth.changePassword(newPassword);
                              if(result == 'SUCCESS') {
                                final snackBar = SnackBar(
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('Password successfully changed'),
                                  action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Change Password'),
                                    content: Text(result),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK')
                                      )
                                    ],
                                  )
                                );
                              }
                            } else {
                              final snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                content: Text(newPassword != confirmPassword ? 'Password fields mismatched' : 'Fill up New and Confirm password fields properly'),
                                action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          }, child: Text('CHANGE PASSWORD'),
                            style: buttonDecoration)
                        ],
                      ),
                    )
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
