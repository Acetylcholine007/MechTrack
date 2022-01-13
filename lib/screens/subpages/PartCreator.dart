import 'package:flutter/material.dart';
import 'package:mech_track/BLoCs/LocalDatabaseBloc.dart';
import 'package:mech_track/components/PartTableText.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/services/DatabaseService.dart';
import 'package:mech_track/shared/decorations.dart';
import 'dart:async';

class PartCreator extends StatefulWidget {
  final bool isLocal;
  final PartsBloc bloc;
  final AccountData account;
  final Field fields;

  PartCreator({this.isLocal, this.bloc, this.account, this.fields});

  @override
  _PartCreatorState createState() => _PartCreatorState();
}

class _PartCreatorState extends State<PartCreator> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> newPart;
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    newPart = { for (var field in widget.fields.fields.keys) field: '' };
  }

  _onTextChanged(dynamic query, String selector) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 0), () {
      newPart[selector] = query;
    });
  }

  @override
  Widget build(BuildContext context) {

    void saveHandler() async {
      if(_formKey.currentState.validate()) {
          String result = '';
          Part part = Part.withHash(newPart);
          result = widget.isLocal ?
          await widget.bloc.addPart(part, 'SAFE') :
          await DatabaseService.db.addPart(part, 'SAFE');

          if(result == 'SUCCESS') {
            Navigator.pop(context);
          } else if(result == 'EXIST') {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Add Part'),
                  content: Text('Part already exist'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          String newResult =  widget.isLocal ?
                          await widget.bloc.addPart(part, 'APPEND') :
                          await DatabaseService.db.addPart(part, 'APPEND');

                          if(newResult == 'SUCCESS') {
                            Navigator.pop(context);
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Add Part'),
                                  content: Text(newResult),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK')
                                    )
                                  ],
                                )
                            );
                          }
                        },
                        child: Text('APPEND')
                    ),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          String newResult =  widget.isLocal ?
                          await widget.bloc.addPart(part, 'REPLACE') :
                          await DatabaseService.db.addPart(part, 'REPLACE');

                          if(newResult == 'SUCCESS') {
                            Navigator.pop(context);
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Add Part'),
                                  content: Text(newResult),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK')
                                    )
                                  ],
                                )
                            );
                          }
                        },
                        child: Text('REPLACE')
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('SKIP')
                    ),
                  ],
                )
            );
          } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Add Part'),
                  content: Text(result),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK')
                    )
                  ],
                )
            );
          }
      } else {
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Fill up Part No.'),
          action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Part'),
          actions:[IconButton(icon: Icon(Icons.save), onPressed: saveHandler)],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: widget.fields.fields.keys.toList().map((field) => TableRow(
                    children: [
                      PartTableText(widget.fields.fields[field], 'LABEL'),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,5),
                        child: TextFormField(
                          initialValue: null,
                          decoration: formFieldDecoration.copyWith(hintText: widget.fields.fields[field]),
                          onChanged: (val) => setState(() => _onTextChanged(val, field)),
                        ),
                      ),
                    ]
                  )).toList()
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
