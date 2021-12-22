import 'package:flutter/material.dart';
import 'package:mech_track/BLoCs/LocalDatabaseBloc.dart';
import 'package:mech_track/components/Loading.dart';

import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/components/PartSearchBar.dart';
import 'package:mech_track/models/LocalPart.dart';
import 'package:mech_track/screens/subpages/PartEditor.dart';
import 'package:mech_track/screens/subpages/PartViewer.dart';

class InventoryLocalPage extends StatefulWidget {
  @override
  _InventoryLocalPageState createState() => _InventoryLocalPageState();
}

class _InventoryLocalPageState extends State<InventoryLocalPage> {
  String category = 'Part No.';
  final bloc = PartsBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController _controller = TextEditingController();

    void categoryHandler(String newCat) {
      setState(() => category = newCat);
    }

    return StreamBuilder<List<LocalPart>>(
      stream: bloc.localParts,
      builder: (BuildContext context, AsyncSnapshot<List<LocalPart>> snapshot) {
        if(snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Local Database'),
              actions: [
                IconButton(icon: Icon(Icons.qr_code_scanner), onPressed: () {})
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
                              MaterialPageRoute(builder: (context) => PartViewer(
                                part: snapshot.data[index].toPart(),
                                isLocal: true,
                                bloc: bloc)
                              ),
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
