import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:provider/provider.dart';

import 'package:mech_track/components/AccountSearchBar.dart';
import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/models/AccountData.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  String category = 'Full Name';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accounts = Provider.of<List<AccountData>>(context);
    final TextEditingController _controller = TextEditingController();
    final items = [
      ["Item 1", "lorem ipsum"],
      ["Item 2", "lorem ipsum"],
      ["Item 3", "lorem ipsum"],
      ["Item 4", "lorem ipsum"],
      ["Item 5", "lorem ipsum"],
      ["Item 6", "lorem ipsum"],
      ["Item 7", "lorem ipsum"],
    ];

    void categoryHandler(String newCat) {
      setState(() => category = newCat);
    }

    return accounts != null ? Scaffold(
      appBar: AppBar(
        title: Text('Accounts Management Page'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AccountSearchBar(controller: _controller, category: category, categoryHandler: categoryHandler, context: context),
            Expanded(
                child: ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Account Info'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.person_rounded),
                                    title: Text('Full Name'),
                                    subtitle: Text(accounts[index].fullName),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.badge),
                                    title: Text('Username'),
                                    subtitle: Text(accounts[index].username),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.admin_panel_settings),
                                    title: Text('Account Type'),
                                    subtitle: Text(accounts[index].accountType),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.mail_rounded),
                                    title: Text('Email'),
                                    subtitle: Text(accounts[index].email),
                                  ),
                                ],
                              )
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {

                                },
                                child: Text('Promote')
                              ),
                              TextButton(
                                  onPressed: () {

                                  },
                                  child: Text('Verify')
                              ),
                              TextButton(
                                  onPressed: () {

                                  },
                                  child: Text('Delete')
                              ),
                            ],
                          )
                        ),
                        child: PartListTile(
                          key: Key(index.toString()),
                          name: accounts[index].fullName,
                          caption: accounts[index].email,
                          index: index
                        ),
                      );
                    }
                )
            )
          ],
        ),
      ),
    ) : Loading('Loading Accounts');
  }
}
