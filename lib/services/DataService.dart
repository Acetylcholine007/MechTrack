import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mech_track/models/CSVReadResult.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/ImportResponse.dart';
import 'package:mech_track/models/Part.dart';
import 'package:path_provider/path_provider.dart';


import 'DatabaseService.dart';
import 'LocalDatabaseService.dart';

class DataService {
  DataService._();

  static final DataService ds = DataService._();

  //HELPER METHODS
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

      Map<String, dynamic> removeIdentifier(Map<String, dynamic> fields) {
        fields.remove('itemno');
        return fields;
      }

      final input = new File(file.path).openRead();
      var fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      Map<String, String> headers = {};
      fields.removeAt(0).forEach((header) =>
      headers[header.toString()
          .replaceAll(new RegExp('[\\W_., ]+'), "")
          .toLowerCase()
      ] = header
      );

      //Item No field checker
      if(headers['itemno'] == null) throw ('No Item No. column');

      int partNoIndex = headers.keys.toList().indexOf('itemno');
      List headerKeys = headers.keys.toList();

      newFields = fields.map((row) {
        Part part = Part(
            partNo: isInteger(row[partNoIndex].toString()) ? int.parse(row[partNoIndex].toString()) : throw ('Invalid part no'),
            fields: removeIdentifier({ for (String header in headerKeys) header: row[headerKeys.indexOf(header)] })
        );
        print(part);
        return part;
      }).toList();
      return CSVReadResult(parts: newFields, headers: removeIdentifier(headers), result: 'SUCCESS');
    } else {
      return CSVReadResult(parts: [], headers: {}, result: 'EMPTY');
    }
  }

  List<List<String>> partListTransform(List<Part> parts, Field header) {
    List<List<String>> newParts = [header.fields.values.toList()];
    parts.forEach((part) {
      print(List<String>.from(part.fields.values.map((value) => value.toString()).toList()));
      newParts.add(List<String>.from(part.fields.values.map((value) => value.toString()).toList()));
    });
    print(newParts);
    return newParts;
  }

  //SERVICE METHODS
  void syncDatabase(BuildContext context, Function loadingHandler, List<Part> parts, Field fields) async {
    loadingHandler(true);
    ImportResponse result;

    if(parts.isNotEmpty)
      result = await LocalDatabaseService.db
          .importParts(parts, fields.fields);
    else result = ImportResponse(result: 'SUCCESS');
    loadingHandler(false);

    if(result.result == 'SUCCESS') {
      final snackBar = SnackBar(
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        content: Text('Local Database synced to Firebase'),
        action: SnackBarAction(label: 'OK',
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
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
  }

  void localCSVImport(BuildContext context, Function loadingHandler) async {
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
      loadingHandler(true);
      result = await LocalDatabaseService.db.importParts(parts, readResult.headers);
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
                    loadingHandler(true);
                    Navigator.pop(newContext);
                    ImportResponse newResult =
                    await LocalDatabaseService.db.importParts(result.parts, readResult.headers);

                    loadingHandler(false);
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
                    loadingHandler(true);
                    Navigator.pop(newContext);
                    ImportResponse newResult =
                    await LocalDatabaseService.db.importParts(result.parts, readResult.headers);

                    loadingHandler(false);
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
    loadingHandler(false);
  }

  void globalCSVImport(BuildContext context, Function loadingHandler) async {
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
      loadingHandler(true);
      result = await DatabaseService.db.importParts(parts, readResult.headers);
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
                    loadingHandler(true);
                    Navigator.pop(newContext);
                    ImportResponse newResult =
                    await DatabaseService.db.importParts(result.parts, readResult.headers);

                    loadingHandler(false);
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
                    loadingHandler(true);
                    Navigator.pop(newContext);
                    ImportResponse newResult =
                    await DatabaseService.db.importParts(result.parts, readResult.headers);

                    loadingHandler(false);
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
    loadingHandler(false);
  }

  void partCSVExport(BuildContext context, Function loadingHandler, List<Part> parts, Field fields, bool isLocal) async {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text('${isLocal ? 'Local' : 'Global'} Database CSV saved'),
      action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
    );

    final snackBar2 = SnackBar(
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text('Save cancelled'),
      action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
    );

    try {
      loadingHandler(true);
      String csvData = ListToCsvConverter().convert(partListTransform(parts, fields));
      String directory  = (await getTemporaryDirectory()).path;
      final path = "$directory/csv-${DateTime.now()}.csv";
      final File file = File(path);
      File csvFile = await file.writeAsString(csvData);

      if(csvFile != null) {
        final params = SaveFileDialogParams(sourceFilePath: csvFile.path);
        final filePath = await FlutterFileDialog.saveFile(params: params);
        if(filePath != null)
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        else {
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        }
      } else {
        throw ("Failed to write data");
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('${isLocal ? 'Local' : 'Global'} CSV Export'),
            content: Text(e.toString()),
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
    } finally {
      loadingHandler(false);
    }
  }
}