import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';
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
  Map<int, Color> getSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;

    final lowDivisor = 6;
    final highDivisor = 5;

    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;

    return {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
    };
  }

  List<ThemeData> themes;

  @override
  void initState() {
    themes = [
      ThemeData(primarySwatch:
        MaterialColor(0xFFC55A11, getSwatch(Color(0xFFC55A11)))
      ),
      ThemeData(primarySwatch:
        MaterialColor(0xFF002060, getSwatch(Color(0xFF002060)))
      ),
      ThemeData(primarySwatch:
        MaterialColor(0xFF0D0D0D, getSwatch(Color(0xFF0D0D0D)))
      ),
      ThemeData(primarySwatch: Colors.blue),
    ];
    super.initState();
  }

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
        // child: MainWrapper(account: authUser)
        child: Builder(
          builder: (context) {
            final account = Provider.of<AccountData>(context);

            return account == null ?
            MyMaterialApp(child: Loading('Loading Account Data'), appTheme: themes[3]) :
            MyMaterialApp(
              child: MainWrapper(account: authUser),
              appTheme: account.accountType == 'ADMIN' ? themes[2] : themes[1],
            );
          },
        ),
      );
    } else if (authUser != null && authUser.isAnon) {
      // return MainWrapper(account: authUser);
      return Builder(
        builder: (context) {
          return MyMaterialApp(
            child: MainWrapper(account: authUser),
            appTheme: themes[0],
          );
        },
      );
    } else {
      // return FrontPage();
      return Builder(
        builder: (context) {
          return MyMaterialApp(
            child:FrontPage(),
            appTheme: themes[3],
          );
        },
      );
    }
  }
}

class MyMaterialApp extends StatelessWidget {
  final Widget child;
  final ThemeData appTheme;
  const MyMaterialApp({Key key, this.child, this.appTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
      theme: appTheme,
    );
  }
}

