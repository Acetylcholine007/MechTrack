import 'package:flutter/material.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/components/PartTableText.dart';

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

class TabulatedPartList extends StatefulWidget {
  final List<Part> parts;
  final Field fields;

  const TabulatedPartList({Key key, this.parts, this.fields}) : super(key: key);

  @override
  _TabulatedPartListState createState() => _TabulatedPartListState();
}

class _TabulatedPartListState extends State<TabulatedPartList> {
  List<String> fieldKeys;
  List<String> onTrackFields;

  @override
  void initState() {
    super.initState();
    fieldKeys = widget.fields.fields.keys.toList();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(color: theme.backgroundColor, width: 1),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
          },
          children: <TableRow>[
            TableRow(
              children: [
              PartTableText(widget.fields.fields[fieldKeys[0]], 'LABEL'),
              PartTableText(widget.fields.fields[fieldKeys[1]], 'LABEL'),
              ]
            )
          ] + widget.parts.asMap().entries.map((partEntry) {
            double shifter = partEntry.key % 2 == 0 ? .2 : .3;
            return TableRow(
                decoration: BoxDecoration(
                    color: theme.backgroundColor.lighten(shifter)
                ),
                children: [
                  PartTableText(
                      partEntry.value.fields[fieldKeys[0]].toString(), 'LABEL'),
                  PartTableText(
                      partEntry.value.fields[fieldKeys[1]].toString(), 'CONTENT'),
                ]
            );
          }
          ).toList()
        )
      ),
    );
  }
}
