import 'package:flutter/material.dart';
import 'package:mech_track/BLoCs/LocalDatabaseBloc.dart';
import 'package:mech_track/components/PartTableText.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/services/DatabaseService.dart';
import 'package:mech_track/shared/decorations.dart';
import 'dart:async';

class PartEditor extends StatefulWidget {
  final bool isLocal;
  final Part oldPart;
  final PartsBloc bloc;
  final AccountData account;
  final Field fields;

  PartEditor({this.isLocal, this.oldPart, this.bloc, this.account, this.fields});

  @override
  _PartEditorState createState() => _PartEditorState();
}

class _PartEditorState extends State<PartEditor> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> newPart;
  List<String> fields;
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    newPart = widget.oldPart.fields;
    fields = widget.fields.fields.keys.toList().sublist(1);
  }

  _onTextChanged(dynamic query, String selector) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 0), () {
      newPart[selector] = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    void deleteHandler() async {
      String result = '';
      if(widget.isLocal) {
        result = await widget.bloc.deletePart(widget.oldPart.partNo.toString());
      } else {
        result = await DatabaseService.db.removePart(widget.oldPart.partNo.toString());
      }

      if(result == 'SUCCESS') {
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Part'),
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
    }

    void saveHandler() async {
      if(_formKey.currentState.validate()) {
        String result = '';
        if(widget.isLocal) {
          result = await widget.bloc.editPart(Part(
            partNo: newPart['partNo'],
            fields: newPart,
          ));
        } else {
          result = await DatabaseService.db.editPart(Part(
            partNo: newPart['partNo'],
            fields: newPart['assetAccountCode']
          ));
        }

        if(result == 'SUCCESS') {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Edit Part'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Part'),
        actions: [
          IconButton(icon: Icon(Icons.delete), onPressed: deleteHandler),
          IconButton(icon: Icon(Icons.save), onPressed: saveHandler)
        ],
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
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                children: fields.map((field) => TableRow(
                  children: [
                    PartTableText(widget.fields.fields[field], 'LABEL'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,5),
                      child: TextFormField(
                        initialValue: newPart[field].toString(),
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
    );
  }
}
