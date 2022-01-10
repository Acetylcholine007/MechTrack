import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/CSVReadResult.dart';
import 'package:mech_track/models/ImportResponse.dart';
import 'package:mech_track/services/DatabaseService.dart';
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

  bool isInteger(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  Future<CSVReadResult> csvReader() async {
    List<Part> newFields;
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      final input = new File(file.path).openRead();
      var fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

      List<String> headers = fields.removeAt(0).map((header) =>
          header.toString().replaceAll(new RegExp('[\\W_., ]+'), "")
              .toLowerCase()).toList();

      List<int> indices = [
        headers.indexOf('itemno'),
      ];

      newFields = fields.map((row) {
        Part part = Part(
          partNo:
              indices[0] != -1 ?
              isInteger(row[headers.indexOf('itemno')].toString()) ?
              int.parse(row[headers.indexOf('itemno')].toString()) : null : null,
          fields: { for (String header in headers) header: row[headers.indexOf(header)] }
        );
        print(part);
        return part;
      }).toList();
      return CSVReadResult(parts: newFields, headers: headers);
    }
    return null;
  }

  void localCSVImport() async {
    ImportResponse result = ImportResponse();
    CSVReadResult readResult;
    List<Part> parts;
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text('CSV imported to Local Database'),
      action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
    );

    try {
      readResult = await csvReader();
      parts = readResult.parts;
      result.result = parts != null ? 'VALID' : 'EMPTY';
    } catch (error) {
      result.result = error.toString();
    }

    if(result.result == 'VALID') {
      setState(() => isLocalImporting = true);
      result = await LocalDatabaseService.db.importParts(parts, 'SAFE', readResult.headers);
    }

    if(result.result == 'SUCCESS' && result.parts.isEmpty && result.invalidIdParts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (result.result == 'SUCCESS' && result.parts.isEmpty && result.invalidIdParts.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Local CSV Import'),
            content: Text('Parts with non integer or missing part number were omitted.'),
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
    } else if (result.result == 'EMPTY') {
    } else if (result.result == 'SUCCESS' && result.parts.isNotEmpty) {
      showDialog(
          context: context,
          builder: (newContext) => AlertDialog(
            title: Text('Local CSV Import'),
            content: Text('${result.invalidIdParts.isNotEmpty ?
              'Parts with invalid or missing part number were omitted. ' : ''}'
              'Existing parts found. Choose what to do with existing parts.'),
            actions: [
              TextButton(
                  onPressed: () async {
                    setState(() => isLocalImporting = true);
                    Navigator.pop(newContext);
                    ImportResponse newResult =
                    await LocalDatabaseService.db.importParts(result.parts, 'APPEND', readResult.headers);

                    setState(() => isLocalImporting = false);
                    if(newResult.result == 'SUCCESS') {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Local CSV Import'),
                            content: Text(newResult.result),
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
                  child: Text('APPEND')
              ),
              TextButton(
                  onPressed: () async {
                    setState(() => isLocalImporting = true);
                    Navigator.pop(newContext);
                    ImportResponse newResult =
                    await LocalDatabaseService.db.importParts(result.parts, 'REPLACE', readResult.headers);

                    setState(() => isLocalImporting = false);
                    if(newResult.result == 'SUCCESS') {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Local CSV Import'),
                            content: Text(newResult.result),
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
                  child: Text('REPLACE')
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(newContext);
                  },
                  child: Text('SKIP')
              ),
            ],
          )
      );
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Local CSV Import'),
            content: Text(result.result),
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
    setState(() => isLocalImporting = false);
  }

  void globalCSVImport() async {
    ImportResponse result = ImportResponse();
    CSVReadResult readResult;
    List<Part> parts;
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text('CSV imported to Global Database'),
      action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
    );

    try {
      readResult = await csvReader();
      parts = readResult.parts;
      result.result = parts != null ? 'VALID' : 'EMPTY';
    } catch(error) {
      result.result = error.toString();
    }
    if(result.result == 'VALID') {
      setState(() => isGlobalImporting = true);
      result = await DatabaseService.db.importParts(parts, 'SAFE');
    }

    if(result.result == 'SUCCESS' && result.parts.isEmpty && result.invalidIdParts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (result.result == 'SUCCESS' && result.parts.isEmpty && result.invalidIdParts.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Global CSV Import'),
            content: Text('Parts with non integer or missing part number were omitted.'),
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
    } else if(result.result == 'EMPTY') {
    } else if (result.result == 'SUCCESS' && result.parts.isNotEmpty) {
      showDialog(
          context: context,
          builder: (newContext) => AlertDialog(
            title: Text('Global CSV Import'),
            content: Text('${result.invalidIdParts.isNotEmpty ?
              'Parts with invalid or missing part number were omitted. ' : ''}'
              'Existing parts found. Choose what to do with existing parts.'),
            actions: [
              TextButton(
                  onPressed: () async {
                    setState(() => isGlobalImporting = true);
                    Navigator.pop(newContext);
                    ImportResponse newResult =
                    await DatabaseService.db.importParts(result.parts, 'APPEND');

                    setState(() => isGlobalImporting = false);
                    if(newResult.result == 'SUCCESS') {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Global CSV Import'),
                            content: Text(newResult.result),
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
                  child: Text('APPEND')
              ),
              TextButton(
                  onPressed: () async {
                    setState(() => isGlobalImporting = true);
                    Navigator.pop(newContext);
                    ImportResponse newResult =
                    await DatabaseService.db.importParts(result.parts, 'REPLACE');

                    setState(() => isGlobalImporting = false);
                    if(newResult.result == 'SUCCESS') {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Global CSV Import'),
                            content: Text(newResult.result),
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
                  child: Text('REPLACE')
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(newContext);
                  },
                  child: Text('SKIP')
              ),
            ],
          )
      );
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Global CSV Import'),
            content: Text(result.result),
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
    setState(() => isGlobalImporting = false);
  }

  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Account>(context);
    List<Part> parts = authUser.isAnon ? null : Provider.of<List<Part>>(context);
    final account = authUser.isAnon ? null : Provider.of<AccountData>(context);

    List<OperatorWidget> operatorWidgets = [
      OperatorWidget(
        ElevatedButton(
          onPressed: localCSVImport,
          child: Text('Import CSV for Local Database'),
          style: buttonDecoration,
        ), 1
      ),
      OperatorWidget(
          ElevatedButton(
            onPressed: globalCSVImport,
            child: Text('Import CSV for Global Database'),
            style: buttonDecoration,
          ), 3
      ),
      OperatorWidget(
          ElevatedButton(
            onPressed: () async {
              ImportResponse result;
              setState(() => isSyncing = true);
              if(parts.isNotEmpty)
                result = await LocalDatabaseService.db
                    .importParts(parts, 'REPLACE', parts[0].fields.keys.toList());
              else result = ImportResponse(result: 'SUCCESS');
              setState(() => isSyncing = false);

              if(result.result == 'SUCCESS') {
                final snackBar = SnackBar(
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  content: Text('Local Database synced to Firebase'),
                  action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Local Database Sync'),
                      content: Text(result.result),
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
            child: Text('Sync Local Database from Firebase'),
            style: buttonDecoration,
          ), 2
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