import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/services/DatabaseService.dart';
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
    final account = Provider.of<Account>(context);
    final accounts = Provider.of<List<AccountData>>(context);
    final TextEditingController _controller = TextEditingController();
    final DatabaseService _database = DatabaseService(uid: account.uid);

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
                                onPressed: () async {
                                  await _database.promoteAccount(
                                    accounts[index].uid,
                                    accounts[index].accountType == 'EMPLOYEE' ? 'ADMIN' :
                                    accounts[index].accountType == 'ADMIN' ? 'EMPLOYEE' :
                                    accounts[index].accountType,
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text(accounts[index].accountType == 'EMPLOYEE' ? 'Promote' :
                                accounts[index].accountType == 'ADMIN' ? 'Demote' :
                                'Promote')
                              ),
                              TextButton(
                                  onPressed: () async {
                                    await _database.verifyAccount(
                                      accounts[index].uid,
                                      !accounts[index].isVerified,
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text(accounts[index].isVerified ? 'Suspend' : 'Verify')
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
