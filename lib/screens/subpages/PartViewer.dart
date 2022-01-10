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
                children: part.fields.keys.map((field) => TableRow(
                  children: [
                    PartTableText(field, 'LABEL'),
                    PartTableText(part.fields[field].toString(), 'CONTENT'),
                  ]
                )).toList()
              ),
            ),
          ],
        ),
      ),
    );
  }
}
