import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';
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
  String query = '';

  List<AccountData> filterHandler (List<AccountData> accounts) {
    if(query != "") {
      switch (category) {
        case 'Full Name':
          return accounts
              .where((account) =>
              account.fullName.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Username':
          return accounts
              .where((account) => account.username
              .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Email':
          return accounts
              .where((account) => account.email
              .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        default:
          return accounts;
      }
    } else {
      return accounts;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<AccountData> accounts = Provider.of<List<AccountData>>(context);

    void searchHandler(String val) {
      return setState(() => query = val);
    }

    void categoryHandler(String newCat) {
      setState(() => category = newCat);
    }

    accounts = filterHandler(accounts);

    return accounts != null ? Scaffold(
      appBar: AppBar(
        title: Text('Accounts Management Page'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AccountSearchBar(category: category, categoryHandler: categoryHandler, searchHandler: searchHandler, context: context),
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
                                  String result = await DatabaseService.db.promoteAccount(
                                    accounts[index].uid,
                                    accounts[index].accountType == 'EMPLOYEE' ? 'ADMIN' :
                                    accounts[index].accountType == 'ADMIN' ? 'EMPLOYEE' :
                                    accounts[index].accountType,
                                  );

                                  if(result == 'SUCCESS') {
                                    final snackBar = SnackBar(
                                      duration: Duration(seconds: 3),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text("Account ${accounts[index].accountType == 'EMPLOYEE' ? 'Promoted' :
                                      accounts[index].accountType == 'ADMIN' ? 'Demoted' :
                                      'Promoted'}"),
                                      action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                                    );
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Account Promotion'),
                                          content: Text(result),
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
                                },
                                child: Text(accounts[index].accountType == 'EMPLOYEE' ? 'Promote' :
                                accounts[index].accountType == 'ADMIN' ? 'Demote' :
                                'Promote')
                              ),
                              TextButton(
                                  onPressed: () async {
                                    String result = await DatabaseService.db.verifyAccount(
                                      accounts[index].uid,
                                      !accounts[index].isVerified,
                                    );

                                    if(result == 'SUCCESS') {
                                      final snackBar = SnackBar(
                                        duration: Duration(seconds: 3),
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("Account ${accounts[index].isVerified ? 'Suspended' : 'Verified'}"),
                                        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                                      );
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Account Verification'),
                                            content: Text(result),
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
                                  },
                                  child: Text(accounts[index].isVerified ? 'Suspend' : 'Verify')
                              ),
                            ],
                          )
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: theme.backgroundColor.withOpacity(0.15),
                          child: PartListTile(
                            key: Key(index.toString()),
                            name: accounts[index].fullName,
                            caption: accounts[index].email,
                            index: index
                          ),
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
