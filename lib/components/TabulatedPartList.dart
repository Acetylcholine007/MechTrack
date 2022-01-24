import 'package:flutter/material.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/Part.dart';

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

    return Container(
      constraints: BoxConstraints.expand(),
      child: InteractiveViewer(
        panEnabled: false,
        constrained: true,
        scaleEnabled: true,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  headingRowColor: MaterialStateProperty.all(theme.primaryColor),
                  headingTextStyle: theme.textTheme.headline6.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  showCheckboxColumn: false,
                  columns: uniqueColumns.map((col) => DataColumn(
                      label: Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                            fields.fields[col],
                          )
                      )
                  )).toList(),
                  rows: List<DataRow>.generate(parts.length, (partIndex) => DataRow(
                      color: MaterialStateProperty.all(theme.backgroundColor.lighten(partIndex % 2 == 0 ? 0.2 : 0.3)),
                      onSelectChanged: (bool selected) {
                        viewPart(parts[partIndex]);
                      },
                      cells: List.generate(uniqueColumns.length, (colIndex) => DataCell(Container(
                          constraints: BoxConstraints(maxWidth: 250),
                          child: Text(parts[partIndex].fields[uniqueColumns[colIndex]].toString(),
                            style: theme.textTheme.headline6.copyWith(fontWeight: FontWeight.normal),
                          ),
                        ),
                      ))
                  ))
              )
          )
        ),
      )
    );
  }
}

