import 'package:flutter/material.dart';
import 'package:mech_track/models/Part.dart';

class PartViewer extends StatefulWidget {
  @override
  _PartViewerState createState() => _PartViewerState();
}

class _PartViewerState extends State<PartViewer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final part = Part(pid: 'X12', assetAccountCode: 'AS3D', process: 'Hello');

    return Scaffold(
      appBar: AppBar(
        title: Text('Part Viewer'),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: (){}),
          IconButton(icon: Icon(Icons.qr_code), onPressed: (){}),
        ],
      ),
      body: Container(
        child: Table(
          border: TableBorder.all(color: Colors.blueAccent, width: 1),
          children: [
          TableRow(
            children: [
              Text('Part ID', style: theme.textTheme.headline5),
              Text(part.pid, style: theme.textTheme.headline6),
            ]
          ),
          TableRow(
              children: [
                Text('AAC', style: theme.textTheme.headline5),
                Text(part.assetAccountCode, style: theme.textTheme.headline6),
              ]
          ),
          TableRow(
              children: [
                Text('Process', style: theme.textTheme.headline5),
                Text(part.process, style: theme.textTheme.headline6),
              ]
          ),
            TableRow(
                children: [
                  Text('Subprocess', style: theme.textTheme.headline5),
                  Text(part.subProcess, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Description', style: theme.textTheme.headline5),
                  Text(part.description, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Type', style: theme.textTheme.headline5),
                  Text(part.type, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Criticality', style: theme.textTheme.headline5),
                  Text(part.criticality, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Status', style: theme.textTheme.headline5),
                  Text(part.status, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Year Installed', style: theme.textTheme.headline5),
                  Text(part.yearInstalled, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Description 2', style: theme.textTheme.headline5),
                  Text(part.description2, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Brand', style: theme.textTheme.headline5),
                  Text(part.brand, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Model', style: theme.textTheme.headline5),
                  Text(part.model, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Spec 1', style: theme.textTheme.headline5),
                  Text(part.spec1, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Spec 2', style: theme.textTheme.headline5),
                  Text(part.spec2, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Dept', style: theme.textTheme.headline5),
                  Text(part.dept, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Facility', style: theme.textTheme.headline5),
                  Text(part.facility, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Facility Type', style: theme.textTheme.headline5),
                  Text(part.facilityType, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('SAP Facility', style: theme.textTheme.headline5),
                  Text(part.sapFacility, style: theme.textTheme.headline6),
                ]
            ),
            TableRow(
                children: [
                  Text('Critical by PM', style: theme.textTheme.headline5),
                  Text(part.criticalByPM, style: theme.textTheme.headline6),
                ]
            ),
          ],
        ),
      ),
    );
  }
}
