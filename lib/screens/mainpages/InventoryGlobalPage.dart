import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/components/NoPart.dart';
import 'package:mech_track/components/NoPartGlobal.dart';

import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/components/PartSearchBar.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/screens/subpages/PartCreator.dart';
import 'package:mech_track/screens/subpages/PartViewer.dart';
import 'package:mech_track/services/DatabaseService.dart';
import 'package:provider/provider.dart';

class InventoryGlobalPage extends StatefulWidget {
  @override
  _InventoryGlobalPageState createState() => _InventoryGlobalPageState();
}

class _InventoryGlobalPageState extends State<InventoryGlobalPage> {
  String category = 'partNo';
  String query = '';

  List<Part> filterHandler (List<Part> parts) {
    if(query != "") {
      if(category == 'partNo') {
        return parts
          .where((part) =>
          part.partNo.toString().startsWith(new RegExp(query, caseSensitive: false)))
          .toList();
      } else {
        return parts
          .where((part) =>
          part.fields[category].toString().startsWith(new RegExp(query, caseSensitive: false)))
          .toList();
      }
    } else {
      return parts;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Account>(context);
    final account = authUser.isAnon ? null : Provider.of<AccountData>(context);
    final fields = authUser.isAnon ? null : Provider.of<Field>(context);
    List<Part> parts = Provider.of<List<Part>>(context);

    void searchHandler(String val) {
      return setState(() {
        query = val;
      });
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
            if(result.rawContent.isNotEmpty) {
              List<String> data =
                result.rawContent.contains('<=MechTrack=>')
                  ? result.rawContent.split('<=MechTrack=>')
                  : null;
              if (data != null && data[0] == data[1]) {
                Part part =
                    await DatabaseService.db.getPart(data[0]);
                if (part != null) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PartViewer(
                      part: part,
                      isLocal: false,
                      account: account)));
                } else {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                      NoPart(isValid: true)));
                }
              } else {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                    NoPart(isValid: false)));
              }
            }
          })
        ],
      ),
      floatingActionButton: account.accountType == 'ADMIN' && fields.fields.isNotEmpty ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PartCreator(isLocal: false, account: account, /*TODO: add fields*/)),
          ),
      ) : null,
      body: Provider.of<List<Part>>(context).isEmpty ? NoPartGlobal() : Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
        ),
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
                          MaterialPageRoute(builder: (context) => PartViewer(part: parts[index], isLocal: false, account: account)),
                        ),
                    child: PartListTile(
                      key: Key(index.toString()),
                      name: parts[index].fields['description'].toString(),
                      caption: parts[index].partNo.toString(),
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
