import 'package:flutter/material.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/services/DatabaseService.dart';
import 'package:mech_track/shared/decorations.dart';
import 'package:provider/provider.dart';

class ProfileEditor extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = Provider.of<Account>(context);
    final AuthService _auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Editor'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey1,
                child: Column(
                  children: [
                    Text('Account Info', style: theme.textTheme.headline5),
                    TextFormField(
                      initialValue: '',
                      decoration:
                      formFieldDecoration.copyWith(hintText: 'Full Name'),
                      validator: (val) => val.isEmpty ? 'Enter Full Name' : null,
                      onChanged: (val) => setState(() => fullName = val),
                    ),
                    TextFormField(
                      initialValue: '',
                      decoration:
                      formFieldDecoration.copyWith(hintText: 'Username'),
                      validator: (val) => val.isEmpty ? 'Enter Username' : null,
                      onChanged: (val) => setState(() => username = val),
                    ),
                    ElevatedButton(onPressed: () async {
                      //TODO: Implement change account info
                      //TODO: Implement Validation, Dialog and Snackbar
                      await DatabaseService.db.editAccount(fullName, username, account.uid);
                    }, child: Text('SAVE CHANGES'),
                      style: buttonDecoration,)
                  ],
                ),
              ),
              Form(
                key: _formKey2,
                child: Column(
                  children: [
                    Text('Change Password', style: theme.textTheme.headline5),
                    TextFormField(
                      initialValue: '',
                      decoration:
                      formFieldDecoration.copyWith(hintText: 'New Password'),
                      validator: (val) => val.isEmpty ? 'Enter New Password' : null,
                      onChanged: (val) => setState(() => newPassword = val),
                    ),
                    TextFormField(
                      initialValue: '',
                      decoration:
                      formFieldDecoration.copyWith(hintText: 'Confirm Password'),
                      validator: (val) => val.isEmpty ? 'Enter Confirm Password' : null,
                      onChanged: (val) => setState(() => confirmPassword = val),
                    ),
                    ElevatedButton(onPressed: () async {
                      //TODO: Implement change password
                      //TODO: Implement Validation, Dialog and Snackbar
                      //TODO: Add see password
                      await _auth.changePassword(newPassword);
                    }, child: Text('CHANGE PASSWORD'),
                      style: buttonDecoration)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
