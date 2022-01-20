import 'package:flutter/material.dart';
import 'package:mech_track/shared/decorations.dart';

class AccountSearchBar extends StatefulWidget {
  const AccountSearchBar({Key key,
    this.categoryHandler,
    this.searchHandler,
    this.category,
    this.context}) : super(key: key);
  final Function(String) categoryHandler;
  final Function(String) searchHandler;
  final String category;
  final BuildContext context;

  @override
  State<AccountSearchBar> createState() => _AccountSearchBarState();
}

class _AccountSearchBarState extends State<AccountSearchBar> {
  TextEditingController controller = TextEditingController();

  final categories = const [
    'Full Name',
    'Username',
    'Email',
  ];

  void filterHandler() {
    String newCat = widget.category;

    showDialog(
        context: widget.context,
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
                  widget.categoryHandler(newCat);
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
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Expanded(
            flex: 2, child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 4, 8),
              child: TextFormField(
                controller: controller,
                decoration: searchFieldDecoration.copyWith(
                  suffixIcon: IconButton(onPressed: () {
                    controller.text = "";
                    widget.searchHandler("");
                  }, icon: Icon(Icons.highlight_off_rounded))
                ),
                onChanged: widget.searchHandler,
              ),
            ),
          ),
          Expanded(flex: 1, child: Padding(
            padding: EdgeInsets.fromLTRB(4, 8, 8, 8),
            child: DropdownButtonFormField(
              menuMaxHeight: 500,
              isExpanded: true,
              value: widget.category,
              items: categories.map((String category) => DropdownMenuItem(
                value: category,
                child: Text(category, overflow: TextOverflow.ellipsis)
              )).toList(),
              onChanged: (value) => widget.categoryHandler(value),
              decoration: searchFieldDecoration,
            ),
          ))
        ],
      ),
    );
  }
}
