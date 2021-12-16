import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
                      image: AssetImage('assets/images/logoHalf.png'),
                      width: 100,
                      fit: BoxFit.cover),
                  Text('Profile',
                      style: theme.textTheme.headline5,
                      textAlign: TextAlign.center)
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
                        onPressed: () => {}, child: Text('EDIT ACCOUNT')),
                    ElevatedButton(onPressed: () => {}, child: Text('SIGN OUT')),
                  ])
            ],
          ),
        )
    );
  }
}
