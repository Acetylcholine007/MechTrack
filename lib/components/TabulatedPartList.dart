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

class TabulatedPartList extends StatelessWidget {
  final List<String> columns;
  final List<Part> parts;
  final Field fields;
  final Function(Part) viewPart;

  const TabulatedPartList({
    Key key,
    this.parts,
    this.fields,
    this.columns,
    this.viewPart
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uniqueColumns = [...{...columns}];
    // final uniqueColumns = columns;

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
                    children: uniqueColumns.map((col) => PartTableText(fields.fields[col], 'LABEL')).toList()
                )
              ] + parts.asMap().entries.map((partEntry) {
                double shifter = partEntry.key % 2 == 0 ? .2 : .3;
                return TableRow(
                    decoration: BoxDecoration(
                        color: theme.backgroundColor.lighten(shifter)
                    ),
                    children: uniqueColumns.map((col) => GestureDetector(
                      onTap: () => viewPart(partEntry.value),
                      child: PartTableText(
                          partEntry.value.fields[col].toString(), 'CONTENT'),
                    )).toList()
                );
              }).toList()
          )
      ),
    );
  }
}

