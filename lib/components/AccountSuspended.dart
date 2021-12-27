import 'package:flutter/material.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/shared/decorations.dart';

class AccountSuspended extends StatefulWidget {
  const AccountSuspended({Key key}) : super(key: key);

  @override
  _AccountSuspendedState createState() => _AccountSuspendedState();
}

class _AccountSuspendedState extends State<AccountSuspended> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your account is currently suspended.',
                style: theme.textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              Text(
                '\nContact the Admin to review your account.\n',
                style: theme.textTheme.button,
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () => _auth.signOut(),
                child: Text('SIGN OUT'),
                style: buttonDecoration
              )
            ],
          ),
        ),
      ),
    );
  }
}
