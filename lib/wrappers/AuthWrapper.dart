import 'package:flutter/material.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/screens/mainpages/RegisterPage.dart';
import 'package:mech_track/screens/mainpages/SignInPage.dart';
import 'package:mech_track/wrappers/MainWrapper.dart';
import 'package:provider/provider.dart';

import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/screens/mainpages/FrontPage.dart';
import 'package:mech_track/services/DatabaseService.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Account>(context);

    if(authUser != null) {
      return MultiProvider(
          providers: [
            StreamProvider<AccountData>.value(value: DatabaseService(uid: authUser.uid).user, initialData: null),
            StreamProvider<List<Part>>.value(value: DatabaseService(uid: authUser.uid).parts, initialData: null),
            // StreamProvider<List<Activity>>.value(value: DatabaseService(uid: authUser.uid).activity, initialData: null),
            // StreamProvider<List<String>>.value(value: DatabaseService(uid: authUser.uid).myEventIds, initialData: null)
          ],
          child: Loading('Loading contents')
      );
    } else {
      // return FrontPage();
      return MainWrapper();
      return SignInPage();
    }
  }
}
