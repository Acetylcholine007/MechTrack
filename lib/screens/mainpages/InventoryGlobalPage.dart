import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/components/NoPart.dart';
import 'package:mech_track/components/NoPartGlobal.dart';

import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/components/PartSearchBar.dart';
import 'package:mech_track/components/TabulatedPartList.dart';
import 'package:mech_track/components/TwoPartSearchBar.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/screens/subpages/PartCreator.dart';
import 'package:mech_track/screens/subpages/PartViewer.dart';
import 'package:mech_track/services/DatabaseService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class InventoryGlobalPage extends StatefulWidget {
  @override
  _InventoryGlobalPageState createState() => _InventoryGlobalPageState();
}

class _InventoryGlobalPageState extends State<InventoryGlobalPage> {
  int catIndex1 = 0;
  int catIndex2 = 0;
  String query1 = '';
  String query2 = '';
  bool isSingleSearch = true;

  List<Part> filterHandler (List<Part> parts, List fieldKeys) {
    if(isSingleSearch) {
      return parts.where((part) {
        return query1 == "" ? true :
        part.fields[fieldKeys[catIndex1]].toString().startsWith(new RegExp(query1, caseSensitive: false));
      }).toList();
    } else {
      return parts.where((part) {
        bool con1 = query1 == "" ? true :
        part.fields[fieldKeys[catIndex1]].toString().startsWith(new RegExp(query1, caseSensitive: false));
        bool con2 = query2 == "" ? true :
        part.fields[fieldKeys[catIndex2]].toString().startsWith(new RegExp(query2, caseSensitive: false));
        return con1 && con2;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authUser = Provider.of<Account>(context);
    final account = authUser.isAnon ? null : Provider.of<AccountData>(context);
    final fields = authUser.isAnon ? null : Provider.of<Field>(context);
    List<Part> parts = Provider.of<List<Part>>(context);

    List<String> fieldKeys = [];
    String titleKey = '';
    String captionKey = '';
    if(fields.fields.isNotEmpty) {
      fieldKeys = fields.fields.keys.toList();
      titleKey = fieldKeys[fieldKeys.length >= 1 ? 1 : 0];
      captionKey = fieldKeys[0];
    }

    void searchHandler1(String val) {
      return setState(() => query1 = val);
    }

    void categoryHandler1(int newCat) {
      setState(() => catIndex1 = newCat);
    }

    void searchHandler2(String val) {
      return setState(() => query2 = val);
    }

    void categoryHandler2(int newCat) {
      setState(() => catIndex2 = newCat);
    }

    parts = filterHandler(parts, fields.fields.keys.toList());

    return parts != null ? Scaffold(
      appBar: AppBar(
        title: Text('Global Database'),
        actions: [
          IconButton(onPressed: () => setState(() => isSingleSearch = !isSingleSearch), icon: Icon(Icons.find_replace_rounded)),
          IconButton(icon: Icon(Icons.qr_code_scanner), onPressed: () async {
            var status = await Permission.camera.status;

            if (status.isDenied) {
              await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Scan QR Code'),
                    content: Text('Scanning QR code requires allowing the app to use the phone\'s camera.'),
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
              await Permission.camera.request();
              status = await Permission.camera.status;
            }

            if(status.isGranted) {
              var result = await BarcodeScanner.scan();
              if (result.rawContent.isNotEmpty) {
                List<String> data =
                result.rawContent.contains('<=MechTrack=>')
                    ? result.rawContent.split('<=MechTrack=>')
                    : null;
                if (data != null && data[0] == data[1]) {
                  Part part =
                  await DatabaseService.db.getPart(data[0]);
                  if (part != null) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                        PartViewer(
                          part: part,
                          isLocal: false,
                          account: account,
                          fields: fields)));
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
            } else {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Scan QR Code'),
                    content: Text('Failed to scan QR code'),
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
          })
        ],
      ),
      floatingActionButton: account.accountType == 'ADMIN' && fields.fields.isNotEmpty ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: (isSingleSearch ? <Widget>[] : <Widget>[
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          SizedBox(height: 10),
        ]) + <Widget>[
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.add),
            onPressed: () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PartCreator(isLocal: false, account: account, fields: fields)),
              ),
          ),
        ],
      ) : null,
      body: Provider.of<List<Part>>(context).isEmpty ? NoPartGlobal() : Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
        ),
        child: isSingleSearch ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[(isSingleSearch ?
          PartSearchBar(
            categoryHandler: categoryHandler1,
            searchHandler: searchHandler1,
            catIndex: catIndex1,
            context: context,
            fields: fields,
          ) : TwoPartSearchBar(
            categoryHandler1: categoryHandler1,
            searchHandler1: searchHandler1,
            catIndex1: catIndex1,
            categoryHandler2: categoryHandler2,
            searchHandler2: searchHandler2,
            catIndex2: catIndex2,
            context: context,
            fields: fields,
          ))] + <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: parts.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              PartViewer(part: parts[index], isLocal: false, account: account, fields: fields,)),
                        ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: theme.backgroundColor.withOpacity(0.15),
                      child: PartListTile(
                        key: Key(index.toString()),
                        name: parts[index].fields[titleKey].toString(),
                        caption: parts[index].fields[captionKey].toString(),
                        index: index
                      ),
                    ),
                  );
                }
              )
            )
          ],
        ) : TabulatedPartList(parts: parts, fields: fields),
      ),
    ) : Loading('Loading Parts');
  }
}
