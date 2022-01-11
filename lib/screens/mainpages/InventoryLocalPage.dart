import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:mech_track/BLoCs/LocalDatabaseBloc.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/components/NoPart.dart';
import 'package:mech_track/components/NoPartLocal.dart';

import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/components/PartSearchBar.dart';
import 'package:mech_track/components/TwoPartSearchBar.dart';
import 'package:mech_track/models/LocalDBDataPack.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/screens/subpages/PartCreator.dart';
import 'package:mech_track/screens/subpages/PartViewer.dart';
import 'package:permission_handler/permission_handler.dart';

class InventoryLocalPage extends StatefulWidget {
  @override
  _InventoryLocalPageState createState() => _InventoryLocalPageState();
}

class _InventoryLocalPageState extends State<InventoryLocalPage> {
  String category1 = 'partNo';
  String category2 = 'partNo';
  String query1 = '';
  String query2 = '';
  PartsBloc bloc;
  bool isSingleSearch = true;

  List<Part> filterHandler (List<Part> parts) {
    if(isSingleSearch) {
      return parts.where((part) {
        return query1 == "" ? true : category1 == 'partNo' ?
        part.partNo.toString().startsWith(new RegExp(query1, caseSensitive: false)) :
        part.fields[category1].toString().contains(new RegExp(query1, caseSensitive: false));
      }).toList();
    } else {
      return parts.where((part) {
        bool con1 = query1 == "" ? true : category1 == 'partNo' ?
        part.partNo.toString().startsWith(new RegExp(query1, caseSensitive: false)) :
        part.fields[category1].toString().contains(new RegExp(query1, caseSensitive: false));
        bool con2 = query2 == "" ? true : category2 == 'partNo' ?
        part.partNo.toString().startsWith(new RegExp(query2, caseSensitive: false)) :
        part.fields[category2].toString().contains(new RegExp(query2, caseSensitive: false));
        return con1 && con2;
      }).toList();
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = PartsBloc('', 'partNo', '', 'partNo');

    void searchHandler1(String val) {
      return setState(() => query1 = val);
    }

    void categoryHandler1(String newCat) {
      setState(() => category1 = newCat);
    }

    void searchHandler2(String val) {
      return setState(() => query2 = val);
    }

    void categoryHandler2(String newCat) {
      setState(() => category2 = newCat);
    }

    return StreamBuilder<LocalDBDataPack>(
      stream: bloc.localParts,
      builder: (BuildContext context, AsyncSnapshot<LocalDBDataPack> snapshot) {
        if(snapshot.hasData) {
          List<Part> parts = filterHandler(snapshot.data.parts);

          return Scaffold(
            appBar: AppBar(
              title: Text('Local Database'),
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
                      List<String> data = result.rawContent.contains('<=MechTrack=>') ? result
                          .rawContent.split('<=MechTrack=>') : null;
                      if (data != null && data[0] == data[1]) {
                        Part part = await bloc.getPart(data[0]);
                        if (part != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  PartViewer(part: part,
                                      isLocal: true,
                                      bloc: bloc,
                                      fields: snapshot.data.fields))
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
            floatingActionButton: snapshot.data.fields.fields.isEmpty ? null : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PartCreator(isLocal: true, bloc: bloc, fields: snapshot.data.fields)),
                ),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
              ),
              child: snapshot.data != null ? !snapshot.data.hasRecords ? NoPartLocal() :Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[(isSingleSearch ?
                  PartSearchBar(
                    categoryHandler: categoryHandler1,
                    searchHandler: searchHandler1,
                    category: category1,
                    context: context,
                    fields: snapshot.data.fields,
                  ) : TwoPartSearchBar(
                    categoryHandler1: categoryHandler1,
                    searchHandler1: searchHandler1,
                    category1: category1,
                    categoryHandler2: categoryHandler2,
                    searchHandler2: searchHandler2,
                    category2: category2,
                    context: context,
                    fields: snapshot.data.fields,
                  ))] + <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: parts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () =>
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PartViewer(
                                part: parts[index],
                                isLocal: true,
                                bloc: bloc,
                                fields: snapshot.data.fields)
                              ),
                            ),
                          child: PartListTile(
                            key: Key(index.toString()),
                            name: parts[index].fields['description'],
                            caption: parts[index].partNo.toString(),
                            index: index
                          ),
                        );
                      }
                    )
                  )
                ],
              ) : Center(child: Text('No Parts')),
            ),
          );
        } else {
          return Loading('Loading Local Parts');
        }
      },
    );
  }
}
