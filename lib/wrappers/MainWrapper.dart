import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/AccountData.dart';

import 'package:mech_track/screens/mainpages/AccountPage.dart';
import 'package:mech_track/screens/mainpages/DataPage.dart';
import 'package:mech_track/screens/mainpages/GuessProfilePage.dart';
import 'package:mech_track/screens/mainpages/InventoryGlobalPage.dart';
import 'package:mech_track/screens/mainpages/InventoryLocalPage.dart';
import 'package:mech_track/screens/mainpages/ProfilePage.dart';
import 'package:provider/provider.dart';

class MainWrapper extends StatefulWidget {
  final Account account;

  MainWrapper({this.account});

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  List<Page> pages;

  Future<String> scanCode() async {
    var result = await BarcodeScanner.scan();
    return result.rawContent;
  }

  String getAccountType(bool isAnon, String type) {
    if (isAnon)
      return 'GUESS';
    if (!isAnon && type == "ADMIN")
      return 'ADMIN';
    if (!isAnon && type == "EMPLOYEE")
      return 'EMPLOYEE';
    return 'ADMIN';
  }

  List<Widget> getPages(String accountType) {
    if(accountType == 'GUESS')
      return pages
        .where((page) => page.accessLevel <= 1)
        .map((page) => page.page)
        .toList();
    if(accountType == 'EMPLOYEE')
      return pages
        .where((page) => page.accessLevel <= 2)
        .map((page) => page.page)
        .toList();
    if(accountType == 'ADMIN')
      return pages
        .where((page) => page.accessLevel <= 3)
        .map((page) => page.page)
        .toList();
    return [];
  }

  List<BottomNavigationBarItem> getTabs(String accountType) {
    if(accountType == 'GUESS')
      return pages
        .where((page) => page.accessLevel <= 1)
        .map((page) => page.tab)
        .toList();
    if(accountType == 'EMPLOYEE')
      return pages
        .where((page) => page.accessLevel <= 2)
        .map((page) => page.tab)
        .toList();
    if(accountType == 'ADMIN')
      return pages
        .where((page) => page.accessLevel <= 3)
        .map((page) => page.tab)
        .toList();
    return [];
  }

  @override
  void initState() {
    pages = [
      Page(
          DataPage(),
          BottomNavigationBarItem(
            label: 'Data',
            icon: Icon(Icons.archive_rounded),
          ),
          1
      ),
      Page(
          InventoryLocalPage(),
          BottomNavigationBarItem(
            label: 'Local',
            icon: Icon(Icons.sd_card_rounded),
          ),
          1
      ),
      Page(
          InventoryGlobalPage(),
          BottomNavigationBarItem(
            label: 'Global',
            icon: Icon(Icons.storage_rounded),
          ),
          2
      ),
      Page(
          AccountPage(),
          BottomNavigationBarItem(
            label: 'Accounts',
            icon: Icon(Icons.group_rounded),
          ),
          3
      ),
      Page(
          widget.account.isAnon ? GuessProfilePage() : ProfilePage(),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.account_circle_rounded),
          ),
          1
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account.isAnon ? null : Provider.of<AccountData>(context);

    final theme = Theme.of(context);
    final pages = getPages(widget.account.isAnon ? 'GUESS' : account.accountType);
    final tabs = getTabs(widget.account.isAnon ? 'GUESS' : account.accountType);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          currentIndex: _currentIndex,
          onTap: (value) => setState(() => _currentIndex = value),
          items: tabs,
        ),
        body: Container(
          child: pages[_currentIndex]
        )
      ),
    );
  }
}

class Page {
  Widget page;
  BottomNavigationBarItem tab;
  int accessLevel;

  Page(this.page, this.tab, this.accessLevel);
}
