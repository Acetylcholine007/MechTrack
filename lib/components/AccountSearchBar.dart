import 'package:flutter/material.dart';
import 'package:mech_track/shared/decorations.dart';

class AccountSearchBar extends StatelessWidget {
  const AccountSearchBar({Key key, this.controller, this.categoryHandler, this.category,  this.context}) : super(key: key);
  final TextEditingController controller;
  final Function(String) categoryHandler;
  final String category;
  final BuildContext context;

  final categories = const [
    'Full Name',
    'Username',
    'Email',
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
