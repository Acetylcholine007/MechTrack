import 'package:flutter/material.dart';
import 'package:mech_track/components/Loading.dart';

import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/components/PartSearchBar.dart';
import 'package:mech_track/models/LocalPart.dart';
import 'package:mech_track/screens/subpages/PartEditor.dart';
import 'package:mech_track/screens/subpages/PartViewer.dart';
import 'package:mech_track/services/LocalDatabaseService.dart';

class InventoryLocalPage extends StatefulWidget {
  @override
  _InventoryLocalPageState createState() => _InventoryLocalPageState();
}

class _InventoryLocalPageState extends State<InventoryLocalPage> {

  String category = 'Part No.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final LocalDatabaseService _localDatabaseService = LocalDatabaseService();
    final TextEditingController _controller = TextEditingController();

    void categoryHandler(String newCat) {
      setState(() => category = newCat);
    }

    return FutureBuilder<List<LocalPart>>(
      future: _localDatabaseService.getParts(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PartEditor(isNew: true, isLocal: true)),
                ),
            ),
            body: Container(
              child: SafeArea(
                child: snapshot.data != null ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PartSearchBar(controller: _controller, categoryHandler: categoryHandler, category: category, context: context),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () =>
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PartViewer(part: snapshot.data[index].toPart(), isLocal: true)),
                              ),
                            child: PartListTile(
                              key: Key(index.toString()),
                              name: snapshot.data[index].pid,
                              caption: snapshot.data[index].assetAccountCode,
                              index: index
                            ),
                          );
                        }
                      )
                    )
                  ],
                ) : Center(child: Text('No Parts'))
              ),
            ),
          );
        } else {
          return Loading('Loading Local Parts');
        }
      },
    );
  }
}
