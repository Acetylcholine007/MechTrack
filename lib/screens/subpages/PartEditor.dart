import 'package:flutter/material.dart';
import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/services/DatabaseService.dart';
import 'package:mech_track/shared/decorations.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class PartEditor extends StatefulWidget {
  final bool isNew;
  final Part oldPart;

  PartEditor({this.isNew, this.oldPart});

  @override
  _PartEditorState createState() => _PartEditorState();
}

class _PartEditorState extends State<PartEditor> {
  final _formKey = GlobalKey<FormState>();
  Map newPart;
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    newPart = widget.isNew ?
      {
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

  _onTextChanged(String query, String selector) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 0), () {
      newPart[selector] = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = Provider.of<Account>(context);
    final DatabaseService _database = DatabaseService(uid: account.uid);

    void deleteHandler() async {
      await _database.removePart(widget.oldPart.pid);
      Navigator.pop(context);
      Navigator.pop(context);
    }

    void saveHandler() async {
      if(widget.isNew) {
        await _database.addPart(Part(
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
        Navigator.pop(context);
      } else {
        await _database.editPart(Part(
          pid: widget.oldPart.pid,
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
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? 'Create Part' : 'Edit Part'),
        actions: (widget.isNew ? <Widget>[] : <Widget>[
          IconButton(icon: Icon(Icons.delete), onPressed: deleteHandler),
        ]) +
        <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: saveHandler),
        ],
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(color: Colors.blueAccent, width: 1),
              children: [
                TableRow(
                    children: [
                      Text('AAC', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['assetAccountCode'],
                        decoration: formFieldDecoration.copyWith(hintText: 'AAC'),
                        validator: (val) => val.isEmpty ? 'Enter AAC' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'assetAccountCode')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Process', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['process'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Process'),
                        validator: (val) => val.isEmpty ? 'Enter Process' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'process')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Subprocess', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['subProcess'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Subprocess'),
                        validator: (val) => val.isEmpty ? 'Enter Subprocess' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'subProcess')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Description', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['description'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Description'),
                        validator: (val) => val.isEmpty ? 'Enter Description' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'description')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Type', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['type'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Type'),
                        validator: (val) => val.isEmpty ? 'Enter Type' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'type')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Criticality', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['criticality'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Criticality'),
                        validator: (val) => val.isEmpty ? 'Enter Criticality' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'criticality')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Status', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['status'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Status'),
                        validator: (val) => val.isEmpty ? 'Enter Status' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'status')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Year Installed', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['yearInstalled'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Year Installed'),
                        validator: (val) => val.isEmpty ? 'Enter Year Installed' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'yearInstalled')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Description 2', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['description2'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Description 2'),
                        validator: (val) => val.isEmpty ? 'Enter Description 2' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'description2')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Brand', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['brand'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Brand'),
                        validator: (val) => val.isEmpty ? 'Enter Brand' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'brand')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Model', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['model'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Model'),
                        validator: (val) => val.isEmpty ? 'Enter AAC' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'model')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Spec 1', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['spec1'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Spec 1'),
                        validator: (val) => val.isEmpty ? 'Enter Spec 1' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'spec1')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Spec 2', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['spec2'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Spec 2'),
                        validator: (val) => val.isEmpty ? 'Enter Spec 2' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'spec2')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Dept', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['dept'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Dept'),
                        validator: (val) => val.isEmpty ? 'Enter Dept' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'dept')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Facility', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['facility'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Facility'),
                        validator: (val) => val.isEmpty ? 'Enter Facility' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'facility')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Facility Type', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['facilityType'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Facility Type'),
                        validator: (val) => val.isEmpty ? 'Enter Facility Type' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'facilityType')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('SAP Facility', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['sapFacility'],
                        decoration: formFieldDecoration.copyWith(hintText: 'SAP Facility'),
                        validator: (val) => val.isEmpty ? 'SAP Facility' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'sapFacility')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Critical by PM', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: newPart['criticalByPM'],
                        decoration: formFieldDecoration.copyWith(hintText: 'Critical by PM'),
                        validator: (val) => val.isEmpty ? 'Enter Critical by PM' : null,
                        onChanged: (val) => setState(() => _onTextChanged(val, 'criticalByPM')),
                      ),
                    ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
