import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/shared/decorations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuessProfilePage extends StatefulWidget {
  const GuessProfilePage({Key key}) : super(key: key);

  @override
  _GuessProfilePageState createState() => _GuessProfilePageState();
}

class _GuessProfilePageState extends State<GuessProfilePage> {
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
    final theme = Theme.of(context);

    return Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Guess Account',
                      style: theme.textTheme.headline4,
                      textAlign: TextAlign.center),
                    Text('\nUse authenticated account to access\nthe full features of the App',
                      style: theme.textTheme.button,
                      textAlign: TextAlign.center),
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
                      onPressed: () => _auth.signOut(),
                      child: Text('SIGN OUT'),
                      style: buttonDecoration
                    ),
                  ])
              ],
            ),
          )
      ),
    );
  }
}

