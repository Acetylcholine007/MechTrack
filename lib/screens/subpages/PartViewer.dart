import 'package:flutter/material.dart';
import 'package:mech_track/BLoCs/LocalDatabaseBloc.dart';
import 'package:mech_track/components/PartTableText.dart';
import 'package:mech_track/components/QRDisplay.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/screens/subpages/PartEditor.dart';

extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
    hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

class PartViewer extends StatefulWidget {
  final Part part;
  final bool isLocal;
  final PartsBloc bloc;
  final AccountData account;
  final Field fields;

  PartViewer({this.part, this.isLocal, this.bloc, this.account, this.fields});

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
                account: widget.account,
                fields: widget.fields
              )),
            ),
          )]) + <Widget>[
          IconButton(icon: Icon(Icons.qr_code_2_rounded), onPressed: () =>
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
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(color: theme.backgroundColor, width: 1),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: widget.fields.fields.keys.toList().asMap().entries.map((field) {
              double shifter = field.key % 2 == 0 ? .2 : .3;
              return TableRow(
                decoration: BoxDecoration(
                    color: theme.backgroundColor.lighten(shifter)
                ),
                children: [
                  PartTableText(
                      widget.fields.fields[field.value], 'LABEL'),
                  PartTableText(
                      part.fields[field.value].toString(), 'CONTENT'),
                ]
              );
            }
            ).toList()
          ),
        ),
      ),
    );
  }
}
