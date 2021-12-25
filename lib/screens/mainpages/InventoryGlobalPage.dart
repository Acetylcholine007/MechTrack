import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/components/NoPart.dart';

import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/components/PartSearchBar.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/screens/subpages/PartEditor.dart';
import 'package:mech_track/screens/subpages/PartViewer.dart';
import 'package:mech_track/services/DatabaseService.dart';
import 'package:provider/provider.dart';

class InventoryGlobalPage extends StatefulWidget {
  @override
  _InventoryGlobalPageState createState() => _InventoryGlobalPageState();
}

class _InventoryGlobalPageState extends State<InventoryGlobalPage> {
  String category = 'pid';
  String query = '';

  List<Part> filterHandler (List<Part> parts) {
    if(query != "") {
      switch (category) {
        case 'pid':
          return parts
              .where((part) =>
                  part.pid.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'assetAccountCode':
          return parts
              .where((part) => part.assetAccountCode
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'process':
          return parts
              .where((part) => part.process
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'subProcess':
          return parts
              .where((part) => part.subProcess
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'description':
          return parts
              .where((part) => part.description
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'type':
          return parts
              .where((part) =>
                  part.type.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'criticality':
          return parts
              .where((part) => part.criticality
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'status':
          return parts
              .where((part) =>
                  part.status.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'yearInstalled':
          return parts
              .where((part) => part.yearInstalled
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'description2':
          return parts
              .where((part) => part.description2
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'brand':
          return parts
              .where((part) =>
                  part.brand.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'model':
          return parts
              .where((part) =>
                  part.model.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'spec1':
          return parts
              .where((part) =>
                  part.spec1.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'spec2':
          return parts
              .where((part) =>
                  part.spec2.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'dept':
          return parts
              .where((part) =>
                  part.dept.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'facility':
          return parts
              .where((part) => part.facility
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'facilityType':
          return parts
              .where((part) => part.facilityType
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'sapFacility':
          return parts
              .where((part) => part.sapFacility
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'criticalByPM':
          return parts
              .where((part) => part.criticalByPM
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        default:
          return parts;
      }
    } else {
      return parts;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Part> parts = Provider.of<List<Part>>(context);
    final account = Provider.of<Account>(context);
    final DatabaseService _database = DatabaseService(uid: account.uid);

    void searchHandler(String val) {
      return setState(() => query = val);
    }

    void categoryHandler(String newCat) {
      return setState(() => category = newCat);
    }

    parts = filterHandler(parts);

    return parts != null ? Scaffold(
      appBar: AppBar(
        title: Text('Global Database'),
        actions: [
          IconButton(icon: Icon(Icons.qr_code_scanner), onPressed: () async {
            var result = await BarcodeScanner.scan();
            List<String> data = result.rawContent.contains('<=MechTrack=>') ? result.rawContent.split('<=MechTrack=>') : null;
            if(data != null && data[0] == data[1]) {
              Part part = await _database.getPart(data[0]);
              if(part != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                    PartViewer(part: part, isLocal: false))
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoPart(isValid: true))
                );
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoPart(isValid: false))
              );
            }
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PartEditor(isNew: true, isLocal: false,)),
          ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PartSearchBar(categoryHandler: categoryHandler, searchHandler: searchHandler, category: category, context: context),
            Expanded(
              child: ListView.builder(
                itemCount: parts.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PartViewer(part: parts[index], isLocal: false)),
                        ),
                    child: PartListTile(
                      key: Key(index.toString()),
                      name: parts[index].pid,
                      caption: parts[index].assetAccountCode,
                      index: index
                    ),
                  );
                }
              )
            )
          ],
        ),
      ),
    ) : Loading('Loading Parts');
  }
}
