import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:mech_track/BLoCs/LocalDatabaseBloc.dart';
import 'package:mech_track/components/Loading.dart';
import 'package:mech_track/components/NoPart.dart';
import 'package:mech_track/components/NoPartLocal.dart';

import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/components/PartSearchBar.dart';
import 'package:mech_track/models/LocalDBDataPack.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/screens/subpages/PartEditor.dart';
import 'package:mech_track/screens/subpages/PartViewer.dart';

class InventoryLocalPage extends StatefulWidget {
  @override
  _InventoryLocalPageState createState() => _InventoryLocalPageState();
}

class _InventoryLocalPageState extends State<InventoryLocalPage> {
  String category = 'pid';
  String query = '';
  PartsBloc bloc;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bloc = PartsBloc(query, category);

    void searchHandler(String val) {
      return setState(() => query = val);
    }

    void categoryHandler(String newCat) {
      setState(() => category = newCat);
    }

    return StreamBuilder<LocalDBDataPack>(
      stream: bloc.localParts,
      builder: (BuildContext context, AsyncSnapshot<LocalDBDataPack> snapshot) {
        if(snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Local Database'),
              actions: [
                IconButton(icon: Icon(Icons.qr_code_scanner), onPressed: () async {
                  var result = await BarcodeScanner.scan();
                  List<String> data = result.rawContent.contains('<=MechTrack=>') ? result.rawContent.split('<=MechTrack=>') : null;
                  if(data != null && data[0] == data[1]) {
                    Part part = await bloc.getPart(data[0]);
                    if(part != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            PartViewer(part: part, isLocal: true, bloc: bloc))
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
                  MaterialPageRoute(builder: (context) => PartEditor(isNew: true, isLocal: true, bloc: bloc)),
                ),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
              ),
              child: snapshot.data != null ? !snapshot.data.hasRecords ? NoPartLocal() :Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PartSearchBar(categoryHandler: categoryHandler, searchHandler: searchHandler, category: category, context: context),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.parts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () =>
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PartViewer(
                                part: snapshot.data.parts[index],
                                isLocal: true,
                                bloc: bloc)
                              ),
                            ),
                          child: PartListTile(
                            key: Key(index.toString()),
                            name: snapshot.data.parts[index].pid,
                            caption: snapshot.data.parts[index].assetAccountCode,
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
