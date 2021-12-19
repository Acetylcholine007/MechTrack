import 'package:flutter/material.dart';
import 'package:mech_track/shared/decorations.dart';

class PartSearchBar extends StatelessWidget {
  const PartSearchBar({Key key, this.controller, this.categoryHandler, this.category, this.context}) : super(key: key);
  final TextEditingController controller;
  final Function(String) categoryHandler;
  final String category;
  final BuildContext context;
  final categories = const [
    'Part No.',
    'Asset Account Code',
    'Process',
    'Subprocess',
    'Description',
    'Type',
    'Criticality',
    'Status',
    'Year Installed',
    'Description 2',
    'Brand',
    'Model',
    'Spec 1',
    'Spec 2',
    'Dept',
    'Facility',
    'Facility Type',
    'SAP Facility',
    'Critical by PM',
  ];

  void filterHandler() {
    String newCat = category;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Search Selector'),
          content: DropdownButtonFormField(
            value: newCat,
            items: categories.map((String category) => DropdownMenuItem(
                value: category,
                child: Text(category)
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
            controller: controller,
            decoration: searchFieldDecoration
              .copyWith(
              suffixIcon: IconButton(
                icon: Icon(Icons.highlight_off), onPressed: () => controller.clear()
              )
            )
          ),
          trailing: IconButton(
            icon: Icon(Icons.filter_list_rounded), onPressed: filterHandler
          ),
        ),
      ),
    );
  }
}
