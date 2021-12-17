import 'package:flutter/material.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/shared/decorations.dart';
import 'dart:async';

class PartEditor extends StatefulWidget {
  @override
  _PartEditorState createState() => _PartEditorState();
}

class _PartEditorState extends State<PartEditor> {
  final _formKey = GlobalKey<FormState>();
  Map newPart = {
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
  };
  Timer _debounce;

  _onSearchChanged(String query, String selector) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 0), () {
      newPart[selector] = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final part = Part(pid: 'X12', assetAccountCode: 'AS3D', process: 'Hello');

    return Scaffold(
      appBar: AppBar(
        title: Text('Part Editor'),
        actions: [
          IconButton(icon: Icon(Icons.delete), onPressed: (){}),
          IconButton(icon: Icon(Icons.save),
            onPressed: (){
              print(newPart['assetAccountCode']);
              print(newPart['description']);
            }
          ),
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
                        initialValue: part.assetAccountCode,
                        decoration: formFieldDecoration.copyWith(hintText: 'AAC'),
                        validator: (val) => val.isEmpty ? 'Enter AAC' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'assetAccountCode')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Process', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.process,
                        decoration: formFieldDecoration.copyWith(hintText: 'Process'),
                        validator: (val) => val.isEmpty ? 'Enter Process' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'process')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Subprocess', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.subProcess,
                        decoration: formFieldDecoration.copyWith(hintText: 'Subprocess'),
                        validator: (val) => val.isEmpty ? 'Enter Subprocess' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'subProcess')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Description', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.description,
                        decoration: formFieldDecoration.copyWith(hintText: 'Description'),
                        validator: (val) => val.isEmpty ? 'Enter Description' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'description')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Type', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.type,
                        decoration: formFieldDecoration.copyWith(hintText: 'Type'),
                        validator: (val) => val.isEmpty ? 'Enter Type' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'type')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Criticality', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.criticality,
                        decoration: formFieldDecoration.copyWith(hintText: 'Criticality'),
                        validator: (val) => val.isEmpty ? 'Enter Criticality' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'criticality')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Status', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.status,
                        decoration: formFieldDecoration.copyWith(hintText: 'Status'),
                        validator: (val) => val.isEmpty ? 'Enter Status' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'status')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Year Installed', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.yearInstalled,
                        decoration: formFieldDecoration.copyWith(hintText: 'Year Installed'),
                        validator: (val) => val.isEmpty ? 'Enter Year Installed' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'yearInstalled')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Description 2', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.description2,
                        decoration: formFieldDecoration.copyWith(hintText: 'Description 2'),
                        validator: (val) => val.isEmpty ? 'Enter Description 2' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'description2')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Brand', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.brand,
                        decoration: formFieldDecoration.copyWith(hintText: 'Brand'),
                        validator: (val) => val.isEmpty ? 'Enter Brand' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'brand')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Model', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.model,
                        decoration: formFieldDecoration.copyWith(hintText: 'Model'),
                        validator: (val) => val.isEmpty ? 'Enter AAC' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'model')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Spec 1', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.spec1,
                        decoration: formFieldDecoration.copyWith(hintText: 'Spec 1'),
                        validator: (val) => val.isEmpty ? 'Enter Spec 1' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'spec1')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Spec 2', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.spec2,
                        decoration: formFieldDecoration.copyWith(hintText: 'Spec 2'),
                        validator: (val) => val.isEmpty ? 'Enter Spec 2' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'spec2')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Dept', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.dept,
                        decoration: formFieldDecoration.copyWith(hintText: 'Dept'),
                        validator: (val) => val.isEmpty ? 'Enter Dept' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'dept')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Facility', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.facility,
                        decoration: formFieldDecoration.copyWith(hintText: 'Facility'),
                        validator: (val) => val.isEmpty ? 'Enter Facility' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'facility')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Facility Type', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.facilityType,
                        decoration: formFieldDecoration.copyWith(hintText: 'Facility Type'),
                        validator: (val) => val.isEmpty ? 'Enter Facility Type' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'facilityType')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('SAP Facility', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.sapFacility,
                        decoration: formFieldDecoration.copyWith(hintText: 'SAP Facility'),
                        validator: (val) => val.isEmpty ? 'SAP Facility' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'sapFacility')),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Text('Critical by PM', style: theme.textTheme.headline5),
                      TextFormField(
                        initialValue: part.criticalByPM,
                        decoration: formFieldDecoration.copyWith(hintText: 'Critical by PM'),
                        validator: (val) => val.isEmpty ? 'Enter Critical by PM' : null,
                        onChanged: (val) => setState(() => _onSearchChanged(val, 'criticalByPM')),
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
