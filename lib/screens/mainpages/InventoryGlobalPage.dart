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
  String category = 'Part No.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = Provider.of<List<Part>>(context);
    final TextEditingController _controller = TextEditingController();

    void categoryHandler(String newCat) {
      setState(() => category = newCat);
    }

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
            PartSearchBar(controller: _controller, categoryHandler: categoryHandler, category: category, context: context),
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
