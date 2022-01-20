import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:mech_track/BLoCs/LocalDatabaseBloc.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/components/MultiSearchOverlay.dart';
import 'package:mech_track/components/NoPart.dart';
import 'package:mech_track/components/NoPartLocal.dart';

import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/components/PartSearchBar.dart';
import 'package:mech_track/components/TabulatedPartList.dart';
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
  int catIndex1 = 0;
  int catIndex2 = 0;
  String query1 = '';
  String query2 = '';
  PartsBloc bloc;
  bool isSingleSearch = true;
  bool isOverlayOpen = false;
  Map<String, String> queries = {};

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
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bloc = PartsBloc('', 'partNo', '', 'partNo');

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

    void multiQueryHandler(Map<String, String> queries) {
      setState(() {
        this.queries = queries;
        isOverlayOpen = false;
      });
    }

    return StreamBuilder<LocalDBDataPack>(
      stream: bloc.localParts,
      builder: (BuildContext context, AsyncSnapshot<LocalDBDataPack> snapshot) {
        if(snapshot.hasData) {
          List<Part> parts = filterHandler(snapshot.data.parts, snapshot.data.fields.fields.keys.toList());

          List<String> fieldKeys = [];
          String titleKey = '';
          String captionKey = '';
          if(snapshot.data.fields.fields.isNotEmpty) {
            fieldKeys = snapshot.data.fields.fields.keys.toList();
            titleKey = fieldKeys[fieldKeys.length >= 1 ? 1 : 0];
            captionKey = fieldKeys[0];
          }

          void viewPart(Part part) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PartViewer(
                  part: part,
                  isLocal: true,
                  bloc: bloc,
                  fields: snapshot.data.fields)
              ),
            );
          }

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
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) =>
                          //         PartViewer(part: part,
                          //             isLocal: true,
                          //             bloc: bloc,
                          //             fields: snapshot.data.fields))
                          // );
                          viewPart(part);
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
            floatingActionButton: snapshot.data.fields.fields.isEmpty ? null : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: (!(isSingleSearch || isOverlayOpen) ? <Widget>[
                FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.search_rounded),
                  onPressed: () => setState(() => isOverlayOpen = true),
                ),
                SizedBox(height: 10)] : <Widget>[]) + (isOverlayOpen ? [] : [
                FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.add),
                  onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PartCreator(isLocal: true, bloc: bloc, fields: snapshot.data.fields)),
                      ),
                ),
              ]),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
              ),
              child: snapshot.data != null ? !snapshot.data.hasRecords ? NoPartLocal() :
              isSingleSearch ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[(isSingleSearch ?
                  PartSearchBar(
                    categoryHandler: categoryHandler1,
                    searchHandler: searchHandler1,
                    catIndex: catIndex1,
                    context: context,
                    fields: snapshot.data.fields,
                  ) : TwoPartSearchBar(
                    categoryHandler1: categoryHandler1,
                    searchHandler1: searchHandler1,
                    catIndex1: catIndex1,
                    categoryHandler2: categoryHandler2,
                    searchHandler2: searchHandler2,
                    catIndex2: catIndex2,
                    context: context,
                    fields: snapshot.data.fields,
                  ))] + <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: parts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => viewPart(parts[index]),
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => PartViewer(
                            //     part: parts[index],
                            //     isLocal: true,
                            //     bloc: bloc,
                            //     fields: snapshot.data.fields)
                            //   ),
                            // ),
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
              ) : Stack(
                children: <Widget>[
                  TabulatedPartList(
                    parts: parts,
                    fields: snapshot.data.fields,
                    columns: [fieldKeys[0], fieldKeys[1], ...queries.keys.toList()],
                    viewPart: viewPart
                  ),
                ] + (isOverlayOpen ? [
                  MultiSearchOverlay(fields: snapshot.data.fields, queries: queries, multiQueryHandler: multiQueryHandler)
                ] : []),
              )
                  : Center(child: Text('No Parts')),
            ),
          );
        } else {
          return Loading('Loading Local Parts');
        }
      },
    );
  }
}
