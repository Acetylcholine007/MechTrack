import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mech_track/models/Part.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/screens/mainpages/FrontPage.dart';
import 'package:mech_track/services/DatabaseService.dart';
import 'package:mech_track/wrappers/MainWrapper.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Account>(context);

    if(authUser != null && !authUser.isAnon && authUser.isEmailVerified) {
      return MultiProvider(
          providers: [
            StreamProvider<AccountData>.value(value: DatabaseService.db.getUser(authUser.uid), initialData: null),
            StreamProvider<List<Part>>.value(value: DatabaseService.db.parts, initialData: null),
            StreamProvider<List<AccountData>>.value(value: DatabaseService.db.users, initialData: null),
          ],
        child: MainWrapper(account: authUser)
      );
    } else if (authUser != null && authUser.isAnon) {
      return MainWrapper(account: authUser);
    } else {
      return FrontPage();
    }
  }
}
