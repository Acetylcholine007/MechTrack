import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/services/PartService.dart';
import 'package:mech_track/shared/decorations.dart';
import 'package:mech_track/components/PartTableText.dart';

class MultiSearchOverlay extends StatefulWidget {
  final Field fields;
  final Map<String, String> queries;
  final Map<String, TextEditingController> controllers;
  final Function(Map<String, String>, Map<String, TextEditingController>) multiQueryHandler;
  final List<Part> parts;
  const MultiSearchOverlay({
    Key key,
    this.fields,
    this.queries,
    this.controllers,
    this.multiQueryHandler,
    this.parts
  }) : super(key: key);

  @override
  _MultiSearchOverlayState createState() => _MultiSearchOverlayState();
}

class _MultiSearchOverlayState extends State<MultiSearchOverlay> {
  List<String> fieldKeys;
  List<String> remainingKeys;
  Map<String, String> queries = {};
  Map<String, TextEditingController> controllers = {};
  String dropdownValue;

  void setRemainingKeys({String field, bool isAdd = false}) {
    setState(() {
      if(isAdd) {
        remainingKeys.add(field);
        dropdownValue = remainingKeys[0];
      } else {
        remainingKeys.remove(dropdownValue);
        if(remainingKeys.isNotEmpty) {
          dropdownValue = remainingKeys[0];
        } else {
          dropdownValue = "";
        }
      }
    });
  }

  @override
  void initState() {
    fieldKeys = widget.fields.fields.keys.toList();
    queries = widget.queries;
    controllers = widget.controllers;
    remainingKeys = fieldKeys.where((key) => !widget.queries.keys.toList().contains(key)).toList();
    dropdownValue = remainingKeys[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
        ),
        constraints: BoxConstraints.expand(),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  Expanded(
                    flex: 3, child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 4, 8),
                      child: DropdownButtonFormField(
                        menuMaxHeight: 500,
                        isExpanded: true,
                        value: dropdownValue,
                        decoration: searchFieldDecoration,
                        items: remainingKeys.map((key) => DropdownMenuItem(
                          child: Text(widget.fields.fields[key], overflow: TextOverflow.ellipsis),
                          value: key,
                        )).toList(),
                        onChanged: (val) => setState(() {
                          dropdownValue = val;
                        }),
                      ),
                    ),
                  ),
                  Padding(
                  padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add_circle_outlined, color: theme.primaryColor,),
                      style: barButtonDecoration.copyWith(
                        backgroundColor: MaterialStateProperty.all(theme.cardColor),
                        alignment: Alignment.centerLeft
                      ),
                      label: Text('ADD FIELD', style: theme.textTheme.button.copyWith(color: theme.primaryColor)),
                      onPressed: remainingKeys.isNotEmpty ? () {
                        setState(() {
                          queries[dropdownValue] = '';
                          controllers[dropdownValue] = new TextEditingController();
                          setRemainingKeys(field: dropdownValue, isAdd: false);
                        });
                      } : null,
                    ),
                  ),
                  Padding(
                  padding: EdgeInsets.fromLTRB(4, 8, 8, 8),
                    child: ElevatedButton.icon(
                    icon: Icon(Icons.search_rounded, color: theme.primaryColor,),
                    style: barButtonDecoration.copyWith(
                      backgroundColor: MaterialStateProperty.all(theme.cardColor),
                        alignment: Alignment.centerLeft
                    ),
                    label: Text('SEARCH', style: theme.textTheme.button.copyWith(color: theme.primaryColor)),
                      onPressed: () {
                        widget.multiQueryHandler(queries, controllers);
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: queries.isNotEmpty ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                        2: IntrinsicColumnWidth(),
                      },
                      children: queries.keys.map((field) =>
                          TableRow(
                              children: [
                                PartTableText(widget.fields.fields[field], 'LABEL'),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: TypeAheadField(
                                      debounceDuration: Duration(microseconds: 500),
                                      textFieldConfiguration: TextFieldConfiguration(
                                        onChanged: (val) => setState(() {
                                          queries[field] = val;
                                        }),
                                        decoration: formFieldDecoration.copyWith(hintText: 'Query'),
                                        controller: controllers[field]
                                      ),
                                      suggestionsCallback: (String pattern) async {
                                        return PartService.getPartSuggestions(pattern, widget.parts, field);
                                      },
                                      itemBuilder: (context, Part suggestion) {
                                        return ListTile(
                                          title: Text(suggestion.fields[field].toString()),
                                        );
                                      },
                                      onSuggestionSelected: (Part suggestion) {
                                        setState(() {
                                          controllers[field].text = suggestion.fields[field].toString();
                                          queries[field] = suggestion.fields[field].toString();
                                        });
                                      },
                                      noItemsFoundBuilder: (context) => Container(
                                        height: 50,
                                        child: Center(
                                          child: Text('No category value found.'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: IconButton(
                                    icon: Icon(Icons.remove_circle_rounded),
                                    onPressed: () => setState(() {
                                      queries.remove(field);
                                      controllers.remove(field);
                                      setRemainingKeys(field: field, isAdd: true);
                                    }),
                                  ),
                                ),
                              ]
                          )
                      ).toList()
                  ),
                ),
              ) : Center(
                child: Text(
                  'Add fields to perform multi-search',
                  style: theme.textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
