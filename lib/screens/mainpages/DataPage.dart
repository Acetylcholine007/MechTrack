import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/AccountData.dart';
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

  String calculateHash(String data) {
    var bytes = utf8.encode(data); // data being hashed
    var digest = sha1.convert(bytes);
    print("Digest as hex string: $digest");
    print(digest.toString());
    return digest.toString();
  }

  Future<List<Part>> csvReader() async {
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
        headers.indexOf('assetaccountcode'),
        headers.indexOf('process'),
        headers.indexOf('subprocess'),
        headers.indexOf('description'),
        headers.indexOf('type'),
        headers.indexOf('criticality'),
        headers.indexOf('status'),
        headers.indexOf('yearinstalled'),
        headers.indexOf('description2'),
        headers.indexOf('brand'),
        headers.indexOf('model'),
        headers.indexOf('spec1'),
        headers.indexOf('spec2'),
        headers.indexOf('dept'),
        headers.indexOf('facility'),
        headers.indexOf('facilitytype'),
        headers.indexOf('sapfacility'),
        headers.indexOf('criticalbypm'),
      ];

      newFields = fields.map((row) {
        Part part = Part(
          pid: '',
          partNo:
              indices[0] != -1 ? row[indices[0]].toString() : '',
          assetAccountCode:
              indices[1] != -1 ? row[indices[1]].toString() : '',
          process: indices[2] != -1 ? row[indices[2]].toString() : '',
          subProcess:
              indices[3] != -1 ? row[indices[3]].toString() : '',
          description:
              indices[4] != -1 ? row[indices[4]].toString() : '',
          type: indices[5] != -1 ? row[indices[5]].toString() : '',
          criticality:
              indices[6] != -1 ? row[indices[6]].toString() : '',
          status: indices[7] != -1 ? row[indices[7]].toString() : '',
          yearInstalled:
              indices[8] != -1 ? row[indices[8]].toString() : '',
          description2:
              indices[9] != -1 ? row[indices[9]].toString() : '',
          brand: indices[10] != -1 ? row[indices[10]].toString() : '',
          model: indices[11] != -1 ? row[indices[11]].toString() : '',
          spec1: indices[12] != -1 ? row[indices[12]].toString() : '',
          spec2: indices[13] != -1 ? row[indices[13]].toString() : '',
          dept: indices[14] != -1 ? row[indices[14]].toString() : '',
          facility:
              indices[15] != -1 ? row[indices[15]].toString() : '',
          facilityType:
              indices[16] != -1 ? row[indices[16]].toString() : '',
          sapFacility:
              indices[17] != -1 ? row[indices[17]].toString() : '',
          criticalByPM:
              indices[18] != -1 ? row[indices[18]].toString() : '',
        );
        part.pid = calculateHash(part.toString());
        return part;
      }).toList();
      return newFields;
    }
    return null;
  }

  void localCSVImport() async {
    String result = "";
    List<Part> parts;
    try {
      parts = await csvReader();
      result = parts != null ? 'VALID' : 'EMPTY';
    } catch (error) {
      result = error.toString();
    }
    if(result == 'VALID') {
      setState(() => isLocalImporting = true);
      result = await LocalDatabaseService.db.importParts(parts);
      setState(() => isLocalImporting = false);
    }

    if(result == 'SUCCESS') {
      final snackBar = SnackBar(
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        content: Text('CSV imported to Local Database'),
        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if(result == 'EMPTY') {} else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Local CSV Import'),
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
  }

  void globalCSVImport() async {
    String result = "";
    List<Part> parts;
    try {
      parts = await csvReader();
      result = parts != null ? 'VALID' : 'EMPTY';
    } catch(error) {
      result = error.toString();
    }
    if(result == 'VALID') {
      setState(() => isGlobalImporting = true);
      result = await DatabaseService.db.importParts(parts);
      setState(() => isGlobalImporting = false);
    }

    if(result == 'SUCCESS') {
      final snackBar = SnackBar(
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        content: Text('CSV imported to Global Database'),
        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if(result == 'EMPTY') {} else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Global CSV Import'),
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
              setState(() => isSyncing = true);
              String result = await LocalDatabaseService.db.importParts(parts);
              setState(() => isSyncing = false);

              if(result == 'SUCCESS') {
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