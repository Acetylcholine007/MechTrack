import 'package:flutter/material.dart';
import 'package:mech_track/shared/decorations.dart';

class PartSearchBar extends StatelessWidget {
  const PartSearchBar({Key key,
    this.categoryHandler,
    this.searchHandler,
    this.category,
    this.context}) : super(key: key);
  final Function(String) categoryHandler;
  final Function(String) searchHandler;
  final String category;
  final BuildContext context;
  final categories = const {
    'pid': 'Part ID',
    'assetAccountCode': 'Asset Account Code',
    'process': 'Process',
    'subProcess': 'Subprocess',
    'description': 'Description',
    'type': 'Type',
    'criticality': 'Criticality',
    'status': 'Status',
    'yearInstalled': 'Year Installed',
    'description2': 'Description 2',
    'brand': 'Brand',
    'model': 'Model',
    'spec1': 'Spec 1',
    'spec2': 'Spec 2',
    'dept': 'Dept',
    'facility': 'Facility',
    'facilityType': 'Facility Type',
    'sapFacility': 'SAP Facility',
    'criticalByPM': 'Critical by PM',
  };

  void filterHandler() {
    String newCat = category;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Search Selector'),
          content: DropdownButtonFormField(
            value: newCat,
            items: categories.keys.map((String category) => DropdownMenuItem(
                value: category,
                child: Text(categories[category])
            )).toList(),
            onChanged: (value) => newCat = value,
            decoration: formFieldDecoration,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  categoryHandler(newCat);
                  Navigator.pop(context);
                },
                child: Text('OK')
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: ListTile(
          title: TextFormField(
            initialValue: "",
            decoration: searchFieldDecoration,
            onChanged: searchHandler,
          ),
          trailing: IconButton(
            icon: Icon(Icons.filter_list_rounded), onPressed: filterHandler
          ),
        ),
      ),
    );
  }
}
