import 'package:flutter/material.dart';
import 'package:mech_track/screens/subpages/ProfileEditor.dart';
import 'package:mech_track/services/AuthService.dart';
import 'package:mech_track/shared/decorations.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Container(
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
                      image: AssetImage('assets/images/newLogoHalf.gif'),
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
                      subtitle: Text('John Doe'),
                    ),
                    ListTile(
                      leading: Icon(Icons.badge),
                      title: Text('Username'),
                      subtitle: Text('johndoe'),
                    ),
                    ListTile(
                      leading: Icon(Icons.admin_panel_settings),
                      title: Text('Account Type'),
                      subtitle: Text('Admin'),
                    ),
                    ListTile(
                      leading: Icon(Icons.mail_rounded),
                      title: Text('Email'),
                      subtitle: Text('johndoe@gmail.com'),
                    ),
                  ],
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () =>
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileEditor()),
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
    );
  }
}
