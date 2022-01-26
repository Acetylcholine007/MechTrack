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
    final DataTableSource _data = MyData(
      parts, uniqueColumns, fields, theme, viewPart
    );

    return Container(
      constraints: BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            PaginatedDataTable(
              source: _data,
              rowsPerPage: parts.length < 10 ? parts.length : 10,
              showCheckboxColumn: false,
              showFirstLastButtons: true,
              columns: uniqueColumns.map((col) => DataColumn(
                label: Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(fields.fields[col],
                    style: theme.textTheme.headline6.
                    copyWith(fontWeight: FontWeight.bold),
                  )
                )
              )).toList(),
            ),
            SizedBox(height: 70)
          ],
        ),
      )
    );
  }
}

class MyData extends DataTableSource {
  List<Part> parts;
  List<String> columns;
  Field fields;
  ThemeData theme;
  Function viewPart;

  MyData(this.parts, this.columns, this.fields, this.theme, this.viewPart);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => parts.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int partIndex) {
    return DataRow(
      color: MaterialStateProperty.all(theme.backgroundColor.lighten(partIndex % 2 == 0 ? 0.2 : 0.3)),
      onSelectChanged: (bool selected) {
        viewPart(parts[partIndex]);
      },
      cells: List.generate(columns.length, (colIndex) => DataCell(
        Container(
          constraints: BoxConstraints(maxWidth: 250),
          child: Text(parts[partIndex].fields[columns[colIndex]].toString(),
            style: theme.textTheme.headline6.copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      ))
    );
  }
}

