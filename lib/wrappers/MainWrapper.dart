import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:mech_track/models/Account.dart';

import 'package:mech_track/screens/mainpages/AccountPage.dart';
import 'package:mech_track/screens/mainpages/DataPage.dart';
import 'package:mech_track/screens/mainpages/InventoryGlobalPage.dart';
import 'package:mech_track/screens/mainpages/InventoryLocalPage.dart';
import 'package:mech_track/screens/mainpages/ProfilePage.dart';
import 'package:provider/provider.dart';

class MainWrapper extends StatefulWidget {

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  List<Page> pages = [
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
      ProfilePage(),
      BottomNavigationBarItem(
        label: 'Profile',
        icon: Icon(Icons.account_circle_rounded),
      ),
      2
    ),
  ];

  Future<String> scanCode() async {
    var result = await BarcodeScanner.scan();
    return result.rawContent;
  }

  String getAccountType(Account account, String type) {
    if (account.isAnon)
      return 'GUESS';
    if (!account.isAnon && type == "ADMIN")
      return 'ADMIN';
    if (!account.isAnon && type == "EMPLOYEE")
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
  Widget build(BuildContext context) {
    final account = Provider.of<Account>(context);
    final theme = Theme.of(context);
    final pages = getPages(getAccountType(account, 'ADMIN'));
    final tabs = getTabs(getAccountType(account, 'ADMIN'));

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
