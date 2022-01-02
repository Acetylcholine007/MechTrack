import 'package:flutter/material.dart';
import 'package:mech_track/BLoCs/LocalDatabaseBloc.dart';
import 'package:mech_track/components/PartTableText.dart';
import 'package:mech_track/components/QRDisplay.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/screens/subpages/PartEditor.dart';

class PartViewer extends StatefulWidget {
  final Part part;
  final bool isLocal;
  final PartsBloc bloc;
  final AccountData account;

  PartViewer({this.part, this.isLocal, this.bloc, this.account});

  @override
  _PartViewerState createState() => _PartViewerState();
}

class _PartViewerState extends State<PartViewer> {
  @override
  Widget build(BuildContext context) {
    final part = widget.part;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Part Viewer'),
        actions: (!widget.isLocal && widget.account.accountType == 'EMPLOYEE' ? <Widget>[] :
        <Widget>[IconButton(icon: Icon(Icons.edit), onPressed: () =>
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PartEditor(
                isNew: false,
                isLocal: widget.isLocal,
                oldPart: widget.part,
                bloc: widget.bloc,
                account: widget.account
              )),
            ),
          )]) + <Widget>[
          IconButton(icon: Icon(Icons.qr_code), onPressed: () =>
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                QRDisplay(title: 'Part QR Code', data: part.partNo.toString() + '<=MechTrack=>' + part.partNo.toString())
              )
            )
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
        ),
        child: Column(
          children: [
            Expanded(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(color: theme.primaryColor, width: 1),
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                children: [
                TableRow(
                  children: [
                    PartTableText('Part No.', 'LABEL'),
                    PartTableText(part.partNo.toString(), 'CONTENT'),
                  ]
                ),
                TableRow(
                    children: [
                      PartTableText('AAC', 'LABEL'),
                      PartTableText(part.assetAccountCode, 'CONTENT'),
                    ]
                ),
                TableRow(
                    children: [
                      PartTableText('Process', 'LABEL'),
                      PartTableText(part.process, 'CONTENT'),
                    ]
                ),
                  TableRow(
                      children: [
                        PartTableText('Subprocess', 'LABEL'),
                        PartTableText(part.subProcess, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Type', 'LABEL'),
                        PartTableText(part.type, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Criticality', 'LABEL'),
                        PartTableText(part.criticality, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Status', 'LABEL'),
                        PartTableText(part.status, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Year Installed', 'LABEL'),
                        PartTableText(part.yearInstalled, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Brand', 'LABEL'),
                        PartTableText(part.brand, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Model', 'LABEL'),
                        PartTableText(part.model, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Spec 1', 'LABEL'),
                        PartTableText(part.spec1, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Spec 2', 'LABEL'),
                        PartTableText(part.spec2, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Dept', 'LABEL'),
                        PartTableText(part.dept, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Facility', 'LABEL'),
                        PartTableText(part.facility, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Facility Type', 'LABEL'),
                        PartTableText(part.facilityType, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('SAP Facility', 'LABEL'),
                        PartTableText(part.sapFacility, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Critical by PM', 'LABEL'),
                        PartTableText(part.criticalByPM, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Description', 'LABEL'),
                        PartTableText(part.description, 'CONTENT'),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Description 2', 'LABEL'),
                        PartTableText(part.description2, 'CONTENT'),
                      ]
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
