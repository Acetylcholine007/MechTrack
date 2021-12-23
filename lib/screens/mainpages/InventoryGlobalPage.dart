import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';

import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/components/PartSearchBar.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/screens/subpages/PartEditor.dart';
import 'package:mech_track/screens/subpages/PartViewer.dart';
import 'package:provider/provider.dart';

class InventoryGlobalPage extends StatefulWidget {
  @override
  _InventoryGlobalPageState createState() => _InventoryGlobalPageState();
}

class _InventoryGlobalPageState extends State<InventoryGlobalPage> {
  String category = 'Part ID';
  String query = '';

  List<Part> filterHandler (List<Part> parts) {
    if(query != "") {
      switch (category) {
        case 'Part ID':
          return parts
              .where((part) =>
                  part.pid.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Asset Account Code':
          return parts
              .where((part) => part.assetAccountCode
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Process':
          return parts
              .where((part) => part.process
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Subprocess':
          return parts
              .where((part) => part.subProcess
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Description':
          return parts
              .where((part) => part.description
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Type':
          return parts
              .where((part) =>
                  part.type.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Criticality':
          return parts
              .where((part) => part.criticality
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Status':
          return parts
              .where((part) =>
                  part.status.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Year Installed':
          return parts
              .where((part) => part.yearInstalled
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Description 2':
          return parts
              .where((part) => part.description2
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Brand':
          return parts
              .where((part) =>
                  part.brand.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Model':
          return parts
              .where((part) =>
                  part.model.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Spec 1':
          return parts
              .where((part) =>
                  part.spec1.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Spec 2':
          return parts
              .where((part) =>
                  part.spec2.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Dept':
          return parts
              .where((part) =>
                  part.dept.contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Facility':
          return parts
              .where((part) => part.facility
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Facility Type':
          return parts
              .where((part) => part.facilityType
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'SAP Facility':
          return parts
              .where((part) => part.sapFacility
                  .contains(new RegExp(query, caseSensitive: false)))
              .toList();
        case 'Critical by PM':
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
          IconButton(icon: Icon(Icons.qr_code_scanner), onPressed: () {})
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
