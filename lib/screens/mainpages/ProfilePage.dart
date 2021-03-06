import 'dart:io' show Platform;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/screens/subpages/ProfileEditor.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/shared/decorations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();

  void setExportPath() async {
    final snackBar = SnackBar(
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      content: Text('Export location saved'),
      action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
    );

    try {
      String path = await FilePicker.platform.getDirectoryPath();
      final prefs = await SharedPreferences.getInstance();
      print(path);
      if(path == '/' && Platform.isAndroid) {
        path = '/storage/emulated/0/Documents';
      }
      bool result = await prefs.setString('exportLocation', path);
      if(result) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        throw "Failed to save selected export location";
      }
    } catch(e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Export Location'),
            content: Text(e.toString()),
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
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountData>(context);

    return account != null ? Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
          ),
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
                      image: AssetImage('assets/images/logoHalf.gif'),
                      width: 200,
                      fit: BoxFit.cover),
                  ],
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person_rounded),
                      title: Text('Full Name'),
                      subtitle: Text(account.fullName),
                    ),
                    ListTile(
                      leading: Icon(Icons.badge),
                      title: Text('Username'),
                      subtitle: Text(account.username),
                    ),
                    ListTile(
                      leading: Icon(Icons.admin_panel_settings),
                      title: Text('Account Type'),
                      subtitle: Text(account.accountType),
                    ),
                    ListTile(
                      leading: Icon(Icons.mail_rounded),
                      title: Text('Email'),
                      subtitle: Text(account.email),
                    ),
                  ],
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: setExportPath,
                          style: buttonDecoration,
                          child: Text('SET EXPORT LOCATION')),
                      ElevatedButton(
                        onPressed: () =>
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileEditor(account: account)),
                        ),
                        style: buttonDecoration,
                        child: Text('EDIT ACCOUNT')),
                      ElevatedButton(
                          onPressed: () => _auth.signOut(),
                          child: Text('SIGN OUT'),
                        style: buttonDecoration
                      ),
                    ])
              ],
            ),
          )
      ),
    ) : Loading('Loading Account Info');
  }
}
