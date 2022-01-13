import 'package:flutter/material.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/services/DataService.dart';
import 'package:provider/provider.dart';

import 'package:mech_track/models/Part.dart';
import 'package:mech_track/shared/decorations.dart';
import 'package:mech_track/services/LocalDatabaseService.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  bool isSyncing = false;
  bool isGlobalImporting = false;
  bool isLocalImporting = false;
  bool isGlobalExporting = false;
  bool isLocalExporting = false;

  void syncLoadingHandler(bool status) {
    setState(() => isSyncing = status);
  }

  void localImportLoadingHandler(bool status) {
    setState(() => isLocalImporting = status);
  }

  void globalImportLoadingHandler(bool status) {
    setState(() => isGlobalImporting = status);
  }

  void localExportLoadingHandler(bool status) {
    setState(() => isLocalExporting = status);
  }

  void globalExportLoadingHandler(bool status) {
    setState(() => isGlobalExporting = status);
  }

  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Account>(context);
    final theme = Theme.of(context);
    List<Part> parts = authUser.isAnon ? null : Provider.of<List<Part>>(context);
    Field fields = authUser.isAnon ? null : Provider.of<Field>(context);
    final account = authUser.isAnon ? null : Provider.of<AccountData>(context);

    List<OperatorWidget> operatorWidgets = [
      OperatorWidget(
        ElevatedButton(
          onPressed: () => DataService.ds.localCSVImport(context, localImportLoadingHandler),
          child: Text('Import CSV for Local Database'),
          style: buttonDecoration,
        ), 1
      ),
      OperatorWidget(
          ElevatedButton(
            onPressed: () => DataService.ds.globalCSVImport(context, globalImportLoadingHandler),
            child: Text('Import CSV for Global Database'),
            style: buttonDecoration,
          ), 3
      ),
      OperatorWidget(
          ElevatedButton(
            onPressed: () => DataService.ds.syncDatabase(context, syncLoadingHandler, parts, fields),
            child: Text('Sync Local DB from Global DB'),
            style: buttonDecoration,
          ), 2
      ),
      OperatorWidget(
          Divider(height: 12, thickness: 1, color: theme.primaryColor), 1
      ),
      OperatorWidget(
          ElevatedButton(
            onPressed: () async {
              DataService.ds.partCSVExport(context, syncLoadingHandler,
                (await LocalDatabaseService.db.getParts('', 'partNo', '', 'partNo')).parts,
                fields, true);
            },
            child: Text('Export Local Database to CSV'),
            style: buttonDecoration,
          ), 1
      ),
      OperatorWidget(
          ElevatedButton(
            onPressed: () => DataService.ds.partCSVExport(context, syncLoadingHandler, parts, fields, false),
            child: Text('Export Global Database to CSV'),
            style: buttonDecoration,
          ), 3
      ),
    ];

    List<Widget> getOperators(String accountType) {
      if(accountType == 'GUESS')
        return operatorWidgets
            .where((operator) => operator.accessLevel <= 1)
            .map((operator) => operator.operator)
            .toList();
      if(accountType == 'EMPLOYEE')
        return operatorWidgets
            .where((operator) => operator.accessLevel <= 2)
            .map((operator) => operator.operator)
            .toList();
      if(accountType == 'ADMIN')
        return operatorWidgets
            .where((operator) => operator.accessLevel <= 3)
            .map((operator) => operator.operator)
            .toList();
      return [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Management Page'),
        bottom: isSyncing || isGlobalImporting || isLocalImporting ? PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: LinearProgressIndicator(backgroundColor: Colors.white)
        ) : null,
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
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/logoFull.gif'),
                width: 200,
                fit: BoxFit.cover
              ),
              Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getOperators(
                authUser.isAnon ? 'GUESS'
                  : account != null && account.accountType == 'ADMIN' ? 'ADMIN'
                  : 'EMPLOYEE')
              )
            ],
          ),
        )
      ),
    );
  }
}

class OperatorWidget {
  Widget operator;
  int accessLevel;

  OperatorWidget(this.operator, this.accessLevel);
}