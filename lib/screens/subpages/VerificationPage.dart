import 'dart:async';

import 'package:mech_track/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  final Function callback;
  final AuthService auth;

  VerificationPage({this.callback, this.auth});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  User user;
  Timer timer;

  @override
  void initState() {
    user = widget.auth.auth.currentUser;

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Verify your email at:', style: theme.textTheme.headline4),
              SizedBox(height: 20),
              Text(user.email, style: theme.textTheme.bodyText2)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = widget.auth.auth.currentUser;
    await user.reload();
    if(user.emailVerified) {
      await widget.auth.auth.signOut();
      timer.cancel();
      widget.callback();
    }
  }
}