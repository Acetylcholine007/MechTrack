import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:mech_track/BLoCs/LocalDatabaseBloc.dart';
import 'package:mech_track/components/PartTableText.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/services/DatabaseService.dart';
import 'package:mech_track/shared/decorations.dart';
import 'dart:async';

class PartEditor extends StatefulWidget {
  final bool isNew;
  final bool isLocal;
  final Part oldPart;
  final PartsBloc bloc;
  final AccountData account;

  PartEditor({this.isNew, this.isLocal, this.oldPart, this.bloc, this.account});

  @override
  _PartEditorState createState() => _PartEditorState();
}

class _PartEditorState extends State<PartEditor> {
  final _formKey = GlobalKey<FormState>();
  Map newPart;
  Timer _debounce;

  String calculateHash(String data) {
    var bytes = utf8.encode(data); // data being hashed
    var digest = sha1.convert(bytes);
    print("Digest as hex string: $digest");
    print(digest.toString());
    return digest.toString();
  }

  @override
  void initState() {
    super.initState();
    newPart = widget.isNew ?
      {
        'partNo': null,
        'assetAccountCode': '',
        'process': '',
        'subProcess': '',
        'description': '',
        'type': '',
        'criticality': '',
        'status': '',
        'yearInstalled': '',
        'description2': '',
        'brand': '',
        'model': '',
        'spec1': '',
        'spec2': '',
        'dept': '',
        'facility': '',
        'facilityType': '',
        'sapFacility': '',
        'criticalByPM': ''
      } : {
      'partNo': widget.oldPart.partNo,
      'assetAccountCode': widget.oldPart.assetAccountCode,
      'process': widget.oldPart.process,
      'subProcess': widget.oldPart.subProcess,
      'description': widget.oldPart.description,
      'type': widget.oldPart.type,
      'criticality': widget.oldPart.criticality,
      'status': widget.oldPart.status,
      'yearInstalled': widget.oldPart.yearInstalled,
      'description2': widget.oldPart.description2,
      'brand': widget.oldPart.brand,
      'model': widget.oldPart.model,
      'spec1': widget.oldPart.spec1,
      'spec2': widget.oldPart.spec2,
      'dept': widget.oldPart.dept,
      'facility': widget.oldPart.facility,
      'facilityType': widget.oldPart.facilityType,
      'sapFacility': widget.oldPart.sapFacility,
      'criticalByPM': widget.oldPart.criticalByPM
    };
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
        if(widget.isNew) {
          String result = '';
          Part part = Part(
              partNo: newPart['partNo'],
              assetAccountCode: newPart['assetAccountCode'],
              process: newPart['process'],
              subProcess: newPart['subProcess'],
              description: newPart['description'],
              type: newPart['type'],
              criticality: newPart['criticality'],
              status: newPart['status'],
              yearInstalled: newPart['yearInstalled'],
              description2: newPart['description2'],
              brand: newPart['brand'],
              model: newPart['model'],
              spec1: newPart['spec1'],
              spec2: newPart['spec2'],
              dept: newPart['dept'],
              facility: newPart['facility'],
              facilityType: newPart['facilityType'],
              sapFacility: newPart['sapFacility'],
              criticalByPM: newPart['criticalByPM']
          );
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
          String result = '';
          if(widget.isLocal) {
            result = await widget.bloc.editPart(Part(
              partNo: newPart['partNo'],
              assetAccountCode: newPart['assetAccountCode'],
              process: newPart['process'],
              subProcess: newPart['subProcess'],
              description: newPart['description'],
              type: newPart['type'],
              criticality: newPart['criticality'],
              status: newPart['status'],
              yearInstalled: newPart['yearInstalled'],
              description2: newPart['description2'],
              brand: newPart['brand'],
              model: newPart['model'],
              spec1: newPart['spec1'],
              spec2: newPart['spec2'],
              dept: newPart['dept'],
              facility: newPart['facility'],
              facilityType: newPart['facilityType'],
              sapFacility: newPart['sapFacility'],
              criticalByPM: newPart['criticalByPM']
            ));
          } else {
            result = await DatabaseService.db.editPart(Part(
              partNo: newPart['partNo'],
              assetAccountCode: newPart['assetAccountCode'],
              process: newPart['process'],
              subProcess: newPart['subProcess'],
              description: newPart['description'],
              type: newPart['type'],
              criticality: newPart['criticality'],
              status: newPart['status'],
              yearInstalled: newPart['yearInstalled'],
              description2: newPart['description2'],
              brand: newPart['brand'],
              model: newPart['model'],
              spec1: newPart['spec1'],
              spec2: newPart['spec2'],
              dept: newPart['dept'],
              facility: newPart['facility'],
              facilityType: newPart['facilityType'],
              sapFacility: newPart['sapFacility'],
              criticalByPM: newPart['criticalByPM']));
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
        title: Text(widget.isNew ? 'Create Part' : 'Edit Part'),
        actions: (widget.isNew ? <Widget>[] : <Widget>[
          IconButton(icon: Icon(Icons.delete), onPressed: deleteHandler),
        ]) + [IconButton(icon: Icon(Icons.save), onPressed: saveHandler)],
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
                children: (widget.isNew ? <TableRow>[
                  TableRow(
                      children: [
                        PartTableText('Part No.', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: null,
                            decoration: formFieldDecoration.copyWith(hintText: 'Part No.'),
                            onChanged: (val) => setState(() => _onTextChanged(int.parse(val), 'partNo')),
                            validator: (val) => val.isEmpty ? 'Enter Part No' : null,
                          ),
                        ),
                      ]
                  ),
                ] : <TableRow>[]) + <TableRow>[
                  TableRow(
                      children: [
                        PartTableText('AAC', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['assetAccountCode'],
                            decoration: formFieldDecoration.copyWith(hintText: 'AAC'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'assetAccountCode')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Process', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['process'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Process'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'process')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Subprocess', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['subProcess'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Subprocess'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'subProcess')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Type', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['type'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Type'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'type')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Criticality', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['criticality'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Criticality'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'criticality')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Status', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['status'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Status'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'status')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Year Installed', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['yearInstalled'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Year Installed'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'yearInstalled')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Brand', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['brand'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Brand'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'brand')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Model', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['model'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Model'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'model')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Spec 1', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['spec1'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Spec 1'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'spec1')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Spec 2', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['spec2'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Spec 2'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'spec2')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Dept', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['dept'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Dept'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'dept')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Facility', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['facility'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Facility'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'facility')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Facility Type', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['facilityType'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Facility Type'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'facilityType')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('SAP Facility', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['sapFacility'],
                            decoration: formFieldDecoration.copyWith(hintText: 'SAP Facility'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'sapFacility')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Critical by PM', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            initialValue: newPart['criticalByPM'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Critical by PM'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'criticalByPM')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Description', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            initialValue: newPart['description'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Description'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'description')),
                          ),
                        ),
                      ]
                  ),
                  TableRow(
                      children: [
                        PartTableText('Description 2', 'LABEL'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,5),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            initialValue: newPart['description2'],
                            decoration: formFieldDecoration.copyWith(hintText: 'Description 2'),
                            onChanged: (val) => setState(() => _onTextChanged(val, 'description2')),
                          ),
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
