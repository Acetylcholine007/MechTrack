import 'package:flutter/material.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/shared/decorations.dart';
import 'package:mech_track/services/LocalDatabaseService.dart';
import 'package:provider/provider.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  bool isSyncing = false;

  @override
  Widget build(BuildContext context) {
    List<Part> parts = Provider.of<List<Part>>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Management Page'),
        bottom: isSyncing ? PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: LinearProgressIndicator()
        ) : null,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/newLogoFull.gif'),
                width: 200,
                fit: BoxFit.cover
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text('Import CSV for Local Database'),
                    style: buttonDecoration,
                  ),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text('Import CSV for Global Database'),
                    style: buttonDecoration,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => isSyncing = true);
                      await LocalDatabaseService.db.importParts(parts);
                      setState(() => isSyncing = false);
                    },
                    child: Text('Sync Local Database from Firebase'),
                    style: buttonDecoration,
                  ),
                ]
              )
            ],
          ),
        )
      ),
    );
  }
}
