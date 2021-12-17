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
    // final authUser = Provider.of<Account>(context);
    final authUser = Account(uid: 'Axsj3dj5esa21', email: 'johndoe@gmail.com');
    // final authUser = null;

    if(authUser != null) {
      return MultiProvider(
          providers: [
            StreamProvider<AccountData>.value(value: DatabaseService(uid: authUser.uid).user, initialData: null),
            StreamProvider<List<Part>>.value(value: DatabaseService(uid: authUser.uid).parts, initialData: null),
            // StreamProvider<List<Activity>>.value(value: DatabaseService(uid: authUser.uid).activity, initialData: null),
            // StreamProvider<List<String>>.value(value: DatabaseService(uid: authUser.uid).myEventIds, initialData: null)
          ],
        child: MainWrapper()
      );
    } else {
      return FrontPage();
    }
  }
}
